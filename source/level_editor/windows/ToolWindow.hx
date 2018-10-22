package source.level_editor.windows;

import level_editor.stacks.GridStack;
import level_editor.windows.Window;

/**
 * ...
 * @author ...
 */
class ToolWindow extends Window 
{

	private var grid:GridStack = new GridStack();
	public function new(caption:String) 
	{
		super(caption);
		
	}
	
}