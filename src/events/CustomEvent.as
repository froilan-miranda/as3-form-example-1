package events
{

import flash.events.Event;

public class CustomEvent extends Event
{
	public static const XML_LOADED:String = "XmlLoaded";
	public static const SCENE_EXIT:String = "SceneExit";
	public static const GAME_RESET:String = "GameReset";
	
	public static const EVENT_DEFUALT:String = "Defualt";

	public function CustomEvent(type:String = CustomEvent.EVENT_DEFUALT, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
	
	override public function clone():Event
	{
		return new CustomEvent(type, bubbles, cancelable);
	}
}
}