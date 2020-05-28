package;

import tink.s3d.*;

@:asserts
class S3dTest {
	public function new() {}

	public function point() {
		var p1 = Point.xyz(1.2, 2.3, 3.4);
		var p2 = Point.latLngAlt(2.3, 1.2, 3.4);

		asserts.assert(p1.x == p1.longitude);
		asserts.assert(p1.y == p1.latitude);
		asserts.assert(p1.z == p1.altitude);
		asserts.assert(p1.x == p2.x);
		asserts.assert(p1.y == p2.y);
		asserts.assert(p1.z == p2.z);

		return asserts.done();
	}
}
