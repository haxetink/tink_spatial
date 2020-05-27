package tink.s2d;

@:observable
@:access(tink.s2d)
@:forward(concat, copy, filter, indexOf, iterator, join, lastIndexOf, map, slice, toString)
abstract Polygon(Array<LineString>) {
	public var length(get, never):Int;

	inline function get_length()
		return this.length;

	public inline function new(v)
		this = v;

	@:op([])
	public inline function get(i:Int):LineString
		return this[i];

	public function toWkt():String {
		return length == 0 ? 'POLYGON EMPTY' : 'POLYGON(${toWktParams()})';
	}

	inline function toWktParams():String
		return this.map(line -> '(${line.toWktParams()})').join(',');
}
