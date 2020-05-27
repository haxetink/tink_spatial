package tink.s2d;

@:observable
@:access(tink.s2d)
@:forward(concat, copy, filter, indexOf, iterator, join, lastIndexOf, map, slice, toString)
abstract MultiPolygon(Array<Polygon>) {
	public var length(get, never):Int;

	inline function get_length()
		return this.length;

	public inline function new(v)
		this = v;

	@:op([])
	public inline function get(i:Int):Polygon
		return this[i];

	public function toWkt():String
		return length == 0 ? 'MULTIPOLYGON EMPTY' : 'MULTIPOLYGON(${toWktParams()})';

	inline function toWktParams():String
		return this.map(polygon -> '(${polygon.toWktParams()})').join(',');

	#if geojson
	@:from
	public static inline function fromGeoJson(v:geojson.MultiPolygon)
		return new MultiPolygon(cast v.polygons);
	#end
}
