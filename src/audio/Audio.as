package audio
{
import flash.media.SoundChannel;
import flash.media.Sound;
import flash.net.URLRequest;

public class Audio extends Object
{
	private static var sndChannel0:SoundChannel = new SoundChannel();	//background 
	private static var sndChannel1:SoundChannel = new SoundChannel();	//misc game soundsd

	private static var arrSoundChanels:Array = [sndChannel0,sndChannel1]

	private static var sndBttn1:Sound = new Sound;
	private static var sndBttn1Path:URLRequest = new URLRequest("assets/audio/click.mp3");

	//public function Audio():void
	{
		sndBttn1.load(sndBttn1Path);
	}

	public static function playBttn1Sound(sideId:int):void {
		arrSoundChanels[sideId] = sndBttn1.play(0);
	}

	public static  function stopSoundChannel(sideId:int):void {
		arrSoundChanels[sideId].stop();
	}
}//class
}//package