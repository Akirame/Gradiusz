package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxAngle;
import flixel.ui.FlxBar;
import source.Reg;

/**
 * ...
 * @author ...
 */
class Boss extends Enemy
{
	private var toDown:Bool;
	private var countDown:Int;
	private var balita:BulletEnemy;
	private var bulletGroupRef:FlxTypedGroup<BulletEnemy>;

	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset, bulletGroup:FlxTypedGroup<BulletEnemy>)
	{
		super(X, Y, SimpleGraphic, bulletGroup);
		loadGraphic(AssetPaths.bossMoon__png, true, 64, 64);
		animation.add("anim", [0, 1, 2, 3], 3, true);
		bulletGroupRef = bulletGroup;
		toDown = false;
		countDown = 0;
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		velocity.set(0, 0);
		animation.play("anim");
		OOB();
		if (x <= FlxG.camera.scroll.x + FlxG.camera.width - 84)
		{
			velocity.x = 0;
			Movement();
			Shoot();
		}
		else
		{
			velocity.x = -40;
		}
		isAlive();
	}

	function Shoot()
	{
		if (countDown >= 0.7 * FlxG.updateFramerate)
		{
			
			balita = new BulletEnemy(x, y + height / 2);
			balita.velocity.set( -Reg.velocityBullet, 0);
			bulletGroupRef.add(balita);

			balita = new BulletEnemy(x, y + height / 2);
			balita.angle = 45;
			balita.velocity.set( Reg.velocityBullet * Math.cos(FlxAngle.asDegrees(-45)), Reg.velocityBullet * Math.sin(FlxAngle.asDegrees(-45)));
			bulletGroupRef.add(balita);

			balita = new BulletEnemy(x, y + height / 2);
			balita.angle = -45;
			balita.velocity.set( Reg.velocityBullet * Math.cos(FlxAngle.asDegrees(45)), Reg.velocityBullet * Math.sin(FlxAngle.asDegrees(45)));
			bulletGroupRef.add(balita);

			countDown = 0;
		}
		else
			countDown++;
	}
	function isAlive()
	{
		if (Reg.bossHP <= 0)
		{
			destroy();
		}
	}

	function OOB()
	{
		if (y <= FlxG.camera.y && toDown == false)
			toDown = true;
		if (y >= FlxG.camera.y + FlxG.camera.height - height && toDown == true)
			toDown = false;
	}

	function Movement()
	{
		if (toDown == false)
			velocity.y -= 40;
		else
			velocity.y += 40;
	}
}