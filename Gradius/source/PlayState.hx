package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
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
		add(tilemap);
		add(enemyGroup);
	}
	
	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		
		FlxG.collide(tilemap, p1, CollideTilePlayer);
		FlxG.collide(tilemap, p1.bulletGroup, CollideTileBullet);
		FlxG.collide(p1.bulletGroup, enemyGroup, CollideBulletAndEnemy);
		FlxG.collide(enemyGroup, p1, CollidePlayerEnemy);
	}
	
	
	
	private function placeEntities(entityName:String, entityData:Xml):Void
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
				//e.kill();
			case "enemy2":
				var e:Enemy2 = new Enemy2(x, y);
				e.makeGraphic(16, 16, 0xFFFF00FF);
				enemyGroup.add(e);
				//e.kill();
			case "enemy3":
				var e:Enemy3 = new Enemy3(x, y);
				e.makeGraphic(16, 16, 0xFF00FFFF);
				enemyGroup.add(e);
				//e.kill();
		}
	}
	
	function CollideTileBullet(t:FlxTilemap,b:BulletPlayer) 
	{
		p1.bulletGroup.remove(b, true);
	}
	
	function CollideTilePlayer(t:FlxTilemap,p1:Player):Void
	{
		p1.destroy();	
	}
	
	function CollidePlayerEnemy(e:Enemy,p:Player):Void 
	{
		e.revive();
		p.destroy();
	}
	
	function CollideBulletAndEnemy(b:BulletPlayer,e:Enemy) 
	{
		p1.bulletGroup.remove(b,true);
		enemyGroup.remove(e);
	}
}