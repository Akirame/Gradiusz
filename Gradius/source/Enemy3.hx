package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import source.Reg;

/**
 * ...
 * @author G
 */
class Enemy3 extends Enemy
{
	private var countMoveLeft:Int;
	private var countMoveUp:Int;
	private var countMoveDown:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		countMoveLeft = 0;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX, 0);	
		
		//if (countMoveLeft != 50)
		//{
			//velocity.x -= 50;
			//countMove++;
		//}
		//else
		//{
			//velocity.x = Reg.camVelocityX;
			//velocity.y = -50;
		//}
			
	}
	
}