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
	public var bulletGroup(get, null):FlxTypedGroup<BulletPlayer>;
	private var delayShoot:Int;
	private var playerMissile:MissilePlayer;
	

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		bulletGroup = new FlxTypedGroup();
		delayShoot = Reg.delay;	
		animations();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		velocity.set(Reg.camVelocityX, 0);
		PlayerMovement();
		Shoot();
		OOB();
		adquireUpgrade();
		if (Reg.shieldUpgrade == 0)
			animation.play("anim1");
		else
			animation.play("anim2");
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
			if (Reg.missileUpgrade)
			{
				playerMissile = new MissilePlayer(x + width, y + height / 4);
				bulletGroup.add(playerMissile);
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

		for (bullet in bulletGroup)
		{
			if (bullet.x >= FlxG.camera.scroll.x + FlxG.camera.width || bullet.y >= FlxG.camera.scroll.y + FlxG.camera.height)
				bulletGroup.remove(bullet, true);
		}
	}

	function DiagonalVelocity():Float
	{
		return ((Math.sqrt(Math.pow(Reg.shipVelocityX, 2) + Math.pow(Reg.shipVelocityY, 2))) / 2) / 100;
	}

	public function get_bulletGroup():FlxTypedGroup<BulletPlayer>
	{
		return bulletGroup;
	}

	function animations():Void
	{		
			loadGraphic(AssetPaths.animatedShip__png, true, 32, 20);
			animation.add("anim1", [0, 1, 2, 3], 16, true);
			animation.add("anim2", [4, 5, 6, 7], 16, true);
	}
	
	function adquireUpgrade():Void 
	{
		if (FlxG.keys.justPressed.X)
		{
			switch (Reg.countUpgrade)
			{
				case 1:
					Reg.shipVelocityX += 30;
					Reg.shipVelocityX += 30;
					Reg.countUpgrade = 0;
				case 2:
					Reg.shieldUpgrade = 2;
					Reg.countUpgrade = 0;
				case 3:
					Reg.missileUpgrade = true;
					Reg.countUpgrade = 0;
				case 4:
					Reg.optionUpgrade = true;
					Reg.countUpgrade = 0;
			}
		}
	}

}