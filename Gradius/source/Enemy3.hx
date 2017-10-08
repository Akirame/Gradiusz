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
class Enemy3 extends Enemy
{
	private var countDown:Int;
	private var acum:Int;
	private var balita:BulletEnemy;
	var bulletGroupRef:FlxTypedGroup<BulletEnemy>;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, bulletGroup:FlxTypedGroup<BulletEnemy>)
	{
		super(X, Y, SimpleGraphic, bulletGroup);
		loadGraphic(AssetPaths.alien2__png, true, 16, 16);
		animation.add("anim", [0, 1, 2, 3], 6, true);
		bulletGroupRef = bulletGroup;
		countDown = 0;
		acum = 0;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		animation.play("anim");
		velocity.set(Reg.camVelocityX, 0);

		if ( countDown == 50)
		{
			if (acum == 3)
				acum = 0;
			else
				acum++;
			countDown = 0;
			Shoot();
		}
		else
			countDown++;

		switch (acum)
		{
			case 0:
				velocity.x -= 50;
				velocity.y = 0;
			case 1:
				velocity.x = Reg.camVelocityX;
				velocity.y -= 50;
			case 2:
				velocity.x -= 50;
				velocity.y = 0;
			case 3:
				velocity.x = Reg.camVelocityX;
				velocity.y += 50;
		}
	}

	public function Shoot()
	{
		balita = new BulletEnemy(x, y + height/2);
		bulletGroupRef.add(balita);
	}
}