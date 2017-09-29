package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import source.Reg;

/**
 * ...
 * @author G
 */
class Player extends FlxSprite 
{
	private var playerBullet:Bullet;
	private var bulletGroup:FlxTypedGroup<Bullet>;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		bulletGroup = new FlxTypedGroup();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX, 0);
		
		PlayerMovement();
		if (FlxG.keys.justPressed.K)
		{
			playerBullet = new Bullet(x,y, AssetPaths.playerBullet__png);
			bulletGroup.add(playerBullet);
			FlxG.state.add(bulletGroup);
		}
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