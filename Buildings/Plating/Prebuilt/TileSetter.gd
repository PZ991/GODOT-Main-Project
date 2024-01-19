@tool
extends Node3D

class_name TileSetter
@onready var st = $"Front Slope/ST"


@export var Cube=StaticBody3D
@export var CubeFront=Sprite3D
@export var CubeTop=Sprite3D
@export var CubeSide=Sprite3D

@export var Slope=StaticBody3D
@export var SlopeFront=Sprite3D
@export var SlopeTop=Sprite3D

func _process(delta):
	st.flip_v

func SetCubeFront(sprite,Hflip,Vflip):
	CubeFront.texture=sprite
	CubeFront.flip_h=Hflip
	CubeFront.flip_v=Vflip

func SetCubeTop(sprite,Hflip,Vflip):
	CubeTop.texture=sprite
	CubeTop.flip_h=Hflip
	CubeTop.flip_v=Vflip

func SetCubeSide(sprite,Hflip,Vflip):
	CubeSide.texture=sprite
	CubeSide.flip_h=Hflip
	CubeSide.flip_v=Vflip

func SetSlopeFront(sprite,Hflip,Vflip):
	SlopeFront.texture=sprite
	SlopeFront.flip_h=Hflip
	SlopeFront.flip_v=Vflip

func SetSlopeTop(sprite,Hflip,Vflip): 
	SlopeTop.texture=sprite
	SlopeTop.flip_h=Hflip
	SlopeTop.flip_v=Vflip


func Set_Scale(scale):
	scale=scale
	
func RotateCubeoffset(pos):
	
	Cube.global_position=pos
	
func RotateCube(rotation):
	Cube.rotation_degrees=rotation
	
func RotateSlopeoffset(pos):
	
	Slope.global_position=pos
	
func RotateSlope(rotation):
	Slope.rotation_degrees=rotation
	
