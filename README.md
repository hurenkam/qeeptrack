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
 * Compass
   * Heading
   * Course
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
 * Levels
   * Compass calibration 
 * Any gauge can be put in any spot (gauge position is not yet persistent)
 * Options now work and are persistent over restart

## Bugs: ##
 * PageStack push/pop animation doesn't seem to work (options screen)

## Todo: ##
 * Monitor
   * Waypoint
   * Route
 * Clock
   * Remaining time
 * Compass
   * Bearing to waypoint (or next routepoint)
 * Speedometer
   * Ascent/Descent speed
 * Altimeter
   * Average altitude
 * Distance
   * Total
   * Remaining distance
 * Battery level / horizontal & vertical accuracy levels
 * Satellite view (it seems Qt on iOS does not support this, so will probably work on android only)
 * MapView
