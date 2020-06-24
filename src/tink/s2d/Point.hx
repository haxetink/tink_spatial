package tink.s2d;

import tink.spatial.Util.format;

@:observable
abstract Point(Array<Float>) {
	public var x(get, never):Float;
	public var y(get, never):Float;
	public var latitude(get, never):Float;
	public var longitude(get, never):Float;

	inline function get_x()
		return this[0];

	inline function get_y()
		return this[1];

	inline function get_latitude()
		return y;

	inline function get_longitude()
		return x;

	inline function new(x, y)
		this = [x, y];

	public static inline function xy(x, y)
		return new Point(x, y);

	public static inline function latLng(lat, lng)
		return new Point(lng, lat);

	public inline function translateXY(dx, dy)
		return xy(x + dx, y + dy);

	public inline function translateLatLng(lat, lng)
		return latLng(latitude + lat, longitude + lng);

	public inline function withZ(z:Float)
		return tink.s3d.Point.xyz(x, y, z);

	public function isEmpty()
		return this.length == 0 || (Math.isNaN(x) && Math.isNaN(y));

	public function toString(dp = 2):String
		return '[${format(x, dp)}, ${format(y, dp)}]';

	public function toWkt():String
		return isEmpty() ? 'POINT EMPTY' : 'POINT(${toWktParams()})';

	inline function toWktParams():String
		return '$x $y';

	public static function interpolate(points:Array<{coordinates:Point, weight:Float}>):Point {
		// QUESTION: does this apply to spherical surface? if not, need an impl in LatLngTools
		var x = 0.;
		var y = 0.;
		var sum = 0.;

		for (point in points) {
			x += point.coordinates.x * point.weight;
			y += point.coordinates.y * point.weight;
			sum += point.weight;
		}
		return xy(x / sum, y / sum);
	}

	public static function average(points:Array<Point>):Point {
		var x = 0.;
		var y = 0.;
		var len = points.length;

		for (point in points) {
			x += point.x;
			y += point.y;
		}

		return xy(x / len, y / len);
	}

	@:op(A + B)
	public inline function add(that:Point)
		return xy(x + that.x, y + that.y);

	@:op(A - B)
	public inline function subtract(that:Point)
		return xy(x - that.x, y - that.y);

	#if geojson
	@:to
	public inline function toGeoJsonCoordinates():geojson.util.Coordinates
		return cast this;

	@:to
	public inline function toGeoJson():geojson.Point
		return toGeoJsonCoordinates();

	@:from
	public static inline function fromGeoJsonCoordinates(v:geojson.util.Coordinates)
		return latLng(v.latitude, v.longitude);

	@:from
	public static inline function fromGeoJson(v:geojson.Point)
		return latLng(v.latitude, v.longitude);
	#end

	#if tink_json
	@:to
	public inline function toRepresentation():tink.json.Representation<Array<Float>>
		return new tink.json.Representation(this);

	@:from
	public static inline function fromRepresentation(rep:tink.json.Representation<Array<Float>>):Point
		return cast rep.get();
	#end
}
