package tink.s2d;

@:jsonStringify(line -> (cast line : Array<tink.s2d.Point>))
@:jsonParse((array:Array<tink.s2d.Point>) -> (cast array : tink.s2d.LineString))
@:tink.encode(line -> (cast line : Array<tink.s2d.Point>))
@:tink.decode((array:Array<tink.s2d.Point>) -> (cast array : tink.s2d.LineString))
@:observable
@:access(tink.s2d)
@:forward(concat, copy, filter, indexOf, iterator, join, lastIndexOf, map, slice, toString)
abstract LineString(Array<Point>) {
	public var length(get, never):Int;

	inline function get_length()
		return this.length;

	public inline function new(v)
		this = v;

	@:op([])
	public inline function get(i:Int):Point
		return this[i];

	public function mapPoints(f:Point->Point):LineString
		return new LineString(this.map(f));

	public function toWkt():String
		return length == 0 ? 'LINESTRING EMPTY' : 'LINESTRING(${toWktParams()})';

	inline function toWktParams():String
		return this.map(point -> point.toWktParams()).join(',');
}
