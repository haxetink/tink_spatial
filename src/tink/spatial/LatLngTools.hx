package tink.spatial;

import tink.s2d.*;
import Math.*;

/**
 * Common calculations for Lat/Lng points.
 * - All input/output angles are in DEGREES.
 * - All input/output distances are normalized, wrt the sphere radius.
 *   (For reference, the Earth's mean radius is 6371009 meters. https://en.wikipedia.org/wiki/Earth_radius#Mean_radius)
 */
class LatLngTools {
	static inline var TO_RADIANS = 3.14159265359 / 180;
	static inline var TO_DEGREES = 180 / 3.14159265359;

	/**
	 * Great-circle distance between two points
	 * @param origin
	 * @param destination
	 */
	// https://www.movable-type.co.uk/scripts/latlong.html#ortho-dist
	public static function distance(origin:Point, destination:Point) {
		var lat1 = origin.latitude * TO_RADIANS;
		var lat2 = destination.latitude * TO_RADIANS;
		var lng1 = origin.longitude * TO_RADIANS;
		var lng2 = destination.longitude * TO_RADIANS;
		var sdlat = sin((lat1 - lat2) / 2);
		var sdlng = sin((lng1 - lng2) / 2);
		var a = sdlat * sdlat + cos(lat1) * cos(lat2) * sdlng * sdlng;
		return 2 * atan2(sqrt(a), sqrt(1 - a));
	}

	/**
	 * Initial bearing to travel from one point to another, along the great-circle path
	 * @param origin
	 * @param destination
	 */
	// https://www.movable-type.co.uk/scripts/latlong.html#bearing
	public static function initialBearing(origin:Point, destination:Point) {
		var lat1 = origin.latitude * TO_RADIANS;
		var lat2 = destination.latitude * TO_RADIANS;
		var lng1 = origin.longitude * TO_RADIANS;
		var lng2 = destination.longitude * TO_RADIANS;
		var y = sin(lng2 - lng1) * cos(lat2);
		var x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lng2 - lng1);
		return atan2(y, x) * TO_DEGREES;
	}

	/**
	 * Destination point given distance and initial bearing
	 * @param distance great-circle distance
	 * @param initialBearing initial bearing in degrees
	 */
	// https://www.movable-type.co.uk/scripts/latlong.html#dest-point
	public static function destination(origin:Point, distance:Float, initialBearing:Float) {
		var lat1 = origin.latitude * TO_RADIANS;
		var lng1 = origin.longitude * TO_RADIANS;
		var bearing = initialBearing * TO_RADIANS;
		var lat2 = asin(sin(lat1) * cos(distance) + cos(lat1) * sin(distance) * cos(bearing));
		var lng2 = lng1 + atan2(sin(bearing) * sin(distance) * cos(lat1), cos(distance) - sin(lat1) * sin(lat2));
		return Point.latLng(lat2 * TO_DEGREES, lng2 * TO_DEGREES);
	}
}
