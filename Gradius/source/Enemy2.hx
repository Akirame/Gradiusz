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
class Enemy2 extends Enemy
{
	private var balita:BulletEnemy;
	var bulletGroupRef:FlxTypedGroup<BulletEnemy>;
	var count:Float = 0;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, bulletGroup:FlxTypedGroup<BulletEnemy>)
	{
		super(X, Y, SimpleGraphic, bulletGroup);
		loadGraphic(AssetPaths.alien3__png, true, 16, 16);
		animation.add("anim", [0, 1, 2, 3], 6, true);
		bulletGroupRef = bulletGroup;		
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		animation.play("anim");
		velocity.set(Reg.camVelocityX - 30, 0);
		Shoot();
	}

	public function Shoot()
	{
		
		if ( count == 1 * FlxG.updateFramerate)
		{	
		FlxG.sound.play(AssetPaths.EnemyShoot__wav, 0.70,false);
		balita = new BulletEnemy(x, y + height / 2);
		balita.angle = 45;
		balita.velocity.set (Reg.velocityBullet * Math.cos(FlxAngle.asDegrees( -45)), Reg.velocityBullet * Math.sin(FlxAngle.asDegrees(-45)));
		bulletGroupRef.add(balita);
		count = 0;
		}
		else
			count++;
	}
}