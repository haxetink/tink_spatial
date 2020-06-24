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

	public function mapPoints(f:Point->Point):Polygon
		return new Polygon(this.map(line -> line.mapPoints(f)));

	public inline function center():Point {
		var points = this[0].slice(0, -1);
		return Point.average(cast points);
	}

	/**
		Construct a regular polygon
		@param sides number of sides of the polygon
		@param radius radius of the polygon
		@param bearing the starting bearing in degrees, default 0
	**/
	public static function regular(sides:Int, radius:Float, bearing:Float = 0, ?center:Point) {
		var cx = center == null ? 0 : center.x;
		var cy = center == null ? 0 : center.y;
		var radian = bearing;
		var increment = Math.PI * 2 / sides;

		var points = [
			for (n in 0...sides) {
				var current = radian + n * increment;
				new Point(cx + Math.sin(current) * radius, cy + Math.cos(current) * radius);
			}
		];
		points.push(points[0]); // back to origin
		return new Polygon([new LineString(points)]);
	}

	/**
		Determines if a point is contained in this polygon.
		Reference: http://geospatialpython.com/2011/01/point-in-polygon.html
		TODO: does this work if the polygon spans across the +/- boundary (e.g. the north/south poles or equator)?

		@param point the point to check
		@return true if this polygon contains the given point
	**/
	public function containsPoint(point:Point) {
		function _contains(point:Point, line:LineString) {
			var n = line.length - 1;
			var result = false;
			var lat1 = line[0].latitude;
			var long1 = line[0].longitude;
			var longints = Math.NEGATIVE_INFINITY;
			for (i in 0...n + 1) {
				var current = line[i % n];
				var lat2 = current.latitude;
				var long2 = current.longitude;
				if (point.latitude > Math.min(lat1, lat2)) {
					if (point.latitude <= Math.max(lat1, lat2)) {
						if (point.longitude <= Math.max(long1, long2)) {
							if (lat1 != lat2)
								longints = (point.latitude - lat1) * (long2 - long1) / (lat2 - lat1) + long1;
							if (long1 == long2 || point.longitude <= longints)
								result = !result;
						}
					}
				}
				lat1 = lat2;
				long1 = long2;
			}
			return result;
		}

		// check outer boundary
		if (!_contains(point, this[0]))
			return false;
		// check the "holes"
		for (i in 1...this.length)
			if (_contains(point, this[i]))
				return false;
		return true;
	}

	public function toWkt():String {
		return length == 0 ? 'POLYGON EMPTY' : 'POLYGON(${toWktParams()})';
	}

	inline function toWktParams():String
		return this.map(line -> '(${line.toWktParams()})').join(',');

	#if geojson
	@:to
	public inline function toGeoJsonLines():geojson.util.Lines
		return cast this;

	@:to
	public inline function toGeoJson():geojson.Polygon
		return new geojson.Polygon(toGeoJsonLines());

	@:from
	public static inline function fromGeoJsonLines(v:geojson.util.Lines)
		return new Polygon(cast v);

	@:from
	public static inline function fromGeoJson(v:geojson.Polygon)
		return new Polygon(cast v.lines);
	#end

	#if tink_json
	@:to
	public inline function toRepresentation():tink.json.Representation<Array<LineString>>
		return new tink.json.Representation(this);

	@:from
	public static inline function fromRepresentation(rep:tink.json.Representation<Array<LineString>>):Polygon
		return cast rep.get();
	#end
}
