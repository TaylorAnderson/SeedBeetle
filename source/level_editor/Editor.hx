package level_editor;

import flash.display.Sprite;
import haxe.Json;
import level_editor.ui_elements.InputField;
import level_editor.windows.LayersWindow;
import level_editor.windows.Window;
import openfl.Assets;
import level_editor.DataManager.LevelProjectData;
import level_editor.DataManager.LayerType;
import level_editor.DataManager.EntityPropType;
import level_editor.DataManager.EntityGraphicType;

/**
 * ...
 * @author Taylor
 */
class Editor extends Sprite {

	private var dataManager:DataManager;
	public function new(levelPath:String) {
		super();

		this.scaleX = this.scaleY = 4;
		
		dataManager = new DataManager(Json.parse(Assets.getText(levelPath)));
		var levelData = dataManager.getData();


		var levelProjectData:LevelProjectData = {width: levelData.width, height:levelData.height, 
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
				width: 59,
				height: 38,
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
				width: 14,
				height: 14,
				graphicType: EntityGraphicType.IMAGE,
				tileImage: true,
				imgPath: "graphics/waterspout.png",
				values: [
					{name: "color", defaultValue: "0", type: EntityPropType.INT, min: "0", max: "1"}
				]
			}

		]
		}
		this.addChild(new Background());
		this.addChild(new Level(levelProjectData, levelData));


		this.addChild(new LayersWindow(levelData.layers));
		
	}
}