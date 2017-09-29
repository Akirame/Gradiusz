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

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
		override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX + 250, 0);
		OOB();
		
	}
	
	function OOB():Void 
	{
		if (x > FlxG.camera.scroll.x + FlxG.camera.width)
			destroy();
	}
	
}