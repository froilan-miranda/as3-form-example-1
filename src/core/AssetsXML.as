package core
{
import events.CustomEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class AssetsXML extends EventDispatcher {
	private var _assetsXML:XML;
	private var xmlLoader:URLLoader = new URLLoader  ;
	private static var _instance:AssetsXML;

	public function AssetsXML():void
	{
		xmlLoader.addEventListener(Event.COMPLETE,onXMLloadComplete);
		xmlLoader.load(new URLRequest("assets/xml/formOptions.xml"));
	}

	private function onXMLloadComplete(event:Event):void
	{
		_assetsXML = new XML(event.target.data);
		_instance = this;

		trace("ASSETS XML IMPORTED: \n" + _assetsXML);

		this.dispatchEvent(new CustomEvent(CustomEvent.XML_LOADED, true));
		xmlLoader.removeEventListener(Event.COMPLETE,onXMLloadComplete);
	}
	
	
	public function get xmlData():XML
	{
		return _assetsXML;
	}

	internal function getValueInt(param:String):int
	{
		var paramValue:int = int(assetsXML.setting.(@param == param));
		trace(paramValue + " is the value for :" + param);
		return paramValue;
	}

	internal function getValueNum(param:String):Number
	{
		var paramValue:Number = Number(assetsXML.setting.(@param == param));
		trace(paramValue + " is the value for :" + param);
		return paramValue;
	}

	internal function getValueString(param:String):String
	{
		var paramString:String = assetsXML.setting.(@param == param);
		trace(paramString + " is the value for :" + param);
		return paramString;
	}

	public static function get instance():AssetsXML
	{
		return _instance;
	}
}//class
}//package