package level_editor.windows;
import flash.display.Bitmap;
import level_editor.DataManager.EntityProjectData;
import level_editor.stacks.ButtonStack;
import level_editor.ui_elements.Button;
import level_editor.ui_elements.TextButton;

/**
 * ...
 * @author Taylor
 */
class EntityWindow extends Window {

	private var entities:Array<EntityProjectData>;
	private var entityImages:Map<EntityProjectData, Bitmap>;
	public function new(entities:Array<EntityProjectData>, entityImages:Map<EntityProjectData, Bitmap>) {
		this.entities = entities;
		this.entityImages = entityImages;
		super("Entities");
		
		
	}
	override public function setupContent() {
		var buttons:Array<TextButton> = [];
		for (entity in entities) {
			trace(entity.imgPath);
			buttons.push(new TextButton(entity.name, this.entityImages.get(entity)));
		}
		var stack = new ButtonStack(buttons);
		this.content.addChild(stack);
	}
	
}