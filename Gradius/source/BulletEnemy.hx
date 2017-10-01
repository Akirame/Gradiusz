package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import source.Reg;

/**
 * ...
 * @author G
 */
class BulletEnemy extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.enemyBullet__png, true, 16, 16);
		animation.add("anim", [0, 1], 10, true);
	}
	
		
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX - 150, 0);
		animation.play("anim");
		OOB();
	}
	
	function OOB():Void 
	{
		if ( x < FlxG.camera.scroll.x)
			destroy();
	}
	
	
	
}