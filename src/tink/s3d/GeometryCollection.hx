package tink.s3d;

@:observable
@:access(tink.s3d)
@:forward(concat, copy, filter, indexOf, iterator, join, lastIndexOf, map, slice, toString)
abstract GeometryCollection(Array<Geometry>) {
	public var length(get, never):Int;

	inline function get_length()
		return this.length;

	public inline function new(v)
		this = v;

	public function toWkt():String
		return length == 0 ? 'GEOMETRYCOLLECTION Z EMPTY' : 'GEOMETRYCOLLECTION Z (${toWktParams()})';

	inline function toWktParams():String
		return this.map(g -> g.toWkt()).join(',');
}
