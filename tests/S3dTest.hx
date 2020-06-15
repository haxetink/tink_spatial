package;

import tink.s3d.*;

@:asserts
class S3dTest {
	public function new() {}

	public function point() {
		var p1 = Point.xyz(1.2, 2.3, 3.4);
		var p2 = Point.latLngAlt(2.3, 1.2, 3.4);
		var t1 = p1.translateXYZ(0.2, 0.3, 0.4);
		var t2 = p2.translateLatLngAlt(0.3, 0.2, 0.4);

		asserts.assert(p1.x == p1.longitude);
		asserts.assert(p1.y == p1.latitude);
		asserts.assert(p1.z == p1.altitude);
		asserts.assert(p1.x == p2.x);
		asserts.assert(p1.y == p2.y);
		asserts.assert(p1.z == p2.z);

		asserts.assert(t1.x == 1.2 + 0.2);
		asserts.assert(t1.y == 2.3 + 0.3);
		asserts.assert(t1.z == 3.4 + 0.4);
		asserts.assert(t1.x == t1.longitude);
		asserts.assert(t1.y == t1.latitude);
		asserts.assert(t1.z == t1.altitude);
		asserts.assert(t1.x == t2.x);
		asserts.assert(t1.y == t2.y);
		asserts.assert(t1.z == t2.z);

		return asserts.done();
	}
}
