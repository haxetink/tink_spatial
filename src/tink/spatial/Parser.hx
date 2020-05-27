package tink.spatial;

import haxe.io.*;

// https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry
@:access(tink.s2d)
@:access(tink.s3d)
class Parser {
	public static function wkb(bytes:Bytes):tink.spatial.Geometry {
		var buffer = new BytesInput(bytes, 0);

		inline function point2d()
			return new tink.s2d.Point(buffer.readDouble(), buffer.readDouble());

		inline function point3d()
			return new tink.s3d.Point(buffer.readDouble(), buffer.readDouble(), buffer.readDouble());

		function _parse():tink.spatial.Geometry {
			buffer.bigEndian = buffer.readByte() == 0;

			return switch buffer.readInt32() {
				// 2D
				case 1:
					S2D(Point(point2d()));
				case 2:
					S2D(LineString(new tink.s2d.LineString([for (_ in 0...buffer.readInt32()) point2d()])));
				case 3:
					S2D(Polygon(new tink.s2d.Polygon([
						for (_ in 0...buffer.readInt32())
							new tink.s2d.LineString([for (_ in 0...buffer.readInt32()) point2d()])
					])));
				case 4:
					S2D(MultiPoint(new tink.s2d.MultiPoint([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case S2D(Point(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiPoint(2D)';
							}
					])));
				case 5:
					S2D(MultiLineString(new tink.s2d.MultiLineString([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case S2D(LineString(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiLineString(2D)';
							}
					])));
				case 6:
					S2D(MultiPolygon(new tink.s2d.MultiPolygon([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case S2D(Polygon(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiPolygon(2D)';
							}
					])));
				case 7:
					S2D(GeometryCollection(new tink.s2d.GeometryCollection([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
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
					S3D(LineString(new tink.s3d.LineString([for (_ in 0...buffer.readInt32()) point3d()])));
				case 1003:
					S3D(Polygon(new tink.s3d.Polygon([
						for (_ in 0...buffer.readInt32())
							new tink.s3d.LineString([for (_ in 0...buffer.readInt32()) point3d()])
					])));
				case 1004:
					S3D(MultiPoint(new tink.s3d.MultiPoint([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case S3D(Point(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiPoint(2D)';
							}
					])));
				case 1005:
					S3D(MultiLineString(new tink.s3d.MultiLineString([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case S3D(LineString(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiLineString(2D)';
							}
					])));
				case 1006:
					S3D(MultiPolygon(new tink.s3d.MultiPolygon([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case S3D(Polygon(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiPolygon(2D)';
							}
					])));
				case 1007:
					S3D(GeometryCollection(new tink.s3d.GeometryCollection([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case S3D(v):
									v;
								case v:
									throw 'Unexpected ${v} inside GeometryCollection(2D)';
							}
					])));
				case v:
					throw 'WKB type "$v" not supported';
			}
		}

		return _parse();
	}
}
