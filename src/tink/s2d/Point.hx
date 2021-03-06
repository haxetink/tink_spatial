package tink.s2d;

import tink.spatial.Util.format;

@:jsonStringify(point -> (cast point : Array<Float>))
@:jsonParse((array:Array<Float>) -> (cast array : tink.s2d.Point))
@:tink.encode(point -> (cast point : Array<Float>))
@:tink.decode((array:Array<Float>) -> (cast array : tink.s2d.Point))
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

	public inline function iterator()
		return new tink.spatial.Util.TupleIterator(this, 2);

	public static inline function xy(x, y)
		return new Point(x, y);

	public static inline function latLng(lat, lng)
		return new Point(lng, lat);

	public inline function translateXY(dx, dy)
		return xy(x + dx, y + dy);

	public inline function translateLatLng(lat, lng)
		return latLng(latitude + lat, longitude + lng);

	public function isEmpty()
		return this.length == 0 || (Math.isNaN(x) && Math.isNaN(y));

	public inline function to3D(z:Float)
		return tink.s3d.Point.xyz(x, y, z);

	public function toArray():Array<Float>
		return this.slice(0, 2);

	public function toString(dp = 2):String
		return '[${format(x, dp)}, ${format(y, dp)}]';
	
	public function toEwkt(srid:Int):String
		return 'SRID=$srid;' + toWkt();

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

	// @:op(A == B)
	public inline function eq(that:Point)
		return x == that.x && y == that.y;

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
}
