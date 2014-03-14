package objects.vk
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import objects.vk.Key;
	
	public class VirtualKeyboard extends Sprite
	{
		private var _targetField:TextField;
		private var txtDisplay:TextField;
		private var arr_keys:Array;
		
		public function VirtualKeyboard()
		{
			initBG();
			initDisplay();
			initKeys();
		}
		
		public function initBG():void
		{
			this.graphics.beginFill(0x000000, 0.80);
			this.graphics.drawRect(0, 0, 800, 600);
			this.graphics.endFill();
		}
		
		public function addToText(event:MouseEvent):void
		{
			txtDisplay.appendText(event.currentTarget.name);
		}
		
		private function onEnter(event:MouseEvent):void
		{
			_targetField.text = txtDisplay.text;
			txtDisplay.text = "";
			_targetField = null;
			hide();
		}
		
		public function initKeys():void
		{
			arr_keys = new Array();
			var key:Key;
			
			key = new Key();
			key.name = "a";
			key.x = 20;
			key.y = 100;
			key.addEventListener(MouseEvent.CLICK, addToText);
			arr_keys.push(key);
			this.addChild(key);
			
			key = new Key();
			key.name = "b";
			key.x = 20;
			key.y = 150;
			key.addEventListener(MouseEvent.CLICK, addToText);
			arr_keys.push(key);
			this.addChild(key);
			
			key = new Key();
			key.name = "c";
			key.x = 20;
			key.y = 200;
			key.addEventListener(MouseEvent.CLICK, addToText);
			arr_keys.push(key);
			this.addChild(key);
			
			key = new Key();
			key.name = "d";
			key.x = 20;
			key.y = 250;
			key.addEventListener(MouseEvent.CLICK, addToText);
			arr_keys.push(key);
			this.addChild(key);
			
			key = new Key();
			key.name = "enter";
			key.x = 20;
			key.y = 300;
			key.addEventListener(MouseEvent.CLICK, onEnter);
			arr_keys.push(key);
			this.addChild(key);
		}

		private function initDisplay():void
		{
			var txt_format:TextFormat = new TextFormat();
			txt_format.size = 12;
			txt_format.align = TextFormatAlign.LEFT;
			txt_format.color = 0xaaaaaa;
			txt_format.bold = false;
			txt_format.font = "Verdana";
			
			txtDisplay = new TextField();
			txtDisplay.defaultTextFormat = txt_format;
			txtDisplay.border = true;
			txtDisplay.borderColor = 0xaaaaaa;
			txtDisplay.wordWrap = false;
			txtDisplay.width = 200;
			txtDisplay.height = 25;
			txtDisplay.x = 20;
			txtDisplay.y = 20;
			this.addChild(txtDisplay);
		}
		
		public function show():void
		{
			this.txtDisplay.text = _targetField.text;
			this.y = 0;
			this.parent.addChild(this);
		}
		
		public function hide():void
		{
			this.y = 800;
		}
		
		public function destroy():void
		{
			_targetField = null;
			
			this.removeChild(txtDisplay);
			txtDisplay = null;
			
			for each(var k:Key in arr_keys){
				k.destroy();
				k=null;
			}
			this.parent.removeChild(this);
		}
		public function set targetField(field:TextField):void
		{
			_targetField = field;
		}
	}//class
}//package