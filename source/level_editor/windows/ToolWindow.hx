package source.level_editor.windows;

import flash.display.Sprite;
import level_editor.DataManager.ToolConfig;
import level_editor.layers.GridLayer;
import level_editor.stacks.GridStack;
import level_editor.ui_elements.Button;
import level_editor.ui_elements.IconButton;
import level_editor.windows.Window;
import msignal.Signal.Signal1;

/**
 * ...
 * @author ...
 */
class ToolWindow extends Window 
{

	public var onToolSelected:Signal1<ToolConfig> = new Signal1();
	private var grid:GridStack;
	private var tools:Array<ToolConfig>;
	private var btns:Array<Button> = [];
	public function new(tools:Array<ToolConfig>) 
	{
		this.tools = tools;
		super("Tools");
		
	}
	override public function setupContent() {
		for (tool in tools) {
			var btn:IconButton = new IconButton(tool.iconImgPath);
			this.btns.push(btn);
			btn.onClickedSignal.add(this.onButtonClicked);
		}
		this.grid = new GridStack(cast(this.btns), 2);
		
		this.content.addChild(this.grid);
	}
	
	public function onButtonClicked(btn:Button) {
		for (element in this.btns) {
			if (element != btn) {
				cast(element, IconButton).toggle(false);
			}
		}
		onToolSelected.dispatch(this.tools[this.btns.indexOf(btn)]);
	}
	
}