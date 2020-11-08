package;

import tink.s2d.*;

@:asserts
class JsonTest {
	public function new() {}

	public function nullable() {
		final o:{v:Null<Point>} = {v: null};
		asserts.assert(tink.Json.stringify(o) == '{"v":null}');
		final o:{v:Null<LineString>} = {v: null};
		asserts.assert(tink.Json.stringify(o) == '{"v":null}');
		final o:{v:Null<Polygon>} = {v: null};
		asserts.assert(tink.Json.stringify(o) == '{"v":null}');
		final o:{v:Null<MultiPolygon>} = {v: null};
		asserts.assert(tink.Json.stringify(o) == '{"v":null}');

		return asserts.done();
	}
}
