package tink.s2d;

@:observable
@:forward(concat, copy, filter, indexOf, iterator, join, lastIndexOf, map, slice, toString)
abstract GeometryCollection(Array<Geometry>) {
	public var length(get, never):Int;

	inline function get_length()
		return this.length;

	public inline function new(v)
		this = v;

	public function toWkt():String
		return length == 0 ? 'GEOMETRYCOLLECTION EMPTY' : 'GEOMETRYCOLLECTION(${toWktParams()})';

	inline function toWktParams():String
		return this.map(g -> g.toWkt()).join(',');
}
