package;

import tink.s2d.*;

@:asserts
class S2dTest {
	public function new() {}

	public function point() {
		var p1 = Point.xy(1.2, 2.3);
		var p2 = Point.latLng(2.3, 1.2);

		asserts.assert(p1.x == p1.longitude);
		asserts.assert(p1.y == p1.latitude);
		asserts.assert(p1.x == p2.x);
		asserts.assert(p1.y == p2.y);

		return asserts.done();
	}
}
