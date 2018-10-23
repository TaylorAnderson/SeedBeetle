package level_editor.windows;
import flash.display.Bitmap;
import level_editor.DataManager.LayerFileData;
import level_editor.DataManager.LayerType;
import level_editor.stacks.ButtonStack;
import level_editor.ui_elements.Button;
import level_editor.ui_elements.TextButton;
import level_editor.ui_elements.Toggle;
import msignal.Signal.Signal1;
import openfl.Assets;

/**
 * ...
 * @author Taylor
 */

class Layers {
	public static inline var SCENERY = "Scenery";
	public static inline var ENTITIES = "Entities";
	public static inline var BG = "BGTiles";
	public static inline var GRID = "Grid";
}
class LayersWindow extends Window {

	public var onLayerChangedSignal:Signal1<LayerFileData> = new Signal1();

	private var layerBtns:Array<TextButton> = [];

	private var layerData:Array<LayerFileData>;
	private var layerButtonData:Map<Button, LayerFileData> = new Map();
	private var layerImgData:Map<String, String> = new Map();
	public function new(layers:Array<LayerFileData>) {
		this.layerData = layers;
		this.layerImgData.set(LayerType.TILES, "graphics/tiles-icon.png");
		this.layerImgData.set(LayerType.GRID, "graphics/grid-icon.png");
		this.layerImgData.set(LayerType.ENTITIES, "graphics/entity-icon.png");
		super("Layers");
		
	}
	
	override public function setupContent() {
		
		for (layer in this.layerData) {
			var txtBtn = new TextButton(layer.name, new Bitmap(Assets.getBitmapData(this.layerImgData.get(layer.type))));
			this.layerBtns.push(txtBtn);
			this.layerButtonData.set(txtBtn, layer);
		}
		var btnStack = (new ButtonStack(this.layerBtns));
		
		for (btn in this.layerBtns) {
			cast(btn, Button).onClickedSignal.add(this.onBtnClicked);
			var toggle = new Toggle();
			toggle.x = btn.x + btn.width + 4;
			toggle.y = btn.y + btn.height / 2 - toggle.height / 2;
			content.addChild(toggle);
		}
		
		this.content.addChild(btnStack);
	}
	private function onBtnClicked(btn:Button) {
		var txtBtn = cast(btn, TextButton);
		this.onLayerChangedSignal.dispatch(this.layerButtonData.get(txtBtn));
	}
	
}