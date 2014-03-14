package user
{
	public class UserData extends Object
	{
		private static var _company:uint;
		private static var _message:uint;
		private static var _background:uint;
		private static var _firstName:String;
		private static var _lastName:String;
		private static var _email:String;
		
		public static function clearData():void
		{
			_company = 0;
			_message = 0;
			_background = 0;
			_firstName = null;
			_lastName = null;
			_email = null;
		}
		public static function get company():uint{ return _company; }
		public static function set company(id:uint):void{_company = id; }
		
		public static function get message():uint{ return _message; }
		public static function set message(id:uint):void{ _message = id; }
		
		public static function get background():uint{ return _background; }
		public static function set background(id:uint):void{ _background = id; }
		
		public static function get firstName():String{ return _firstName; }
		public static function set firstName(first:String):void{ _firstName = first; }
		
		public static function get lastName():String{ return _lastName; }
		public static function set lastName(last:String):void{ _lastName = last; }
		
		public static function get email():String{ return _email; }
		public static function set email(email:String):void{ _email = email; }

	}//class
}//package