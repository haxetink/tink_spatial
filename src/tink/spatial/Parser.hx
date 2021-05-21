package tink.spatial;

import haxe.io.*;

using tink.CoreApi;

// https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry


class Parser {
	public static function ewkb(bytes:Bytes):tink.spatial.ExtendedGeometry {
		return new ExtendedGeometry(
			new Buffer(bytes, 0).parseSrid(),
			new Buffer(bytes, 0).parseGeometry(true)
		);
	}
	
	public static function wkb(bytes:Bytes):tink.spatial.Geometry {
		return new Buffer(bytes, 0).parseGeometry(false);
	}
}

@:access(tink.s2d)
@:access(tink.s3d)
abstract Buffer(BytesInput) from BytesInput to BytesInput {
	static inline final SRID_MASK = 0x20000000;
	
	public inline function new(bytes, offset)
		this = new BytesInput(bytes, offset);
	
	inline function point2d()
		return new tink.s2d.Point(this.readDouble(), this.readDouble());

	inline function point3d()
		return new tink.s3d.Point(this.readDouble(), this.readDouble(), this.readDouble());

	public function parseSrid():Null<Int> {
		this.bigEndian = this.readByte() == 0;
		return this.readInt32() & SRID_MASK != 0 ? this.readInt32() : null;
	}
	
	public function parseGeometry(extended = false):tink.spatial.Geometry {
		this.bigEndian = this.readByte() == 0;

		var type = this.readInt32();
		if(extended && type & SRID_MASK != 0) {
			type &= ~SRID_MASK;
			this.readInt32(); // SRID
		}
		
		return switch type {
			// 2D
			case 1:
				S2D(Point(point2d()));
			case 2:
				S2D(LineString(new tink.s2d.LineString([for (_ in 0...this.readInt32()) point2d()])));
			case 3:
				S2D(Polygon(new tink.s2d.Polygon([
					for (_ in 0...this.readInt32())
						new tink.s2d.LineString([for (_ in 0...this.readInt32()) point2d()])
				])));
			case 4:
				S2D(MultiPoint(new tink.s2d.MultiPoint([
					for (_ in 0...this.readInt32())
						switch parseGeometry() {
							case S2D(Point(v)):
								v;
							case v:
								throw 'Unexpected ${v} inside MultiPoint(2D)';
						}
				])));
			case 5:
				S2D(MultiLineString(new tink.s2d.MultiLineString([
					for (_ in 0...this.readInt32())
						switch parseGeometry() {
							case S2D(LineString(v)):
								v;
							case v:
								throw 'Unexpected ${v} inside MultiLineString(2D)';
						}
				])));
			case 6:
				S2D(MultiPolygon(new tink.s2d.MultiPolygon([
					for (_ in 0...this.readInt32())
						switch parseGeometry() {
							case S2D(Polygon(v)):
								v;
							case v:
								throw 'Unexpected ${v} inside MultiPolygon(2D)';
						}
				])));
			case 7:
				S2D(GeometryCollection(new tink.s2d.GeometryCollection([
					for (_ in 0...this.readInt32())
						switch parseGeometry() {
							case S2D(v):
								v;
							case v:
								throw 'Unexpected ${v} inside GeometryCollection(2D)';
						}
				])));
			// 3D
			case 1001:
				S3D(Point(point3d()));
			case 1002:
				S3D(LineString(new tink.s3d.LineString([for (_ in 0...this.readInt32()) point3d()])));
			case 1003:
				S3D(Polygon(new tink.s3d.Polygon([
					for (_ in 0...this.readInt32())
						new tink.s3d.LineString([for (_ in 0...this.readInt32()) point3d()])
				])));
			case 1004:
				S3D(MultiPoint(new tink.s3d.MultiPoint([
					for (_ in 0...this.readInt32())
						switch parseGeometry() {
							case S3D(Point(v)):
								v;
							case v:
								throw 'Unexpected ${v} inside MultiPoint(3D)';
						}
				])));
			case 1005:
				S3D(MultiLineString(new tink.s3d.MultiLineString([
					for (_ in 0...this.readInt32())
						switch parseGeometry() {
							case S3D(LineString(v)):
								v;
							case v:
								throw 'Unexpected ${v} inside MultiLineString(3D)';
						}
				])));
			case 1006:
				S3D(MultiPolygon(new tink.s3d.MultiPolygon([
					for (_ in 0...this.readInt32())
						switch parseGeometry() {
							case S3D(Polygon(v)):
								v;
							case v:
								throw 'Unexpected ${v} inside MultiPolygon(3D)';
						}
				])));
			case 1007:
				S3D(GeometryCollection(new tink.s3d.GeometryCollection([
					for (_ in 0...this.readInt32())
						switch parseGeometry() {
							case S3D(v):
								v;
							case v:
								throw 'Unexpected ${v} inside GeometryCollection(3D)';
						}
				])));
			case v:
				throw 'WKB type "$v" not supported';
		}
	}
}