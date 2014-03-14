package core
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import events.CustomEvent;
	import interfaces.IState;
	import states.app.Thanks;
	import states.app.Form;
	import states.app.Standby;
	import states.app.Setup;
	
	public class App extends Sprite
	{
		public static const SETUP_STATE:int = 0;
		public static const STANDBY_STATE:int = 1;
		public static const FORM_STATE:int = 2;
		public static const THANK_YOU_STATE:int = 3;
		private var current_state:IState;

		private var _assets_xml:AssetsXML;

		public function App():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			_assets_xml = new AssetsXML;
			_assets_xml.addEventListener(CustomEvent.XML_LOADED, xmlLoaded);
		}

		private function xmlLoaded(evt:Event):void
		{
			_assets_xml.removeEventListener(CustomEvent.XML_LOADED, xmlLoaded);
			changeState(SETUP_STATE);
		}

		public function changeState(state:int):void
		{
			if(current_state != null){
				current_state.destroy();
				current_state = null;
			}
			switch(state){
				case SETUP_STATE:
					current_state = new Setup(this);
					break;
				case STANDBY_STATE:
					current_state = new Standby(this);
					break;
				case FORM_STATE:
					current_state = new Form(this);
					break;
				case THANK_YOU_STATE:
					current_state = new Thanks(this);
					break;
				default:
					trace("unknown app state: " + state);
			}
			this.addChild(Sprite(current_state));
		}
		public function get assets_xml():AssetsXML
		{
			return _assets_xml;
		}
	}//class
}//package