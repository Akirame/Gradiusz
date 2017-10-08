package source;
import flixel.math.FlxPoint;

/**
 * ...
 * @author G
 */
class Reg
{
	static public var camVelocityX:Int = 30;
	static public var shipVelocityX:Int = 80;
	static public var shipVelocityY:Int = 80;
	inline public static var delay:Int = 45;
	static public var lives:Int = 3;
	static public var bossHP:Float = 600;
	static public var countUpgrade:Int = 0;
	static public var countSpeed:Int = 0;
	static public var missileUpgrade:Bool = false;
	static public var shieldUpgrade:Int = 0;
	static public var shieldbool:Bool = false;
	static public var optionUpgrade:Bool = false;
	static public var position:FlxPoint = new FlxPoint();
	static public var velocityBullet:Float = 150;
	static public var score:Int = 0;
	static public var HighScore:Int = 2000;
	
	
}