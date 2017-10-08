package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.debug.interaction.tools.Eraser.GraphicEraserTool;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxBar;
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
	private var bossito:Boss;
	private var bulletGroup:FlxTypedGroup<BulletEnemy>;
	private var bulletPlayerGroup:FlxTypedGroup<BulletPlayer>;
	private	var upgradecito:Upgrade;
	private	var bossHPBar:FlxBar;
	
	override public function create():Void
	{
		super.create();
		Init();
		FlxG.worldBounds.set(2400, 240);
		
		backGround = new FlxBackdrop(AssetPaths.spaceBackground__png);
		backGround2 = new FlxBackdrop(AssetPaths.spaceBackground2__png, 0.5,0.5);
		add(backGround);
		add(backGround2);
		
		enemyGroup = new FlxTypedGroup<Enemy>();
		bulletGroup = new FlxTypedGroup<BulletEnemy>();
		bulletPlayerGroup = new FlxTypedGroup<BulletPlayer>();

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

		upgradecito = new Upgrade(200, 50);
		
		add(followPoint);
		add(tilemap);
		add(p1);				
		add(enemyGroup);
		add(bossito);
		add(bulletPlayerGroup);
		add(bulletGroup);
		add(upgradecito);
	}
	
	function Init() 
	{
		Reg.camVelocityX = 30;
		Reg.countUpgrade = 0;
		Reg.missileUpgrade = false;
		Reg.optionUpgrade = false;
		Reg.shieldUpgrade = 0;
		Reg.shipVelocityX  = 100;
		Reg.shipVelocityY = 100;
		Reg.bossHP = 100;
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
			{
				bossito.revive();
				bossHPBar = new FlxBar((FlxG.camera.scroll.x + FlxG.camera.width-75)/2,2, LEFT_TO_RIGHT, 150, 20, Reg, "bossHP", 0, 100);
				bossHPBar.createFilledBar(0xFF000000, 0xFFFF0000, true, 0xFF00FF00);
				add(bossHPBar);
			}
			if (Reg.bossHP == 0)
				bossHPBar.destroy();
		}
	}

	private function placeEntities(entityName:String, entityData:Xml):Void // inicializar entidades
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));

		switch (entityName)
		{
			case "player":
				p1 = new Player(x, y, bulletPlayerGroup);
			case "enemy1":
				var e:Enemy1 = new Enemy1(x, y, null, bulletGroup);
				e.makeGraphic(16, 16, 0xFF0000FF);
				enemyGroup.add(e);
				e.kill();
			case "enemy2":
				var e:Enemy2 = new Enemy2(x, y,null, bulletGroup);
				e.makeGraphic(16, 16, 0xFFFF00FF);
				enemyGroup.add(e);
				e.kill();
			case "enemy3":
				var e:Enemy3 = new Enemy3(x, y, null, bulletGroup);
				e.makeGraphic(16, 16, 0xFF00FFFF);
				enemyGroup.add(e);
				e.kill();
			case "boss":
				bossito = new Boss(x, y, null, bulletGroup);
				bossito.makeGraphic(64, 64, 0xFF00FFFF);
				bossito.kill();
		}
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
	
		function PlayerDeath():Void // player death
	{
			Reg.lives--;
			FlxG.resetState();
	}
	
	function GameOver():Void // Gameover?
	{
		if ( Reg.lives < 0)
			FlxG.resetState();
	}
	
	function ShieldOK() // Shield activado?
	{
		if (Reg.shieldUpgrade == 0)
			PlayerDeath();
		else
			Reg.shieldUpgrade--;
	}

	function Collides():Void
	{
		FlxG.collide(tilemap, p1, CollideTilePlayer); // colision entre tiles y player
		FlxG.collide(tilemap, bulletPlayerGroup, CollideTileBullet); // colision entre tiles y bullet
		FlxG.collide(bulletPlayerGroup, enemyGroup, CollideBulletAndEnemy); //colision entre bullet player y enemigos
		FlxG.overlap(bossito, bulletPlayerGroup, CollideBossAndBullet); // colision boss y bullet player
		FlxG.collide(enemyGroup, p1, CollidePlayerEnemy); // colision entre enemigos y player
		FlxG.collide(bulletGroup, p1, CollideEnemyBulletAndPlayer); // colision entre bala enemiga y player
		FlxG.overlap(upgradecito, p1, CollidePlayerUpgrade); // colision entre uptrade y player
		FlxG.collide(bossito, p1, CollideBossAndPlayer); // colision entre boss y player
	}

	function CollidePlayerUpgrade(u:Upgrade, p:Player) //colision entre upgrade y player
	{
		u.destroy();
		if (Reg.countUpgrade < 5)
			Reg.countUpgrade++;
		else
			Reg.countUpgrade = 0;
	}

	function CollideEnemyBulletAndPlayer(b:BulletEnemy,p:Player) //colision entre bala enemiga y player
	{
		ShieldOK();
		bulletGroup.remove(b);
	}

	
	function CollideBossAndBullet(b:Boss, p:BulletPlayer) //colision bala player y boss
	{
		bulletPlayerGroup.remove(p, true);
		Reg.bossHP -= 10;
	}

	function CollideTileBullet(t:FlxTilemap,p:BulletPlayer) // colision entre tiles y bullet player
	{
		bulletPlayerGroup.remove(p, true);
	}

	function CollideBulletAndEnemy(p:BulletPlayer,e:Enemy)  // colision entre bala player y enemigo
	{
		bulletPlayerGroup.remove(p, true);
		enemyGroup.remove(e);
	}
	
	function CollideBossAndPlayer(b:Boss, p:Player) //colision player y boss
	{
		PlayerDeath();
	}
	
	function CollidePlayerEnemy(e:Enemy,p:Player):Void // colision entre player y enemigo
	{
		PlayerDeath();		
	}

	function CollideTilePlayer(t:FlxTilemap,p:Player):Void	// colision entre player y tiles
	{
		PlayerDeath();
	}
}