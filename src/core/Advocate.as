package core
{

	import flash.display.Sprite;
	
	[SWF(width="800", height="600", framRate="30", backgroundColor = "0x000000")]
	public class Advocate extends Sprite
	{
		private var app:App;

		public function Advocate()
		{
			this.app = new App();
			this.addChild(app);
		}
	}//class
}//package