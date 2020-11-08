package tink.s2d;

@:jsonStringify(line -> (cast line : Array<tink.s2d.Polygon>))
@:jsonParse(array -> (cast array : MultiPolygon))
@:observable
@:access(tink.s2d)
@:forward(copy, filter, indexOf, iterator, join, lastIndexOf, map, slice, toString)
abstract MultiPolygon(Array<Polygon>) {
	public var length(get, never):Int;

	inline function get_length()
		return this.length;

	public inline function new(v)
		this = v;

	@:op([])
	public inline function get(i:Int):Polygon
		return this[i];

	public function containsPoint(point:Point) {
		for (polygon in this)
			if (polygon.containsPoint(point))
				return true;
		return false;
	}

	public function center():Point {
		return Point.average([for (polygon in this) polygon.center()]);
	}

	public function mapPoints(f:Point->Point):MultiPolygon
		return new MultiPolygon(this.map(polygon -> polygon.mapPoints(f)));

	public inline function concat(v:ConcatTarget):MultiPolygon {
		return new MultiPolygon(this.concat(v));
	}

	public function toWkt():String
		return length == 0 ? 'MULTIPOLYGON EMPTY' : 'MULTIPOLYGON(${toWktParams()})';

	inline function toWktParams():String
		return this.map(polygon -> '(${polygon.toWktParams()})').join(',');

	#if geojson
	@:from
	public static inline function fromGeoJson(v:geojson.MultiPolygon)
		return new MultiPolygon(cast v.polygons);

	@:to
	public inline function toGeoJson():geojson.MultiPolygon
		return new geojson.MultiPolygon(cast this);
	#end
}

private abstract ConcatTarget(Array<Polygon>) from Array<Polygon> to Array<Polygon> {
	#if geojson
	@:from public static inline function fromLiness(v:geojson.util.Liness):ConcatTarget
		return cast v;
	#end
}
