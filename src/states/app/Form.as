package states.app
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import core.App;
	import interfaces.IFormState;
	import interfaces.IState;
	import states.form.Intro;
	import states.form.Company;
	import states.form.Messages;
	import states.form.Backgrounds;
	import states.form.Sign;
	
	public class Form extends Sprite implements IState
	{
		public static const INTRO_STATE:uint = 0;
		public static const COMPANY_STATE:uint = 1;
		public static const MESSAGE_STATE:uint = 2;
		public static const BACKGROUND_STATE:uint = 3;
		public static const SIGN_STATE:uint = 4;
		
		private var current_state:IFormState
		private var app:App;
		private var xmlData:XML;
		
		public function Form(app:App)
		{
			trace("form initialized");
			this.app = app;
			this.xmlData = app.assets_xml.xmlData;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//initialize any settings here
			
			changeState(INTRO_STATE);
		}
		
		public function changeState(state:uint):void
		{
			if(current_state != null){
				current_state.destroy();
				current_state = null;
			}
			
			switch(state){
				case INTRO_STATE:
					current_state = new Intro(this, xmlData);
					break;
				case COMPANY_STATE:
					current_state = new Company(this, xmlData);
					break;
				case MESSAGE_STATE:
					current_state = new Messages(this, xmlData);
					break;
				case BACKGROUND_STATE:
					current_state = new Backgrounds(this, xmlData);
					break;
				case SIGN_STATE:
					current_state = new Sign(this, xmlData);
					break;
				default:
					trace("unknown form state value: " + state);
					break;
			}
			
			this.addChild(Sprite(current_state));
		}
		
		public function finished():void
		{
			app.changeState(App.THANK_YOU_STATE);
		}
		
		public function destroy():void
		{
			xmlData = null;
			this.parent.removeChild(this);
		}
	}//class
}//package