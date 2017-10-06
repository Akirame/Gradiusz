package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxAngle;
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
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		toDown = false;
		countDown = 0;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		velocity.set(0, 0);		
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
		if (countDown >= 1 * FlxG.updateFramerate)
		{
			var vel:Float = 150;
			
			balita = new BulletEnemy(x, y + height / 2);
			balita.velocity.set( -vel, 0);
			FlxG.state.add(balita);
			
			balita = new BulletEnemy(x, y + height / 2);
			balita.velocity.set( vel * Math.cos(FlxAngle.asDegrees(-45)), vel * Math.sin(FlxAngle.asDegrees(-45)));
			FlxG.state.add(balita);
			
			balita = new BulletEnemy(x, y + height / 2);
			balita.velocity.set( vel * Math.cos(FlxAngle.asDegrees(45)), vel * Math.sin(FlxAngle.asDegrees(45)));
			FlxG.state.add(balita);
			
			countDown = 0;
		}
		else
			countDown++;
	}
	function isAlive() 
	{
		if (Reg.bossHP <= 0)
			destroy();
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