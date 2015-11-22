# QeepTrack
Advanced GPS dashboard with altimeter, speedometer and compass.

## Works: ##
 * Target platforms
   * Macbook/iOS Simulator
   * Macbook/OSX Desktop
   * PC/Android Simulator
   * PC/Windows Desktop
   * iPhone 6s
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
 * Datums
   * WGS84
   * UTM/WGS84 (used in e.g. french ign maps)
   * Amersfoort RD new (dutch)

## Bugs: ##
 * PageStack push/pop animation doesn't seem to work (options screen)

## Todo: ##
 * MapView
   * Create route
 * Datums
   * UTM/ED50 (spanish pyrenees)
   * UTM/WGS84 exceptions (zones 32V, 31X, 33X, 35X)
 * MonitorModel
   * Route (remaining distance, remaining time)
 * Speedometer
   * Ascent/Descent speed
 * Altimeter
   * Average altitude
 * Battery level / horizontal & vertical accuracy levels
 * Satellite view (it seems Qt on iOS does not support this, so will probably work on android only)
