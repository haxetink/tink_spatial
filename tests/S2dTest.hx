package;

import tink.s2d.*;

@:asserts
class S2dTest {
	public function new() {}

	public function point() {
		var p1 = Point.xy(1.2, 2.3);
		var p2 = Point.latLng(2.3, 1.2);
		var t1 = p1.translateXY(0.2, 0.3);
		var t2 = p2.translateLatLng(0.3, 0.2);

		asserts.assert(p1.x == p1.longitude);
		asserts.assert(p1.y == p1.latitude);
		asserts.assert(p1.x == p2.x);
		asserts.assert(p1.y == p2.y);

		asserts.assert(t1.x == 1.2 + 0.2);
		asserts.assert(t1.y == 2.3 + 0.3);
		asserts.assert(t1.x == t1.longitude);
		asserts.assert(t1.y == t1.latitude);
		asserts.assert(t1.x == t2.x);
		asserts.assert(t1.y == t2.y);

		return asserts.done();
	}
}
