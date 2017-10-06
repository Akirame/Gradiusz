package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.debug.interaction.tools.Eraser.GraphicEraserTool;
import flixel.tile.FlxTilemap;
import source.Reg;
import flixel.addons.editors.ogmo.FlxOgmoLoader;

class PlayState extends FlxState
{
	private var backGround:FlxBackdrop;
	private var p1:Player;
	private var followPoint:FlxSprite;
	private var loader:FlxOgmoLoader;
	private var tilemap:FlxTilemap;
	private var enemyGroup:FlxTypedGroup<Enemy>;
	private var backGround2:FlxBackdrop;
	var bossito:Boss;
	
	override public function create():Void
	{
		super.create();
		backGround = new FlxBackdrop(AssetPaths.spaceBackground__png);
		backGround2 = new FlxBackdrop(AssetPaths.spaceBackground2__png, 0.5,0.5);
		
		FlxG.worldBounds.set(2400, 240);
		enemyGroup = new FlxTypedGroup<Enemy>();
		
		loader = new FlxOgmoLoader(AssetPaths.level1__oel);
		tilemap = loader.loadTilemap(AssetPaths.tiles2__png, 16, 16, "tiles");
		for (i in 0...11)
		{
			if (i == 0 || i == 4 || i == 8)
				tilemap.setTileProperties(i, FlxObject.NONE);
			else
				tilemap.setTileProperties(i, FlxObject.ANY);
		}
		loader.loadEntities(placeEntities, "entities");
		
		followPoint = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
		followPoint.makeGraphic(1, 1, 0x00000000);
		followPoint.velocity.x = Reg.camVelocityX;
		FlxG.camera.follow(followPoint);
	
		add(followPoint);
		add(backGround);
		add(backGround2);
		add(p1);
		add(p1.bulletGroup);
		add(tilemap);
		add(enemyGroup);
		add(bossito);
	}
	
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		GameOver();
		RespawnEnemy();
		Collides();
		
		if (followPoint.x >= tilemap.width - 2200 )
		{
			Reg.camVelocityX = 0;
			followPoint.velocity.x = Reg.camVelocityX;
			if (bossito.alive == false)
				bossito.revive();
		}
	}
		
	
	private function placeEntities(entityName:String, entityData:Xml):Void // inicializar entidades
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		
		switch (entityName)
		{
			case "player":
				p1 = new Player(x, y);
			case "enemy1":
				var e:Enemy1 = new Enemy1(x, y);
				e.makeGraphic(16, 16, 0xFF0000FF);
				enemyGroup.add(e);
				e.kill();
			case "enemy2":
				var e:Enemy2 = new Enemy2(x, y);
				e.makeGraphic(16, 16, 0xFFFF00FF);
				enemyGroup.add(e);
				e.kill();
			case "enemy3":
				var e:Enemy3 = new Enemy3(x, y);
				e.makeGraphic(16, 16, 0xFF00FFFF);
				enemyGroup.add(e);
				e.kill();
			case "boss":
				bossito = new Boss(x, y);
				bossito.makeGraphic(64, 64, 0xFF00FFFF);
				bossito.kill();				
		}
	}
	
	
	function PlayerDeath():Void // player death
	{
		Reg.lives--;
		FlxG.resetState();
	}

	
	function RespawnEnemy():Void // respawnear y matar enemigos
	{
		for ( enemy in enemyGroup)
		{
			if ( (enemy.x <= (FlxG.camera.scroll.x + FlxG.camera.width + 10)) && enemy.alive == false)
				enemy.revive();
			if ((enemy.x >=  FlxG.camera.scroll.x + FlxG.camera.width + 30 || enemy.x <= FlxG.camera.scroll.x-20) && enemy.alive)
				enemyGroup.remove(enemy, true);
		}
		
	}
	function GameOver():Void 
	{
		if ( Reg.lives < 0)
			FlxG.resetState();
	}
	
	function Collides():Void 
	{
		FlxG.collide(tilemap, p1, CollideTilePlayer); // colision entre tiles y player
		FlxG.collide(tilemap, p1.bulletGroup, CollideTileBullet); // colision entre tiles y bullet
		FlxG.collide(p1.bulletGroup, enemyGroup, CollideBulletAndEnemy); //colision entre balas y enemigos
		FlxG.collide(enemyGroup, p1, CollidePlayerEnemy); // coliision entre enemigos y player
		FlxG.overlap(bossito, p1.bulletGroup, CollideBossAndBullet); // colision boss y bullet
		FlxG.collide(bossito, p1, CollideBossAndPlayer);		
	}
	
	function CollideBossAndPlayer(b:Boss, p:Player)
	{
		p1.kill();
	}
	
	function CollideBossAndBullet(b:Boss, p:BulletPlayer)
	{
		p1.bulletGroup.remove(p);
		Reg.bossHP -= 10;
	}
	
	function CollideTileBullet(t:FlxTilemap,b:BulletPlayer) // colision entre tiles y bullet
	{
		p1.bulletGroup.remove(b,true);
	}
	
	function CollideTilePlayer(t:FlxTilemap,p1:Player):Void	// colision entre tiles y player
	{
		PlayerDeath();
		p1.destroy();	
	}
	
	function CollidePlayerEnemy(e:Enemy,p:Player):Void // colision entre player y enemigo
	{
		PlayerDeath();
		p.destroy();
	}
	
		function CollideBulletAndEnemy(b:BulletPlayer,e:Enemy)  // colision entre bala y enemigo
	{
		p1.bulletGroup.remove(b,true);
		enemyGroup.remove(e);
	}
}