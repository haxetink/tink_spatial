package tink.spatial;

using StringTools;

class Util {
	public static function format(v:Float, dp:Int):String {
		if (v == 0)
			return '0.'.rpad('0', 2 + dp);
		var s = Math.round(v * Math.pow(10, dp)) + '';
		return s.substr(0, s.length - dp) + '.' + s.substr(s.length - dp);
	}
}

class TupleIterator<T> {
	var cur:Int;
	var max:Int;
	var array:Array<T>;

	public inline function new(value:Array<T>, size:Int) {
		cur = 0;
		max = size;
		array = value;
	}

	public inline function hasNext():Bool {
		return cur != max;
	}

	public inline function next():T {
		return array[cur++];
	}
}
