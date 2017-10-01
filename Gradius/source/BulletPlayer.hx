package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import source.Reg;

/**
 * ...
 * @author ...
 */
class BulletPlayer extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.playerBullet__png, true, 16, 16);
		animation.add("anim", [0, 1,2], 4, true);
	}
	
		override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX + 150, 0);
		animation.play("anim");
		OOB();
		
	}
	
	function OOB():Void 
	{
		if (x > FlxG.camera.scroll.x + FlxG.camera.width)
			destroy();
	}
	
}