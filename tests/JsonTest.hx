package;

import tink.s2d.*;

using JsonTest;

@:asserts
class JsonTest {
	public function new() {}

	public function nullable() {
		final o:{v:Null<Point>} = {v: null};
		asserts.assert(tink.Json.stringify(o) == '{"v":null}');
		asserts.assert((tink.Json.parse('{"v":null}') : {v: Null<Point>}).v.isNull());
		final o:{v:Null<LineString>} = {v: null};
		asserts.assert(tink.Json.stringify(o) == '{"v":null}');
		asserts.assert((tink.Json.parse('{"v":null}') : {v: Null<LineString>}).v.isNull());
		final o:{v:Null<Polygon>} = {v: null};
		asserts.assert(tink.Json.stringify(o) == '{"v":null}');
		asserts.assert((tink.Json.parse('{"v":null}') : {v: Null<Polygon>}).v.isNull());
		final o:{v:Null<MultiPolygon>} = {v: null};
		asserts.assert(tink.Json.stringify(o) == '{"v":null}');
		asserts.assert((tink.Json.parse('{"v":null}') : {v: Null<MultiPolygon>}).v.isNull());

		return asserts.done();
	}

	// TODO: tink_unit needs to fix abstract toString in binop breakdown for nullables
	static function isNull<T>(v:Null<T>)
		return v == null;
}
