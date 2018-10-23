package level_editor;

import level_editor.DataManager.ToolConfig;
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
	
	public var currentLayer:LayerFileData;
	public var currentTool:ToolConfig;

	public function new(levelProjectData:LevelProjectData, levelFileData:LevelFileData, entityImages:Map<EntityProjectData, Bitmap>) {
		super();
		this.levelWidth = levelFileData.width*Global.GS;
		this.levelHeight = levelFileData.height * Global.GS;
		this.entityImages = entityImages;
		bg.draw(levelWidth, levelHeight, 0x181e32);
		grid.draw(levelWidth, levelHeight, Global.GS, 0x1f3c61, 0.5);
		this.addChild(bg);

		
		

		this.levelProjectData = levelProjectData;
		
		
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
					newLayer = new TileLayer(levelWidth, levelHeight, projectLayerData, fileLayerData, levelProjectData.tilesetPath);
			}
			this.addChild(newLayer);
			this.layers.push(newLayer);
		}

		this.addChild(grid);
	}
	
	public function setCurrentLayer(layer:LayerFileData) {
		this.currentLayer = layer;
	}
	public function setCurrentTool(tool:ToolConfig) {
		
	}

	
	
}