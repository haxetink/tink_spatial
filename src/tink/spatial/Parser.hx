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
					D2(Point(point2d()));
				case 2:
					D2(LineString(new tink.s2d.LineString([for (_ in 0...buffer.readInt32()) point2d()])));
				case 3:
					D2(Polygon(new tink.s2d.Polygon([
						for (_ in 0...buffer.readInt32())
							new tink.s2d.LineString([for (_ in 0...buffer.readInt32()) point2d()])
					])));
				case 4:
					D2(MultiPoint(new tink.s2d.MultiPoint([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case D2(Point(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiPoint(2D)';
							}
					])));
				case 5:
					D2(MultiLineString(new tink.s2d.MultiLineString([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case D2(LineString(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiLineString(2D)';
							}
					])));
				case 6:
					D2(MultiPolygon(new tink.s2d.MultiPolygon([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case D2(Polygon(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiPolygon(2D)';
							}
					])));
				case 7:
					D2(GeometryCollection(new tink.s2d.GeometryCollection([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case D2(v):
									v;
								case v:
									throw 'Unexpected ${v} inside GeometryCollection(2D)';
							}
					])));
				// 3D
				case 1001:
					D3(Point(point3d()));
				case 1002:
					D3(LineString(new tink.s3d.LineString([for (_ in 0...buffer.readInt32()) point3d()])));
				case 1003:
					D3(Polygon(new tink.s3d.Polygon([
						for (_ in 0...buffer.readInt32())
							new tink.s3d.LineString([for (_ in 0...buffer.readInt32()) point3d()])
					])));
				case 1004:
					D3(MultiPoint(new tink.s3d.MultiPoint([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case D3(Point(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiPoint(2D)';
							}
					])));
				case 1005:
					D3(MultiLineString(new tink.s3d.MultiLineString([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case D3(LineString(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiLineString(2D)';
							}
					])));
				case 1006:
					D3(MultiPolygon(new tink.s3d.MultiPolygon([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case D3(Polygon(v)):
									v;
								case v:
									throw 'Unexpected ${v} inside MultiPolygon(2D)';
							}
					])));
				case 1007:
					D3(GeometryCollection(new tink.s3d.GeometryCollection([
						for (_ in 0...buffer.readInt32())
							switch _parse() {
								case D3(v):
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
