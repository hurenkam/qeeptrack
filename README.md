# QeepTrack
Advanced GPS dashboard with altimeter, speedometer and compass.

## Works: ##
 * Target platforms
   * Macbook/iOS Simulator
   * Macbook/OSX Desktop
   * PC/Android Simulator
   * PC/Windows Desktop
   * iPhone 6s
   * iPad 3
 * Clock
   * Current time
   * Trip time
   * Remaining time (to waypoint)
 * Compass
   * Heading
   * Course
   * Bearing (to waypoint)
 * Speedometer
   * Current speed
   * Minimum speed
   * Maximum speed
   * Average speed
 * Altimeter
   * Current altitude
   * Minimum altitude
   * Maximum altitude
   * Ascent
   * Descent
 * Distancemeter
   * Trip distance
   * Total distance
   * Remaining distance (to waypoint)
 * Levels
   * Compass calibration 
 * Any gauge can be put in any spot
 * Options now work and are persistent over restart (gauge positions also)
 * MapView
   * Map type selection
   * Scroll & Zoom
   * Follow me
   * Select waypoint
   * Show distance between map center and waypoint
   * Allow direct coordinate input (in currently selected datum coordinates) to select position
 * Datums
   * WGS84
   * UTM/WGS84 (used in french ign maps)
   * UTM/ED50 (used in spanish maps)
   * Amersfoort RD new (dutch national grid)

## Bugs: ##
 * PageStack push/pop animation doesn't seem to work (options screen)
 * Remaining time to waypoint calculation is not working as expected

## Todo: ##
 * User Interface
   * Make UI themable
 * Waypoints
   * Store more than one waypoint
 * Routes/Tracks
   * Import
   * Show on map
   * Create on map
   * Record
   * Export
   * Add metadata
   * Remaining distance from current position
   * Remaining time from current position
 * Datums
   * UTM exceptions (zones 32V, 31X, 33X, 35X)
   * Store the definitions in a database rather than hardcoded
   * Edit/Add/Remove datum proj4 definition
   * Display Lattitude/Longitude:
     * Decimal (current)
     * Degrees, minutes
     * Degrees, minutes, seconds
   * Display Northing/Easting, X/Y:
     * km
     * m (current)
 * Speedometer
   * Ascent/Descent speed
   * Specify units:
     * km/h (current)
     * mph
     * m/s
     * min/km
   * More scales
     * 0-10 (current)
     * 0-20
     * 0-50
     * 0-100
     * 0-200 (current)
     * auto-scale up
 * Altimeter
   * Average altitude
   * Specify units:
     * m (current)
     * feet
 * Distancemeter
   * Specify units:
     * km (current)
     * m
     * miles
     * feet
 * Battery level / horizontal & vertical accuracy levels
 * Satellite view (it seems Qt on iOS does not support this, so will probably work on android only)

## License/Copyright
 * Unless explicitly stated otherwise, the source code is licensed under GPLv2. (http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
 * Unless explicitly stated otherwise, all creative works (images, documentation, icons, etc) are licensed under Creative Commons Attribution/Share Alike (http://creativecommons.org/licenses/by-sa/4.0/).
