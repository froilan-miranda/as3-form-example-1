package objects.vk
{
	import flash.display.Sprite;
	
	internal class Key extends Sprite
	{
		public function Key()
		{
			this.graphics.beginFill(0x999999, 1.0);
			this.graphics.drawRect(0, 0, 40, 40);
			this.graphics.endFill();
		}
		internal function destroy():void
		{
			this.parent.removeChild(this);
		}
	}
}