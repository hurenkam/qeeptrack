import QtQuick 2.5
import QtQuick.LocalStorage 2.0

Item {
    id: root
    property string filename: ""
    property string description: ""
    property int estimatedsize: 1000000
    property string version: ""
    property string prefix: ""

    function initialize(db) {
        if (!db) {
            console.log("db not available while trying to initialize, ignoring.")
            return
        }

        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(id TEXT, value TEXT)');
            } )
    }

    function setValue(id,value) {
        if (!db) {
            console.log("db not available while trying to save setting",id,", ignoring.")
            return
        }

        db.transaction(
            function(tx) {
                var result = tx.executeSql('SELECT * FROM Settings WHERE id=?', prefix+id);
                if (result.rows.length > 0) {
                    tx.executeSql('UPDATE Settings SET value=? WHERE id=?', [ value, prefix+id ]);
                    console.log("changed setting",prefix+id,"to value",value)
                }
                else {
                    tx.executeSql('INSERT INTO Settings VALUES(?, ?)', [ prefix+id, value ]);
                    console.log("stored setting",prefix+id,"with value",value)
                }
            }
        )
    }

    function getValue(id,defaultvalue) {
        var value = defaultvalue
        if (!db) {
            console.log("db not available while trying to retrieve setting",prefix+id,", returning default value",defaultvalue)
            return value
        }

        db.transaction(
            function(tx) {
                var result = tx.executeSql('SELECT * FROM Settings WHERE id=?', prefix+id);
                if (result.rows.length > 0) {
                    console.log("retrieved setting",prefix+id,"with value",result.rows.item(0).value)
                    value = result.rows.item(0).value
                } else {
                    console.log("setting",prefix+id,"does not exist, returning default value",defaultvalue)
                    setValue(id,defaultvalue)
                }
            }
        )
        return value
    }

    function dump() {
        if (!db) {
            console.log("db not available while trying to dump.")
            return
        }

        db.transaction(
            function(tx) {
                var result = tx.executeSql('SELECT * FROM Settings');
                for (var i=0; i<result.rows.length; i++)
                {
                    console.log("setting:",result.rows.item(i).id,"=",result.rows.item(i).value)
                }
            }
        )
    }

    property var db
    Component.onCompleted: {
        console.log("opening database",root.filename, root.version, root.description)
        db = LocalStorage.openDatabaseSync(root.filename, "", root.description, root.estimatedsize, root.initialize);
        //dump()
    }
}

