package tink.s3d;

@:using(tink.s3d.Geometry.GeometryTools)
enum Geometry {
	Point(v:Point);
	LineString(v:LineString);
	Polygon(v:Polygon);
	MultiPoint(v:MultiPoint);
	MultiLineString(v:MultiLineString);
	MultiPolygon(v:MultiPolygon);
	GeometryCollection(v:GeometryCollection);
}

class GeometryTools {
	public static function toEwkt(g:Geometry, srid:Int):String {
		return switch g {
			case Point(v): v.toEwkt(srid);
			case LineString(v): v.toEwkt(srid);
			case Polygon(v): v.toEwkt(srid);
			case MultiPoint(v): v.toEwkt(srid);
			case MultiLineString(v): v.toEwkt(srid);
			case MultiPolygon(v): v.toEwkt(srid);
			case GeometryCollection(v): v.toEwkt(srid);
		}
	}
	
	public static function toWkt(g:Geometry):String {
		return switch g {
			case Point(v): v.toWkt();
			case LineString(v): v.toWkt();
			case Polygon(v): v.toWkt();
			case MultiPoint(v): v.toWkt();
			case MultiLineString(v): v.toWkt();
			case MultiPolygon(v): v.toWkt();
			case GeometryCollection(v): v.toWkt();
		}
	}

	public static function toGeoJson(g:Geometry):Dynamic {
		return switch g {
			case Point(v):
				{type: 'Point', coordinates: v}
			case LineString(v):
				{type: 'LineString', coordinates: v}
			case Polygon(v):
				{type: 'Polygon', coordinates: v}
			case MultiPoint(v):
				{type: 'MultiPoint', coordinates: v}
			case MultiLineString(v):
				{type: 'MultiLineString', coordinates: v}
			case MultiPolygon(v):
				{type: 'MultiPolygon', coordinates: v}
			case GeometryCollection(v):
				{type: 'GeometryCollection', geometries: v.map(toGeoJson)}
		}
	}
}
