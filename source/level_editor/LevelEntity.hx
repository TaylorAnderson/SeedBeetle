package level_editor;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import level_editor.DataManager.EntityProjectData;
import level_editor.DataManager.EntityFileData;
class LevelEntity extends Sprite {
    public var levelData:EntityFileData;
    public var projectData:EntityProjectData;
    private var bitmap:Bitmap; 
    public function new(levelData:EntityFileData, projectData:EntityProjectData, bitmap:Bitmap) {
        super();
        this.bitmap = bitmap;
        this.levelData = levelData;
        this.projectData = projectData;

        this.addChild(this.bitmap);

        this.x = this.levelData.x;
        this.y = this.levelData.y;
        
    }
}