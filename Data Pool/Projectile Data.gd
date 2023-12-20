extends Resource

class_name Projectile_Data

@export_category("Movement")
@export var move_X:bool
@export var move_Y:bool
@export var movetowardmouse:bool
@export var onetimeaim:bool

@export_category("Projectile Damage Falloff")
@export var start_damage:float
@export var end_damage:float
@export var step_per_tick:float

@export_category("Auto Targeting")

@export var auto_target:bool
@export var specifictargetid:String

@export var auto_target_distance:float
@export var auto_target_when_near:bool
@export var Destroy_out_of_range:bool

@export var instant_rotation:bool
@export var rotation_speed:float

@export var targeting_timer:bool
@export var rotation_timer:bool
@export var targeting_angle:bool

@export_category("Accelaration")
#when autotarget
@export var A_Stop_acc_when_out_of_dist:bool
@export var A_Decellerate_when_out_of_dist:bool
@export var A_Dist:float

@export var Destroy_on_max_speed:float
@export var start_time_acc:float
@export var stop_time_acc:float
@export var min_max_acc:Vector2
@export var acc_step_per_frame:float

@export_category("Deaccelaration")
#when autotarget
@export var DeA_Stop_acc_when_out_of_dist:bool
@export var DeA_Decellerate_when_out_of_dist:bool
@export var DeA_Dist:float

@export var DeDestroy_on_min_speed:bool
@export var start_time_Deacc:float
@export var stop_time_Deacc:float
@export var min_max_Deacc:Vector2
@export var Deacc_step_per_frame:float

@export_category("Lifetime")
@export var lifetime_destroy:bool
@export var lifetime:float
@export var Destroy_on_hit:bool
@export var Destoy_out_of_bounds:bool =true

@export_category("Explode")
@export var AoEmin_max:float
@export var delay_explode:bool
@export var delay_explode_time:float
@export var pressure:float
@export var arming_time:float
@export var unarming_time:float
@export var increase_aoe_by_speed:bool
@export var AoEmin_max_speed:float
@export var AoE_speed_min_max_multiplier:float
@export var AoEmin_max_damage:float

@export_category("Laser")
@export var holdable:bool
@export var stop_unheld:bool
@export var hold_time_max:float
@export var Lstart_damage:float
@export var LEnd_damage:float
@export var LMiddle_damage:float
@export var Fade:bool
@export var Fade_time:float
@export var iswall:bool

@export_category("Bounce")

@export_category("Animation")
@export var animationdestroy:String
