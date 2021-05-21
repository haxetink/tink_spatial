package tink.spatial;

using tink.CoreApi;

abstract ExtendedGeometry(Pair<Int, Geometry>) {
	public var srid(get, never):Int;
	public var geometry(get, never):Geometry;
	
	public inline function new(srid, geometry)
		this = new Pair(srid, geometry);
	
	inline function get_srid() return this.a;
	inline function get_geometry() return this.b;
}
