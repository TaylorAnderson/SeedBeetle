package level_editor;

import openfl.display.PixelSnapping;
import flash.display.Bitmap;
import openfl.Assets;
import haxepunk.HXP;
import haxepunk.graphics.Image;
import level_editor.DataManager.LayerType;
import level_editor.DataManager.LevelProjectData;
import flash.display.Sprite;
import level_editor.layers.Layer;
import level_editor.layers.GridLayer;
import level_editor.layers.EntityLayer;
import level_editor.layers.TileLayer;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import level_editor.DataManager.EntityProjectProp;
import level_editor.DataManager.EntityProjectData;
import level_editor.DataManager.EntityGraphicType;
import level_editor.DataManager.EntityPropType;
import level_editor.DataManager.LevelFileData;
import level_editor.DataManager.LayerFileData;
import level_editor.DataManager.LayerProjectData;
/**
 * ...
 * @author Taylor
 */
 



class Level extends Sprite {

	private var bg:RectGraphic = new RectGraphic();
	private var grid:Grid = new Grid();

	private var levelWidth:Int;
	private var levelHeight:Int;

	public var layers:Array<Layer> = [];
	public var entityImages:Map<EntityProjectData, Bitmap> = new Map();
	private var levelProjectData:LevelProjectData;

	public function new(levelProjectData:LevelProjectData, levelFileData:LevelFileData) {
		super();
		this.levelWidth = levelFileData.width*Global.GS;
		this.levelHeight = levelFileData.height*Global.GS;
		bg.draw(levelWidth, levelHeight, 0x181e32);
		grid.draw(levelWidth, levelHeight, Global.GS, 0x1f3c61, 0.5);
		this.addChild(bg);

		
		

		this.levelProjectData = levelProjectData;
		
		for (entity in levelProjectData.entities) {
			registerEntity(entity);
		}
		
		for (i in 0...levelProjectData.layers.length) {

			//TODO: these are currently parallel arrays, we should be finding a better way of retrieving data.
			var projectLayerData = this.levelProjectData.layers[i];
			var fileLayerData = levelFileData.layers[i];

			var newLayer:Layer = null;
			switch (fileLayerData.type) {
				case LayerType.GRID:
					newLayer = new GridLayer(fileLayerData);
				case LayerType.ENTITIES:
					newLayer = new EntityLayer(fileLayerData, levelProjectData.entities, this.entityImages);
				case LayerType.TILES:
					newLayer = new TileLayer(levelWidth, levelHeight, projectLayerData, fileLayerData, "graphics/tiles.png");
			}
			this.addChild(newLayer);
			this.layers.push(newLayer);
		}

		this.addChild(grid);
	}


	public function registerEntity(entityConfig:EntityProjectData) {
		var bmd:BitmapData = null;
		var bitmap:Bitmap = null;

		if (entityConfig.graphicType == EntityGraphicType.IMAGE) {
			bmd = Assets.getBitmapData(entityConfig.imgPath);
		}
		if (entityConfig.graphicType == EntityGraphicType.RECTANGLE) {
			bmd = new BitmapData(Std.int(entityConfig.width), Std.int(entityConfig.height), false, entityConfig.rectColor);
		}

		bitmap = new Bitmap(bmd, PixelSnapping.ALWAYS, false);
		if (entityConfig.tileImage) bitmap.scrollRect = new Rectangle(0,0,entityConfig.width, entityConfig.height);

		this.entityImages.set(entityConfig, bitmap);
	}

	
	
}