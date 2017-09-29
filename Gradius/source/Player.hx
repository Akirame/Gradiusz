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
	private var playerBullet:BulletPlayer;
	private var bulletGroup:FlxTypedGroup<BulletPlayer>;
	private var delayShoot:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		bulletGroup = new FlxTypedGroup();
		FlxG.state.add(bulletGroup);
		delayShoot = Reg.delay;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX, 0);
		
		PlayerMovement();
		Shoot();
		OOB();
	}
	
	function PlayerMovement():Void 
	{
		if (FlxG.keys.pressed.LEFT)
			velocity.x -= Reg.shipVelocityX;
		if (FlxG.keys.pressed.RIGHT)
			velocity.x += Reg.shipVelocityX;
		if (FlxG.keys.pressed.UP)
			velocity.y -= Reg.shipVelocityY;
		if (FlxG.keys.pressed.DOWN)
			velocity.y += Reg.shipVelocityY;
		if (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.DOWN)
		{
			velocity.x *= 0.705;
			velocity.y *= 0.705;
		}
		if (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.UP)
		{
			velocity.x *= 0.705;
			velocity.y *= 0.705;
		}
		if (FlxG.keys.pressed.UP && FlxG.keys.pressed.RIGHT)
		{
			velocity.x *= 0.705;
			 velocity.y *= 0.705;
		}  
		if (FlxG.keys.pressed.DOWN && FlxG.keys.pressed.RIGHT)
		{
			velocity.x *= 0.705;
			 velocity.y *= 0.705;
		}  
		if ((FlxG.keys.pressed.DOWN && FlxG.keys.pressed.UP) || (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.RIGHT))
		{
			velocity.x = Reg.camVelocityX;
			velocity.y = 0;
		}
		
	}
	
	function Shoot():Void 
	{
		if (FlxG.keys.justPressed.Z && delayShoot >= Reg.delay)
		{
			playerBullet = new BulletPlayer(x + width,y + height / 4, AssetPaths.playerBullet__png); // experimental solamente para sprite de prueba
			bulletGroup.add(playerBullet);
			FlxG.state.add(playerBullet);
			delayShoot = 0;
		}
		else
			delayShoot++;
	}
	
	function OOB():Void 
	{
		if ( x + width > FlxG.camera.scroll.x + FlxG.camera.width)
			x = FlxG.camera.scroll.x + FlxG.camera.width - width;
		if ( x < FlxG.camera.scroll.x)
			x = FlxG.camera.scroll.x;
		if ( y < FlxG.camera.scroll.y)
			y = FlxG.camera.scroll.y;
		if ( y + height > FlxG.camera.scroll.y + FlxG.camera.height)
			y = FlxG.camera.scroll.y + FlxG.camera.height - height;
	}
	
}