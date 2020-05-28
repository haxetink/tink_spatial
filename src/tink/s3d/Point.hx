package tink.s3d;

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

	public static inline function xyz(x, y, z)
		return new Point(x, y, z);

	public static inline function latLngAlt(lat, lng, alt)
		return new Point(lat, lng, alt);

	public function isEmpty()
		return this.length == 0 || (Math.isNaN(x) && Math.isNaN(y) && Math.isNaN(y));

	public function toWkt():String
		return isEmpty() ? 'POINT Z EMPTY' : 'POINT Z (${toWktParams()})';

	inline function toWktParams():String
		return '$x $y $z';

	#if tink_json
	@:to
	public function toRepresentation():tink.json.Representation<Array<Float>>
		return new tink.json.Representation(this);

	@:from
	public static function fromRepresentation(rep:tink.json.Representation<Array<Float>>):Point
		return cast rep.get();
	#end
}
