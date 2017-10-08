package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;
import flixel.system.FlxAssets.FlxGraphicAsset;
import source.Reg;

/**
 * ...
 * @author ...
 */
class Enemy1 extends Enemy
{
	private var move:Bool;
	private var balita:BulletEnemy;
	var bulletGroupRef:FlxTypedGroup<BulletEnemy>;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, bulletGroup:FlxTypedGroup<BulletEnemy>)
	{
		super(X, Y, SimpleGraphic, bulletGroup);
		loadGraphic(AssetPaths.Alien1__png, true, 16, 16);
		animation.add("anim", [0, 1], 6, true);
		bulletGroupRef = bulletGroup;
		move = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		animation.play("anim");
		velocity.set(Reg.camVelocityX, 0);
		Movement();
	}

	function Movement():Void
	{
		if (x < FlxG.camera.scroll.x + FlxG.camera.width - FlxG.camera.width/3 || move == true)
			move = true;
		else
			move = false;
		if (x < FlxG.camera.scroll.x + FlxG.camera.width - FlxG.camera.width / 3)
			Shoot();

		if (move == true)
		{
			velocity.x += 130;
			velocity.y += 50;
		}
		else
			velocity.x -= 50;
	}

	public function Shoot()
	{
		balita = new BulletEnemy(x, y + height / 2);
		balita.angle = 45;
		balita.velocity.set( Reg.velocityBullet * Math.cos(FlxAngle.asDegrees(-45)), Reg.velocityBullet * Math.sin(FlxAngle.asDegrees(-45)));
		bulletGroupRef.add(balita);
		
		balita = new BulletEnemy(x, y + height / 2);
		balita.angle = -45;
		balita.velocity.set( Reg.velocityBullet * Math.cos(FlxAngle.asDegrees(45)), Reg.velocityBullet * Math.sin(FlxAngle.asDegrees(45)));
		bulletGroupRef.add(balita);
	}
}