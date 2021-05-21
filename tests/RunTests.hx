package;

import tink.unit.*;
import tink.testrunner.*;

class RunTests {
	static function main() {
		tink.spatial.LatLngTools;
		Runner.run(TestBatch.make([
			// @formatter:off
			new WkbTest(),
			new EwkbTest(),
			new S2dTest(),
			new S3dTest(),
			new JsonTest(),
			// @formatter:on
		])).handle(Runner.exit);
	}
}
