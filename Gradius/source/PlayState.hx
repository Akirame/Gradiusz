package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import source.Reg;

class PlayState extends FlxState
{
	private var backGround:FlxBackdrop;
	private var p1:Player;
	var followPoint:FlxSprite;
	
	override public function create():Void
	{
		super.create();
		backGround = new FlxBackdrop(AssetPaths.spaceBackground__png);
		//FlxG.worldBounds.set
		
		p1 = new Player(FlxG.height / 2, FlxG.width / 2, AssetPaths.ship__png);
		
		followPoint = new FlxSprite(FlxG.height / 2, FlxG.width / 2);
		followPoint.makeGraphic(1, 1, 0x00000000);
		followPoint.velocity.x = Reg.camVelocityX;
		FlxG.camera.follow(followPoint);
		
		add(followPoint);
		add(backGround);
		add(p1);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}