@tool
extends Node3D

@export var XY2:Sprite3D
@export var XY3:Sprite3D
@export var XY4:Sprite3D
@export var XY5:Sprite3D
@export var Linefull:Texture
@export var Linefull2:Texture

@export var Full:Texture
@export var HStriaght:Texture
@export var VStriaght:Texture
@export var SideOuter:Texture
@export var SideOuter2:Texture
@export var SideOuter3:Texture



func SetRightSide(hasright,isside,flip,fliptopbottom):
	
	
	if not flip:
		XY2.flip_v=false
		XY4.visible=true
		if not isside:
			if hasright:
				
				XY2.texture=Linefull2
				if(fliptopbottom):
					XY2.flip_v=true
					XY4.texture=SideOuter2
				else:
					XY4.texture=SideOuter3
					XY2.flip_v=false
				
			else:
				XY4.texture=SideOuter
				XY2.flip_v=true
				XY2.texture=VStriaght
		else:
			if hasright:
				XY4.visible=false
				XY2.texture=Full
				
			else:
				
				XY2.texture=VStriaght
				XY2.flip_v=true
	else:
		XY3.flip_h=false
		XY5.visible=true
		if not isside:

			if hasright:
				if(fliptopbottom):
					XY3.flip_v=true
					XY5.texture=SideOuter3

				else:
					XY3.flip_v=true
					XY5.texture=SideOuter2
				XY3.texture=Linefull
			else:

				XY5.texture=SideOuter
				XY3.texture=HStriaght
				XY3.flip_v=true
		else:
			if hasright:
				XY5.visible=false
				XY3.texture=Full
			else:
				
				XY3.texture=HStriaght
				XY3.flip_v=true
		
		


func SetLeftSide(hasleft,isside,flip,fliptopbottom):
	
	
	if not flip: 
		XY3.flip_v=false
		XY5.visible=true
		if not isside:
			if hasleft:
				if(fliptopbottom):
					XY3.flip_h=true
					XY5.texture=SideOuter3
				else:
				
					XY5.texture=SideOuter2
				XY3.texture=Linefull
			else:
				XY5.texture=SideOuter
				XY3.texture=HStriaght
				XY3.flip_v=true
		else:
			if hasleft:
				XY5.visible=false
				XY3.texture=Full
			else:
				
				XY3.texture=HStriaght
				XY3.flip_v=true
	else:
		XY2.flip_v=false
		XY4.visible=true
		if not isside:
			if hasleft:
				
				XY2.texture=Linefull2
				if(fliptopbottom):
					XY2.flip_v=true
					XY4.texture=SideOuter2
				else:
					XY4.texture=SideOuter3
					XY2.flip_v=false
				
			else:
				XY4.texture=SideOuter
				XY2.flip_v=true
				XY2.texture=VStriaght
		else:
			if hasleft:
				XY4.visible=false
				XY2.texture=Full
				
			else:
				
				XY2.texture=VStriaght
				XY2.flip_v=true
		
		
