package tink.s2d;

@:using(tink.s2d.Geometry.GeometryTools)
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
