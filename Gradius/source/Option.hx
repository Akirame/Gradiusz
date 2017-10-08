package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxAssets.FlxGraphicAsset;
import source.Reg;

/**
 * ...
 * @author G
 */
class Option extends FlxSprite
{
	private var delayShoot:Float;
	private var bulletGroupRef:FlxTypedGroup<BulletPlayer>;
	var playerBullet:BulletPlayer;
	var playerMissile:MissilePlayer;
	var conta:Int;

	public function new(?X:Float = 0, ?Y:Float = 0, bulletGroup:FlxTypedGroup<BulletPlayer>)
	{
		super(X, Y);
		loadGraphic(AssetPaths.option__png, true, 16, 16);
		animation.add("anim", [0, 1, 2], 6, true);
		bulletGroupRef = bulletGroup;
		delayShoot = Reg.delay;
		conta = 0;
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		animation.play("anim");
		FlxVelocity.moveTowardsPoint(this, Reg.position, Reg.shipVelocityX  - 20, 120);
		Shoot();
		OOB();
	}

	function OOB()
	{
		for (bullet in bulletGroupRef)
		{			
			if (bullet.x >= FlxG.camera.scroll.x + FlxG.camera.width || bullet.y >= FlxG.camera.scroll.y + FlxG.camera.height)
				bulletGroupRef.remove(bullet, true);
		}
	}

	function Shoot()
	{
		if (FlxG.keys.justPressed.Z && delayShoot >= Reg.delay)
		{
			playerBullet = new BulletPlayer(x + width,y + height / 4); // experimental solamente para sprite de prueba
			bulletGroupRef.add(playerBullet);
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

	function DiagonalVelocity():Float
	{
		return ((Math.sqrt(Math.pow(Reg.shipVelocityX, 2) + Math.pow(Reg.shipVelocityY, 2))) / 2) / 100;
	}
}