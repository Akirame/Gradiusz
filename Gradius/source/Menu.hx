package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import source.Reg;

/**
 * ...
 * @author G
 */
class Menu extends FlxState
{
	private var title:FlxText;
	private var start:FlxText;
	private var conta:Int;
	private var name:FlxText;

	override public function create():Void
	{
		super.create();
		FlxG.camera.bgColor = 0xFF000000;
		title = new FlxText(50, -20, 0, "Gradius", 32);
		name = new FlxText(50, FlxG.height - 30, 0, "G Villalba", 24);
		name.color = 0xFFFF0000;
		start = new FlxText(10, 140, 0, "Press Z to start!", 24);
		conta = 0;
		add(title);
		add(start);
		add(name);
		start.kill();
		FlxG.sound.playMusic(AssetPaths.Intro__wav, 1, false	);
		Reg.lives = 3;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		animText();
		if (FlxG.keys.justPressed.Z)
		{
			FlxG.switchState(new PlayState());
		}
	}
	
	function animText():Void 
	{
		if (title.y != 50)
			title.y += 0.5;
		else
			title.y = 50;
		if (conta == 30)
		{
			if (!start.alive)
				start.revive();
			else
				start.kill();
			conta = 0;
		}
		else
			conta++;
	}

}