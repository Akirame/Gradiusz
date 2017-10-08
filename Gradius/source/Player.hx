package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import Option;
import flixel.input.keyboard.FlxKey;
import source.Reg;
import sys.ssl.Key;

/**
 * ...
 * @author G
 */
class Player extends FlxSprite
{
	private var playerBullet:BulletPlayer;
	public var bulletGroupRef(get, null):FlxTypedGroup<BulletPlayer>;
	private var delayShoot:Int;
	private var playerMissile:MissilePlayer;
	public var optionsito:Option;
	private var conta:Int = 0;

	public function new(?X:Float = 0, ?Y:Float = 0, bulletGroup:FlxTypedGroup<BulletPlayer>)
	{
		super(X, Y);
		bulletGroupRef = bulletGroup;
		delayShoot = Reg.delay;	
		animations();
		optionsito = new Option(0, 0, bulletGroup);
		optionsito.kill();
	
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX, 0);
		PlayerMovement();
		Shoot();
		OOB();
		AdquireUpgrade();
		AnimationShield();
		Reg.position.set(x-16, y+10);		
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
			bulletGroupRef.add(playerBullet);
			FlxG.sound.play(AssetPaths.LaserShoot__wav, 0.80);
			if (Reg.missileUpgrade)
			{
				playerMissile = new MissilePlayer(x + width, y + height / 4);
				bulletGroupRef.add(playerMissile);
			}
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

		for (bullet in bulletGroupRef)
		{
			if (bullet.x >= FlxG.camera.scroll.x + FlxG.camera.width || bullet.y >= FlxG.camera.scroll.y + FlxG.camera.height)
				bulletGroupRef.remove(bullet, true);
		}
	}

	function DiagonalVelocity():Float
	{
		return ((Math.sqrt(Math.pow(Reg.shipVelocityX, 2) + Math.pow(Reg.shipVelocityY, 2))) / 2) / 100;
	}

	public function get_bulletGroupRef():FlxTypedGroup<BulletPlayer>
	{
		return bulletGroupRef;
	}

	function animations():Void
	{		
			loadGraphic(AssetPaths.animatedShip__png, true, 32, 20);
			animation.add("anim1", [0, 1, 2, 3], 16, true);
			animation.add("anim2", [4, 5, 6, 7], 16, true);
	}
	
	function AdquireUpgrade():Void 
	{
		if (Reg.countUpgrade > 5)
			Reg.countUpgrade = 0;	
		if (Reg.shieldbool == true && Reg.shieldUpgrade == 0)
			Reg.shieldbool = false;
		if (FlxG.keys.justPressed.X)
		{
			switch (Reg.countUpgrade)
			{
			case 1:
				if (Reg.countSpeed != 2)
				{					
					FlxG.sound.play(AssetPaths.Upgrade2__wav, 0.80);
					Reg.shipVelocityX += 10;
					Reg.shipVelocityY += 10;
					Reg.countUpgrade = 0;
					Reg.countSpeed++;
				}
				case 2:
					if (Reg.shieldbool == false)
					{
					FlxG.sound.play(AssetPaths.Upgrade2__wav, 0.80);
					Reg.shieldbool = true;
					Reg.shieldUpgrade = 2;
					Reg.countUpgrade = 0;
					}
				case 3:
					if (Reg.missileUpgrade != true)
					{
					FlxG.sound.play(AssetPaths.Upgrade2__wav, 0.80);
					Reg.missileUpgrade = true;
					Reg.countUpgrade = 0;
					}
				case 4:
					if (optionsito.alive == false)
					{
					FlxG.sound.play(AssetPaths.Upgrade2__wav, 0.80);
					Reg.optionUpgrade = true;
					optionsito.reset(x - 16, y + 16);
					Reg.countUpgrade = 0;
					}
			}
		}
	}
	
	function AnimationShield():Void 
	{
		if (Reg.shieldUpgrade == 0)
			animation.play("anim1");
		else
			animation.play("anim2");	
	}

}