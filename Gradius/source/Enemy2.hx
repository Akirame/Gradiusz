package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import source.Reg;

/**
 * ...
 * @author ...
 */
class Enemy2 extends Enemy
{
	private var move:Bool;
	private var balita:BulletEnemy;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		move = false;
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX, 0);
		Movement();
	}

	function Movement():Void
	{
		if (x < FlxG.camera.scroll.x + FlxG.camera.width / 2 || move == true)
		{
			move = true;
		}
		else
			move = false;
		
		if (x < FlxG.camera.scroll.x + FlxG.camera.width / 2)
			shoot();

		if (move == true)
		{
			velocity.x += 130;
			velocity.y -= 50;
		}
		else
			velocity.x -= 30;
	}

	public function shoot()
	{
		balita = new BulletEnemy(x, y + height/2);
		FlxG.state.add(balita);
	}
}