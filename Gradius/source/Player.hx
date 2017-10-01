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
	public var bulletGroup:FlxTypedGroup<BulletPlayer>;
	private var delayShoot:Int;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.animatedShip__png, true, 32, 16);
		bulletGroup = new FlxTypedGroup();
		FlxG.state.add(bulletGroup);
		delayShoot = Reg.delay;
		animation.add("anim", [0, 1, 2], 4, true);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX, 0);
		
		PlayerMovement();
		animation.play("anim");
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
			velocity.x *= DiagonalVelocity();
			velocity.y *= DiagonalVelocity();
		}
		if (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.UP)
		{
			velocity.x *= DiagonalVelocity();
			velocity.y *= DiagonalVelocity();
		}
		if (FlxG.keys.pressed.UP && FlxG.keys.pressed.RIGHT)
		{
			velocity.x *= DiagonalVelocity();
			velocity.y *= DiagonalVelocity();
		}  
		if (FlxG.keys.pressed.DOWN && FlxG.keys.pressed.RIGHT)
		{
			velocity.x *= DiagonalVelocity();
			velocity.y *= DiagonalVelocity();
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
			playerBullet = new BulletPlayer(x + width,y + height / 4); // experimental solamente para sprite de prueba
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
	
	function DiagonalVelocity():Float
	{
		return ((Math.sqrt(Math.pow(Reg.shipVelocityX, 2) + Math.pow(Reg.shipVelocityY, 2))) / 2) / 100;
	}
	
}