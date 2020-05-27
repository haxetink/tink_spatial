package tink.s2d;

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
		return x;

	inline function get_longitude()
		return y;

	inline function new(x, y)
		this = [x, y];

	public static inline function xy(x, y)
		return new Point(x, y);

	public static inline function latLng(lat, lng)
		return new Point(lng, lat);

	public function isEmpty()
		return this.length == 0 || (Math.isNaN(x) && Math.isNaN(y));

	public function toWkt():String
		return isEmpty() ? 'POINT EMPTY' : 'POINT(${toWktParams()})';

	inline function toWktParams():String
		return '$x $y';

	#if geojson
	@:to
	inline function toGeoJsonCoordinates():geojson.util.Coordinates
		return cast this;

	@:to
	inline function toGeoJson():geojson.Point
		return toGeoJsonCoordinates();

	@:from
	static inline function fromGeoJson(v:geojson.Point)
		return latLng(v.latitude, v.longitude);
	#end

	#if tink_json
	@:to
	public function toRepresentation():tink.json.Representation<Array<Float>>
		return new tink.json.Representation(this);

	@:from
	public static function fromRepresentation(rep:tink.json.Representation<Array<Float>>):Point
		return cast rep.get();
	#end
}
