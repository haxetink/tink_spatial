package tink.s3d;

@:observable
@:access(tink.s3d)
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
	
	public function toEwkt(srid:Int):String
		return 'SRID=$srid;' + toWkt();

	public function toWkt():String {
		return length == 0 ? 'POLYGON Z EMPTY' : 'POLYGON Z (${toWktParams()})';
	}

	inline function toWktParams():String
		return this.map(line -> '(${line.toWktParams()})').join(',');
}
