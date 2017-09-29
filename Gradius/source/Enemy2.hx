package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import source.Reg;

/**
 * ...
 * @author ...
 */
class Enemy2 extends Enemy 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		velocity.set(Reg.camVelocityX, 0);
	}
	
}