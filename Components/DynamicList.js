// dynamiclist.js
var jList = new Array()

function getList() {
    return jList
}

function getItem(index) {
    return jList[index]
}

function addItem(item) {
    jList.push(item)
}

function count() {
    return jList.length
}

function clear() {
    for (var i=0; i<jList.length; i++) {
        jList[i].destroy()
    }
    jList = []
}
