package tink.s3d;

import tink.spatial.Util.format;

@:jsonStringify(point -> (cast point : Array<Float>))
@:jsonParse((array:Array<Float>) -> (cast array : tink.s3d.Point))
@:tink.encode(point -> (cast point : Array<Float>))
@:tink.decode((array:Array<Float>) -> (cast array : tink.s3d.Point))
@:observable
abstract Point(Array<Float>) {
	public var x(get, never):Float;
	public var y(get, never):Float;
	public var z(get, never):Float;
	public var latitude(get, never):Float;
	public var longitude(get, never):Float;
	public var altitude(get, never):Float;

	inline function get_x()
		return this[0];

	inline function get_y()
		return this[1];

	inline function get_z()
		return this[2];

	inline function get_latitude()
		return y;

	inline function get_longitude()
		return x;

	inline function get_altitude()
		return z;

	inline function new(x, y, z)
		this = [x, y, z];

	public inline function iterator()
		return new tink.spatial.Util.TupleIterator(this, 3);

	public inline function to2D():tink.s2d.Point
		return cast this.slice(0, 2);

	public function toArray():Array<Float>
		return this.slice(0, 3);

	public function toString(dp = 2):String
		return '[${format(x, dp)}, ${format(y, dp)}, ${format(z, dp)}]';

	public static inline function xyz(x, y, z)
		return new Point(x, y, z);

	public static inline function latLngAlt(lat, lng, alt)
		return new Point(lng, lat, alt);

	public inline function translateXYZ(dx, dy, dz)
		return xyz(x + dx, y + dy, z + dz);

	public inline function translateLatLngAlt(lat, lng, alt)
		return latLngAlt(latitude + lat, longitude + lng, altitude + alt);

	public inline function withoutZ()
		return tink.s2d.Point.xy(x, y);

	public function isEmpty()
		return this.length == 0 || (Math.isNaN(x) && Math.isNaN(y) && Math.isNaN(y));
	
	public function toEwkt(srid:Int):String
		return 'SRID=$srid;' + toWkt();

	public function toWkt():String
		return isEmpty() ? 'POINT Z EMPTY' : 'POINT Z (${toWktParams()})';

	inline function toWktParams():String
		return '$x $y $z';

	public static function interpolate(points:Array<{coordinates:Point, weight:Float}>):Point {
		// QUESTION: does this apply to spherical surface? if not, need an impl in LatLngTools
		var x = 0.;
		var y = 0.;
		var z = 0.;
		var sum = 0.;

		for (point in points) {
			x += point.coordinates.x * point.weight;
			y += point.coordinates.y * point.weight;
			z += point.coordinates.z * point.weight;
			sum += point.weight;
		}
		return xyz(x / sum, y / sum, z / sum);
	}

	@:op(A + B)
	public inline function add(that:Point)
		return xyz(x + that.x, y + that.y, z + that.z);

	@:op(A - B)
	public inline function subtract(that:Point)
		return xyz(x - that.x, y - that.y, z - that.z);

	// @:op(A == B)
	public inline function eq(that:Point)
		return x == that.x && y == that.y && z == that.z;
}
