package states.app
{
	import core.App;
	import core.AssetsXML;
	import interfaces.IState;

	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Setup extends Sprite implements IState
	{
		private var app:App;
		private var assets_xml:AssetsXML;

		public function Setup(app:App):void
		{
			trace("setup initialized");
			this.app = app;
			this.assets_xml = AssetsXML.instance;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			app.changeState(App.STANDBY_STATE);
		}

		public function destroy():void
		{
			this.parent.removeChild(this);
		}
	}//class
}//package