package mmBoard
{
	public class MMVo
	{
		public function MMVo()
		{
		}
		private var _name:String;

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		private var _xp:int;

		public function get xp():int
		{
			return _xp;
		}

		public function set xp(value:int):void
		{
			_xp = value;
		}

		private var _yp:int;

		public function get yp():int
		{
			return _yp;
		}

		public function set yp(value:int):void
		{
			_yp = value;
		}

		private var _w:int;

		public function get w():int
		{
			return _w;
		}

		public function set w(value:int):void
		{
			_w = value;
		}

		private var _h:int;

		public function get h():int
		{
			return _h;
		}

		public function set h(value:int):void
		{
			_h = value;
		}

	}
}