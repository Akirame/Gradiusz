package;
import flixel.math.FlxAngle;
import source.Reg;

/**
 * ...
 * @author G
 */
class MissilePlayer extends BulletPlayer 
{

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		loadGraphic(AssetPaths.missile__png, true, 16, 16);
		animation.add("anim", [0, 1,2,3], 6, true);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		animation.play("anim");
		velocity.set((Reg.camVelocityX + 150) * Math.cos(FlxAngle.asDegrees(100)), 150 * Math.sin(FlxAngle.asDegrees(45)));
	}
	
}