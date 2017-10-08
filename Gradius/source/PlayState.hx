package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
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
	private var HUDSpeed:FlxSprite;
	private var HUDShield:FlxSprite;
	private var HUDMissile:FlxSprite;
	private var HUDOption:FlxSprite;
	private var contaUpgrade:Int;
	private var HUDlives:FlxSprite;
	private var HUDlivesText:FlxText;

	override public function create():Void
	{
		super.create();
		Init();
		
		backGround = new FlxBackdrop(AssetPaths.spaceBackground__png);
		backGround2 = new FlxBackdrop(AssetPaths.spaceBackground2__png, 0.5,0.5);
		add(backGround);
		add(backGround2);
	

		enemyGroup = new FlxTypedGroup<Enemy>();
		bulletGroup = new FlxTypedGroup<BulletEnemy>();
		bulletPlayerGroup = new FlxTypedGroup<BulletPlayer>();
		upgradecito = new Upgrade(0, 0);
		upgradecito.kill();

		LoadTilemap();
		FlxG.worldBounds.set(tilemap.width, tilemap.height);


		followPoint = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
		followPoint.makeGraphic(1, 1, 0x00000000);
		followPoint.velocity.x = Reg.camVelocityX;
		FlxG.camera.follow(followPoint);

		add(followPoint);
		add(tilemap);
		InitHUD();
		add(HUDSpeed);
		add(HUDShield);
		add(HUDMissile);
		add(HUDOption);
		
		add(enemyGroup);
		add(bossito);
		add(bulletPlayerGroup);
		add(bulletGroup);
		add(upgradecito);
		add(p1);
		add(p1.optionsito);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		GameOver();
		HUDUpdate();
		RespawnEnemy();
		Collides();
		BossRespawn();
	}

	function Init()
	{
		Reg.camVelocityX = 30;
		Reg.countUpgrade = 0;
		Reg.missileUpgrade = false;
		Reg.optionUpgrade = false;
		Reg.shieldUpgrade = 0;
		Reg.shieldbool = false;
		Reg.shipVelocityX  = 100;
		Reg.shipVelocityY = 100;
		Reg.bossHP = 100;
		Reg.countSpeed = 0;
		contaUpgrade = 0;
	}

	function HUDUpdate()
	{

		if (Reg.countSpeed == 2)
		{
			HUDSpeed.animation.add("idle", [0], 1, true);
			HUDSpeed.animation.add("active", [3], 1, true);
		}
		if (Reg.shieldbool == true)
		{
			HUDShield.animation.add("idle", [0], 1, true);
			HUDShield.animation.add("active", [3], 1, true);
		}
		else
		{
			HUDShield.animation.add("idle", [1], 1, true);
			HUDShield.animation.add("active", [2], 1, true);
		}
		if (Reg.missileUpgrade == true)
		{
			HUDMissile.animation.add("idle", [0], 1, true);
			HUDMissile.animation.add("active", [3], 1, true);
		}
		if (Reg.optionUpgrade == true)
		{
			HUDOption.animation.add("idle", [0], 1, true);
			HUDOption.animation.add("active", [3], 1, true);
		}
		switch (Reg.countUpgrade)
		{
			case 1:
				HUDSpeed.animation.play("active");
				HUDShield.animation.play("idle");
				HUDMissile.animation.play("idle");
				HUDOption.animation.play("idle");
			case 2:
				HUDSpeed.animation.play("idle");
				HUDShield.animation.play("active");
				HUDMissile.animation.play("idle");
				HUDOption.animation.play("idle");
			case 3:
				HUDSpeed.animation.play("idle");
				HUDShield.animation.play("idle");
				HUDMissile.animation.play("active");
				HUDOption.animation.play("idle");
			case 4:
				HUDSpeed.animation.play("idle");
				HUDShield.animation.play("idle");
				HUDMissile.animation.play("idle");
				HUDOption.animation.play("active");
			default:
				HUDSpeed.animation.play("idle");
				HUDShield.animation.play("idle");
				HUDMissile.animation.play("idle");
				HUDOption.animation.play("idle");
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
				enemyGroup.add(e);
				e.kill();
			case "enemy2":
				var e:Enemy2 = new Enemy2(x, y,null, bulletGroup);

				enemyGroup.add(e);
				e.kill();
			case "enemy3":
				var e:Enemy3 = new Enemy3(x, y, null, bulletGroup);
				enemyGroup.add(e);
				e.kill();
			case "enemy4":
				var e:Enemy4 = new Enemy4(x, y, null, bulletGroup);
				enemyGroup.add(e);
				e.kill();
			case "boss":
				bossito = new Boss(x, y, null, bulletGroup);
				bossito.kill();
		}
	}

	function RespawnEnemy():Void // respawnear y matar enemigos
	{
		for ( enemy in enemyGroup)
		{
			if ( (enemy.x <= (FlxG.camera.scroll.x + FlxG.camera.width + 10)) && enemy.alive == false)
				enemy.revive();
			if ((enemy.x >=  FlxG.camera.scroll.x + FlxG.camera.width + 30 || enemy.x <= FlxG.camera.scroll.x - 20) && enemy.alive)
			{
				enemyGroup.remove(enemy, true);
				contaUpgrade = 0;
			}
		}
	}

	function PlayerDeath():Void // player death
	{
		Reg.lives--;
		FlxG.resetState();
	}

	function GameOver():Void // Gameover?
	{
		if ( Reg.lives < 1)
			FlxG.resetGame();
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
		FlxG.collide(tilemap, p1, CollideTilePlayer); // colision en	tre tiles y player
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
		u.kill();
		if (Reg.countUpgrade < 5)
			Reg.countUpgrade = 4;
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
		if (contaUpgrade >= 3)
		{
			upgradecito.reset(e.x, e.y);
			contaUpgrade = 0;
		}
		else
			contaUpgrade++;

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

	function InitHUD():Void
	{
		HUDlives = new FlxSprite(0, 0, AssetPaths.lives__png);
		HUDlives.scrollFactor.set(0, 0);
		add(HUDlives);

		HUDlivesText = new FlxText(33, 0, 0, "x " + Reg.lives, 16);
		HUDlivesText.scrollFactor.set(0, 0);
		add(HUDlivesText);

		HUDSpeed = new FlxSprite(28, 224);
		HUDSpeed.loadGraphic(AssetPaths.HUDspeed__png, true, 50, 16);
		HUDSpeed.animation.add("idle", [1], 1, true);
		HUDSpeed.animation.add("active", [2], 1, true);
		HUDSpeed.scrollFactor.set(0, 0);

		HUDShield = new FlxSprite(78, 224);
		HUDShield.loadGraphic(AssetPaths.HUDshield__png, true, 50, 16);
		HUDShield.animation.add("idle", [1], 1, true);
		HUDShield.animation.add("active", [2], 1, true);
		HUDShield.scrollFactor.set(0, 0);

		HUDMissile = new FlxSprite(128, 224);
		HUDMissile.loadGraphic(AssetPaths.HUDmissile__png, true, 50, 16);
		HUDMissile.animation.add("idle", [1], 1, true);
		HUDMissile.animation.add("active", [2], 1, true);
		HUDMissile.scrollFactor.set(0, 0);

		HUDOption = new FlxSprite(178, 224);
		HUDOption.loadGraphic(AssetPaths.HUDoption__png, true, 50, 16);
		HUDOption.animation.add("idle", [1], 1, true);
		HUDOption.animation.add("active", [2], 1, true);
		HUDOption.scrollFactor.set(0, 0);
	}

	function BossRespawn():Void
	{
		if (followPoint.x >= tilemap.width - 200 )
		{
			Reg.camVelocityX = 0;
			followPoint.velocity.x = Reg.camVelocityX;
			if (bossito.alive == false)
			{
				bossito.revive();
				bossHPBar = new FlxBar(FlxG.camera.scroll.x + 75,2, LEFT_TO_RIGHT, 150, 20, Reg, "bossHP", 0, 100);
				bossHPBar.createFilledBar(0xFF000000, 0xFFFF0000, true, 0xFF00FF00);
				add(bossHPBar);
			}
			if (Reg.bossHP == 0)
				bossHPBar.destroy();
		}
	}

	function LoadTilemap():Void
	{
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
	}
}