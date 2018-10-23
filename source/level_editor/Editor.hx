package level_editor;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.Json;
import haxepunk.HXP;
import level_editor.DataManager.EntityProjectData;
import level_editor.DataManager.LayerFileData;
import level_editor.DataManager.ToolConfig;
import level_editor.ui_elements.InputField;
import level_editor.windows.EntityWindow;
import level_editor.windows.LayersWindow;
import level_editor.windows.TilemapWindow;
import level_editor.windows.Window;
import openfl.Assets;
import level_editor.DataManager.LevelProjectData;
import level_editor.DataManager.LayerType;
import level_editor.DataManager.EntityPropType;
import level_editor.DataManager.EntityGraphicType;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
import source.level_editor.windows.ToolWindow;

/**
 * ...
 * @author Taylor
 */
class Editor extends Sprite {

	private var dataManager:DataManager;
	private var tools:Map<String, Array<ToolConfig>> = new Map();

	private var currentToolsWindow:ToolWindow;
	
	private var levelProjectData:LevelProjectData;
	private var entityImages:Map<EntityProjectData, Bitmap> = new Map();
	public function new(levelPath:String) {
		super();

		this.scaleX = this.scaleY = 4;
		
		dataManager = new DataManager(Json.parse(Assets.getText(levelPath)));
		var levelData = dataManager.getData();

		//{region data setup
		tools.set(LayerType.TILES, [
			{name: "Pencil", iconImgPath: "graphics/pencil-tool-icon.png"},
			{name: "Flood Fill", iconImgPath: "graphics/flood-fill-icon.png"},
			{name: "Rectangle", iconImgPath: "graphics/rect-icon.png"},
			{name: "Line", iconImgPath: "graphics/line-tool-icon.png"},
			{name: "Select", iconImgPath: "graphics/select-tool-icon.png"},
			{name: "Move", iconImgPath: "graphics/move-tool-icon.png"},
		]);

		tools.set(LayerType.ENTITIES, [
			{name: "Pencil", iconImgPath: "graphics/pencil-tool-icon.png"},
			{name: "Eraser", iconImgPath: "graphics/eraser-tool-icon.png"},
			{name: "Select", iconImgPath: "graphics/select-tool-icon.png"},
			{name: "Move", iconImgPath: "graphics/move-tool-icon.png"},
			{name: "Resize", iconImgPath: "graphics/resize-tool-icon.png"},
		]);

		tools.set(LayerType.GRID, [
			{name: "Pencil", iconImgPath: "graphics/pencil-tool-icon.png"},
			{name: "Flood Fill", iconImgPath: "graphics/flood-fill-icon.png"},
			{name: "Rectangle", iconImgPath: "graphics/rect-icon.png"},
			{name: "Line", iconImgPath: "graphics/line-tool-icon.png"},
			{name: "Select", iconImgPath: "graphics/select-tool-icon.png"},
			{name: "Move", iconImgPath: "graphics/move-tool-icon.png"},
		]);

		this.levelProjectData = {width: levelData.width, height:levelData.height, 
		tilesetPath: "graphics/tiles.png",
		layers: [
			{name: "Grid", type: LayerType.GRID, gridSize: Global.GS},
			{name: "BGTiles", type: LayerType.TILES, gridSize: Global.GS},
			{name: "Entities", type: LayerType.ENTITIES, gridSize: 4},
			{name: "Scenery", type: LayerType.TILES, gridSize: Global.GS},	
		],
		entities: [
			{
				name: "Player",
				width: 16,
				height:16,
				graphicType: EntityGraphicType.IMAGE,
				imgPath: "graphics/player.png",
				tileImage: true,
			},
			{
				name: "Seed",
				width: 18,
				height: 16,
				graphicType: EntityGraphicType.IMAGE,
				tileImage: true,
				imgPath: "graphics/seed.png",
				values: [
					{name: "seedType", defaultValue: "0", type: EntityPropType.INT, min: "0", max: "2"},
					{name: "color", defaultValue: "0", type: EntityPropType.INT, min: "0", max: "1"},
				]
			},
			{
				name: "Waterfall",
				width: 40,
				height: 16,
				graphicType: EntityGraphicType.IMAGE,
				imgPath: "graphics/water-spout.png"
			},
			{
				name: "Pool",
				width: 16,
				height: 8,
				graphicType: EntityGraphicType.RECTANGLE,
				resizableX: true,
				resizableY: true,
			},
			{
				name: "BigBug",
				width: 49,
				height: 36,
				graphicType: EntityGraphicType.IMAGE,
				imgPath: "graphics/big-bug.png"
			},
			{
				name: "Flag",
				width: 16,
				height: 16,
				graphicType: EntityGraphicType.IMAGE,
				tileImage: true,
				imgPath: "graphics/flag.png"
			},
			{
				name: "GateVert",
				width: 8,
				height: 8,
				graphicType: EntityGraphicType.IMAGE,
				tileImage: true,
				imgPath: "graphics/gatevert.png",
				values: [
					{name: "color", defaultValue: "0", type: EntityPropType.INT, min: "0", max: "1"}
				]
			},
			{
				name: "GateHoriz",
				width: 8,
				height: 8,
				graphicType: EntityGraphicType.IMAGE,
				tileImage: true,
				imgPath: "graphics/gatehoriz.png",
				values: [
					{name: "color", defaultValue: "0", type: EntityPropType.INT, min: "0", max: "1"}
				]
			},
			{
				name: "WaterSpout",
				width: 12,
				height: 12,
				graphicType: EntityGraphicType.IMAGE,
				tileImage: true,
				imgPath: "graphics/waterspout.png",
				values: [
					{name: "color", defaultValue: "0", type: EntityPropType.INT, min: "0", max: "1"}
				]
			}

		]
		}
		
		for (entity in levelProjectData.entities) {
			var bmd:BitmapData = null;
			var bitmap:Bitmap = null;

			if (entity.graphicType == EntityGraphicType.IMAGE) {
				bmd = new BitmapData(Std.int(entity.width), Std.int(entity.height));
				var imgBmd = Assets.getBitmapData(entity.imgPath);
				bmd.copyPixels(imgBmd, new Rectangle(0, 0, entity.width, entity.height), new Point(0,0));
			}
			if (entity.graphicType == EntityGraphicType.RECTANGLE) {
				bmd = new BitmapData(Std.int(entity.width), Std.int(entity.height), false, entity.rectColor);
			}

			bitmap = new Bitmap(bmd, PixelSnapping.ALWAYS, false);
			//if (entity.tileImage) bitmap.scrollRect = new Rectangle(0,0,entity.width, entity.height);

			this.entityImages.set(entity, bitmap);
		}
		//}endregion
		
		
		
		this.addChild(new Background());
		this.addChild(new Level(levelProjectData, levelData, entityImages));


		var layersWindow = new LayersWindow(levelData.layers);
		layersWindow.onLayerChangedSignal.add(this.onLayerChanged);
		this.addChild(layersWindow);
		
	}
	private function onLayerChanged(layer:LayerFileData) {
		if (this.currentToolsWindow != null) this.removeChild(this.currentToolsWindow);
		
		this.currentToolsWindow = new ToolWindow(this.tools.get(layer.type));
		
		this.currentToolsWindow.x = HXP.width - this.currentToolsWindow.width - 20;
		this.currentToolsWindow.y = HXP.height / 2 - this.currentToolsWindow.height / 2;
		this.addChild(this.currentToolsWindow);
		
		if (layer.type == LayerType.ENTITIES) {
			var eWindow = new EntityWindow(this.levelProjectData.entities, entityImages);
			this.addChild(eWindow);
			eWindow.x = 10;
			eWindow.y = HXP.height - eWindow.height - 30;
		}
		
		if (layer.type = LayerType.TILES) {
			var tWindow = new TilemapWindow(
		}
	}
}