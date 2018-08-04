package;
import haxepunk.Signal.Signal0;

/**
 * ...
 * @author Taylor
 */


@:generic
class StateMachine<E:EnumValue> {

	public var stateMap:Map<E, State> = new Map();
	public var stateDataMap:Map<E, StateData> = new Map();
	public var currentState:E;
	private var currentStateObj:State;
	public var onChangeState:Signal0 = new Signal0();
	
	//The notation here is confusing, sorry
	//stateEnum is basically just an enum type
	//then we iterate thru all the possible values of stateEnum, mapping them to a new state
	//then the class using the fsm can bind the functions of the states to their own functions inside their class.
	public function new(stateEnum:Enum<E>) {
		for (val in stateEnum.createAll()) {
			stateMap.set(val, new State(val.getName()));
		}
	}
	
	public function bind(state:E, onEnter:Void->Void, onUpdate:Void->Void, onExit:Void->Void) {
		var state = stateMap.get(state);
		state.onEnter = onEnter;
		state.onUpdate = onUpdate;
		state.onExit = onExit;
	}
	
	public function changeState(state:E) {
		
		if (this.currentStateObj != null && this.currentStateObj.onExit != null) {
			this.currentStateObj.onExit();
		}
		this.currentStateObj = this.stateMap.get(state);
		if (this.currentStateObj.onEnter != null) {
			this.currentStateObj.onEnter();
		}
		this.currentState = state;
		this.onChangeState.invoke();
	}
	public function update() {
		if (this.currentStateObj != null && this.currentStateObj.onUpdate != null) {
			this.currentStateObj.onUpdate();
		}
	}
	
}
class State {
	public var onEnter:Void->Void;
	public var onUpdate:Void->Void;
	public var onExit:Void->Void;
	public var name:String;
	
	public function new(name:String) {
		this.name = name;
	}
}

typedef StateData = {
	test:Float
}