@tool
extends Node3D

class_name TileSetter


@export var Cube=StaticBody3D
@export var CubeFront=Sprite3D
@export var CubeTop=Sprite3D
@export var CubeSide=Sprite3D


@export var XY=Sprite3D
@export var YX=Sprite3D
@export var YZ=Sprite3D
@export var ZY=Sprite3D
@export var ZX=Sprite3D
@export var XZ=Sprite3D


@export var isalreadysloped=false
@export var lockS=false
@export var lockF=false
@export var lockT=false



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
	

func SetSlope(isslope,stringactivation=""):
	if isslope:

		match stringactivation:
			"XY":SetVisibility(XY,true,false,false,true)
			"YX":YX.visible=true
			"YZ":YZ.visible=true
			"ZY":SetVisibility(ZY,true,false,true,false)
			"ZX":SetVisibility(ZX,true,true,false,false)
			"XZ":XZ.visible=true
			"":return
	
func SetSpriteSlope(Sprite,stringactivation=""):
	
	match stringactivation:
		"XY":XY.texture=Sprite
		"YX":YX.texture=Sprite
		"YZ":YZ.texture=Sprite
		"ZY":ZY.texture=Sprite
		"ZX":ZX.texture=Sprite
		"XZ":XZ.texture=Sprite
		"":return
		

func SetAllSprite(sprite,Hflip,Vflip):
	CubeSide.texture=sprite
	CubeSide.flip_h=Hflip
	CubeSide.flip_v=Vflip
	CubeTop.texture=sprite
	CubeTop.flip_h=Hflip
	CubeTop.flip_v=Vflip
	CubeFront.texture=sprite
	CubeFront.flip_h=Hflip
	CubeFront.flip_v=Vflip
	CubeTop.visible=true
	CubeSide.visible=true
	CubeFront.visible=true

func ResetVisibility():
	XY.visible=false
	YX.visible=false
	YZ.visible=false
	ZY.visible=false
	ZX.visible=false
	XZ.visible=false
	CubeTop.visible=true
	CubeSide.visible=true
	CubeFront.visible=true
	isalreadysloped=false
	lockF=false
	lockS=false
	lockT=false
	

func RemoveSlope():
	XY.visible=false
	YX.visible=false
	YZ.visible=false
	ZY.visible=false
	ZX.visible=false
	XZ.visible=false
	CubeTop.visible=true
	CubeSide.visible=true
	CubeFront.visible=true
	
func SetVisibility(sprite,boolean,top,side,front):
	sprite.visible=boolean
	if not isalreadysloped:
		CubeTop.visible=top

		CubeSide.visible=side

		CubeFront.visible=front
	else:
		CubeTop.visible=true
		CubeSide.visible=true
		CubeFront.visible=true

	if lockF:
		CubeFront.visible=true
	if lockS:
		CubeSide.visible=true
	if lockT:
		CubeTop.visible=true
	


func SetSlopeTop(sprite,Hflip,Vflip): 
	XY.texture=sprite
	XY.flip_h=Hflip
	XY.flip_v=Vflip


func Set_Scale(scale):
	scale=scale
	
func RotateCubeoffset(pos):
	
	Cube.global_position=pos
	
func RotateCube(rotation):
	Cube.rotation_degrees=rotation
	

	
