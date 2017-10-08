package;

import flixel.FlxG;
import flixel.FlxSprite;
import source.Reg;

/**
 * ...
 * @author G
 */
class Upgrade extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		loadGraphic(AssetPaths.upgrade__png, true, 16, 16);
		animation.add("anim", [0, 1, 2, 3], 6, true);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX - 50, 0);
		animation.play("anim");

		OOB();
	}

	function OOB():Void
	{
		if (x <= FlxG.camera.scroll.x)
			destroy();
	}

}