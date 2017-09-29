package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import source.Reg;

/**
 * ...
 * @author G
 */
class Player extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX, 0);
		
		PlayerMovement();
						
	}
	
	function PlayerMovement():Void 
	{
		if (FlxG.keys.pressed.A)
			velocity.x -= 100;
		if (FlxG.keys.pressed.D)
			velocity.x += 100;
		if (FlxG.keys.pressed.W)
			velocity.y -= 100;
		if (FlxG.keys.pressed.S)
			velocity.y += 100;
		//if (FlxG.keys.pressed.A && FlxG.keys.pressed.S)
		//{
			//velocity.x -= 70.5;
			//velocity.y += 70.5;
		//}
		//if (FlxG.keys.pressed.A && FlxG.keys.pressed.W)
		//{
			//velocity.x -= 70.5;
			//velocity.y -= 70.5;
		//}
			//if (FlxG.keys.pressed.W && FlxG.keys.pressed.D)
		//{
			//velocity.x += 70.5;
			//velocity.y -= 70.5;
		//}
			//if (FlxG.keys.pressed.S && FlxG.keys.pressed.D)
		//{
			//velocity.x += 70.5;
			//velocity.y += 70.5;
		//}
			//if ((FlxG.keys.pressed.S && FlxG.keys.pressed.W) || (FlxG.keys.pressed.A && FlxG.keys.pressed.D))
		//{
			//velocity.x += Reg.camVelocityX;
			//velocity.y = 0;
		//}
	}
	
}