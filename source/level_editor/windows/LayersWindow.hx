package level_editor.windows;
import level_editor.DataManager.LayerFileData;
import level_editor.stacks.ButtonStack;
import level_editor.ui_elements.Button;
import level_editor.ui_elements.TextButton;
import level_editor.ui_elements.Toggle;
import msignal.Signal.Signal1;

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

	public var onLayerChangedSignal:Signal1<String> = new Signal1(String);

	private var layerBtns:Array<TextButton> = [];

	private var layerData:Array<LayerFileData>;
	public function new(layers:Array<LayerFileData>) {
		this.layerData = layers;
		super("Layers");
		
	}
	
	override public function setupContent() {
		
		for (layer in this.layerData) {
			var txtBtn = new TextButton(layer.name);
			this.layerBtns.push(txtBtn);
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
		this.onLayerChangedSignal.dispatch(txtBtn.text);
	}
	
}