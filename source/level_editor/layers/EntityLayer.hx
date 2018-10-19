package level_editor.layers;

import level_editor.DataManager.EntityProjectData;
import flash.display.Bitmap;
import level_editor.DataManager.LayerProjectData;
import level_editor.LevelEntity;
import level_editor.DataManager.LayerFileData;
/**
 * ...
 * @author Taylor
 */
class EntityLayer extends Layer {

	public function new(layerData:LayerFileData, entityData:Array<EntityProjectData>, entityPacks:Map<EntityProjectData, Bitmap>) {
		super();
		for (entity in layerData.entityArray) {
			
			//TODO: make this less narsty, maybe with a map or something.  not sure how to structure this right now.
			var projData:EntityProjectData = null;
			for (projectEntity in entityData) {
				if (projectEntity.name == entity.name) {
					projData = projectEntity;
				}
			}


			this.addChild(new LevelEntity(entity, projData, entityPacks.get(projData)));
		}
	}
	
}