package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxStrip;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.system.FlxAssets;
import source.Reg;
/**
 * ...
 * @author G
 */
class GameOver extends FlxState 
{
	private var cartelito1:FlxText;
	private var cartelito2:FlxText;
	private var cartelito3:FlxText;
	private var conta1:Int;
	private var conta2:Int;
	private var Apagado:Bool;
	private var background:FlxBackdrop;
	private var cartelito4:FlxText;

	override public function create():Void 
	{
		super.create();
		FlxG.sound.pause();
		cartelito1 = new FlxText(20, 30, 0, "Score: " + Reg.score, 24);
		cartelito2 = new FlxText(20, 60, 0, "HighScore: " + (Reg.HighScore) , 24);
		cartelito3 = new FlxText(20, 120, 0, "GAME OVER", 24);
		cartelito4 = new FlxText(50, 150, 0, "Press R to restart", 16);
		cartelito1.color = 0xFFFFFFFF;
		cartelito2.color = 0xFFFFFFFF;
		cartelito3.color = 0xFFFFFFFF;
		cartelito4.color = 0xFFFFFFFF;
		background = new FlxBackdrop(AssetPaths.spaceBackground__png);
		add(background);
		add(cartelito1);
		add(cartelito2);
		add(cartelito3);
		add(cartelito4);
		cartelito2.kill();
		cartelito3.kill();
		conta1 = 0;
		conta2 = 0;
		Apagado = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);		
		if (FlxG.keys.justPressed.R)		
			FlxG.switchState(new Menu());
 		if (conta1 == 60 && cartelito2.alive == false)		
			cartelito2.revive();		 		 	
		if (conta2 == 30)
		{
			if (Apagado == false)
			{
				cartelito3.revive();				
				Apagado = true;
				conta2 = 0;
			}
			else
			{
				cartelito3.kill();
				Apagado = false;
				conta2 = 0;
			}
		}	
		conta1++;
		conta2++;
	}	
}