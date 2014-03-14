package states.app
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	import core.App;
	import interfaces.IState;
	
	public class Thanks extends Sprite implements IState
	{
		private var app:App;
		private var txt_copy:TextField;
		private var delay:Number;
		private var wait_timeout:uint;
		
		public function Thanks(app:App)
		{
			this.app = app;
			loadCopy();
			initTimeout();
		}
		private function loadCopy():void
		{	
			var txt_format:TextFormat = new TextFormat();
			txt_format.size = 12;
			txt_format.align = TextFormatAlign.LEFT;
			txt_format.color = 0xaaaaaa;
			txt_format.bold = false;
			txt_format.font = "Verdana";
			
			txt_copy = new TextField();
			txt_copy.defaultTextFormat = txt_format;
			txt_copy.text = "Thank you for supporting Big Cats and deforestation-free palm oil.";
			txt_copy.border = true;
			txt_copy.wordWrap = true;
			txt_copy.width = 200;
			txt_copy.height = 200;
			txt_copy.x = 20;
			txt_copy.y = 20;
			this.addChild(txt_copy);
			
			txt_format = null;
		}
		
		private function initTimeout():void
		{
			delay = 4000;
			wait_timeout = setTimeout(function():void{app.changeState(App.STANDBY_STATE)}, delay);
		}

		public function destroy():void
		{
			this.removeChild(txt_copy);
			clearTimeout(wait_timeout);
			
			this.parent.removeChild(this);
		}
	}//class
}//package