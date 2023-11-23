extends Resource

class_name ComboData
@export_category("Combo")
@export var timers=[]
@export var combos=[]
@export var animationname:String
@export var comboframestart:int
@export var returntodefault:bool
@export var timetoallowreturndefault:float

@export_category("Movement")
@export var movedirection:Vector2
@export var startmoveframe:float
@export var moveonce:bool
@export var facedirection:bool
@export var force:float
@export var freeze:bool

@export_category("Targeting")
@export var targetlocking:bool
@export var targetX:bool
@export var targetY:bool
@export var arc:bool

@export_category("Instantiation")
@export var instances: Array[InstanceData] 

@export var instantiateframe:int
@export var instantiatefinished:bool
