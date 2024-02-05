@tool
extends Node3D

@export_group("Rendered Objects")
@export var Tileset:PackedScene
@export var TilesetSlope:PackedScene
@export var corner:Texture
@export var VerticalStraight:Texture
@export var HorizontalStraight:Texture
@export var Full:Texture
@export var DiagonalInner:Texture
@export var DiagonalOuter:Texture
@export var DiagonalConnected:Texture
@export var LineFull:Texture

@export_group("Testing XY")
@export var TopLeft=false
@export var Top=false
@export var TopRight=false
@export var Left=false
@export var Right=false
@export var BottomLeft=false
@export var Bottom=false
@export var BottomRight=false

@export_group("Testing Front")
@export var Front=false
@export var FrontTop=false
@export var FrontLeft=false
@export var FrontRight=false
@export var FrontBottom=false

@export var FrontTopRight=false
@export var FrontTopLeft=false
@export var FrontBottomRight=false
@export var FrontBottomLeft=false

@export_group("Testing Back")
@export var Back=false
@export var BackTop=false
@export var BackLeft=false
@export var BackRight=false
@export var BackBottom=false

@export var BackTopRight=false
@export var BackTopLeft=false
@export var BackBottomRight=false
@export var BackBottomLeft=false
@export_group("Testing Slope")
@export var TRS=Node3D 
@export var TLS=Node3D 
@export var BLS=Node3D 
@export var FLS=Node3D 
@export var FTS=Node3D 
@export var BTS=Node3D 

@export var TRS2=Node3D 
@export var TLS2=Node3D 
@export var BLS2=Node3D 
@export var FLS2=Node3D 
@export var FTS2=Node3D 
@export var BTS2=Node3D 


@export_group("Testing")
@export var process=false
@export var resetslope=false
@export var TR=Node3D 
@export var TL=Node3D 
@export var BR=Node3D 
@export var BL=Node3D 
@export var TR2=Node3D 
@export var TL2=Node3D 
@export var BR2=Node3D 
@export var BL2=Node3D 

var Frontslope=false
var LeftSlope=false
var RightSlope=false
var BackSlope=false

func _process(delta):
	if resetslope:
		TR.ResetVisibility()
		TL.ResetVisibility()
		BR.ResetVisibility()
		BL.ResetVisibility()
		TR2.ResetVisibility()
		TL2.ResetVisibility()
		BR2.ResetVisibility()
		BL2.ResetVisibility()

		
		resetslope=false
	if process:
		#var instance = Tileset.instantiate()
		
		if not Front or (Front and (FrontTopRight or FrontTopLeft)) :

			SetFrontTopRightorBottomLeft(TR,Right,Top,TopRight,"TopLeft","BottomRight",BottomLeft,"XY",true,false,Front)

			SetFrontTopLeftorBottomRight(TL,Left,Top,TopLeft,"BottomLeft","TopRight",BottomRight,"XY",true,false,Front)
			
			SetFrontTopLeftorBottomRight(BR,Right,Bottom,BottomRight,"BottomLeft","TopRight",TopLeft,"XY",true,false,Front)
			
			
			SetFrontTopRightorBottomLeft(BL,Left,Bottom,BottomLeft,"TopLeft","BottomRight",TopRight,"XY",true,false,Front)
	
		if not Bottom or (Bottom and (BackLeft or FrontLeft)):

			
			SetTopTopLeftorBottomRight(BR2,Right,Back,BackRight,"BackLeft","FrontRight",FrontLeft,"ZX",not (BackBottom or BottomRight),false,Bottom)
			SetSideTopRightorBottomLeft(BL2,Left,Back,BackLeft,"BackRight","FrontLeft",FrontRight,"ZY",not (BackBottom or BottomLeft),false,Bottom)
			
			SetSideTopRightorBottomLeft(BR,Right,Front,FrontRight,"FrontLeft","BackRight",BackLeft,"ZY",not (FrontBottom or BottomRight),false,Bottom)
			SetTopTopLeftorBottomRight(BL,Left,Front,FrontLeft,"FrontRight","BackLeft",BackRight,"ZX",not (FrontBottom or BottomLeft),false,Bottom)
			
		if not Top or (Top and (FrontLeft or BackLeft)):
			
			SetSideTopRightorBottomLeft(TR2,Right,Back,BackRight,"BackLeft","FrontRight",FrontLeft,"ZY",not (BackTop or TopRight),false,Top)
			SetTopTopLeftorBottomRight(TL2,Left,Back,BackLeft,"BackRight","FrontLeft",FrontRight,"ZX",not (BackTop or TopLeft ),false,Top)
			
			SetTopTopLeftorBottomRight(TR,Right,Front,FrontRight,"FrontLeft","BackRight",BackLeft,"ZX",not (FrontTop or TopRight ),false,Top)
			SetSideTopRightorBottomLeft(TL,Left,Front,FrontLeft,"FrontRight","BackLeft",BackRight,"ZY",not (FrontTop or TopLeft),false,Top)
			
		if not Right or (Right and (BackTopRight or FrontTopRight )):
			SetTopTopRightorBottomLeft(TR2,Back,Top,BackTop,"BackBottom","FrontTop",FrontBottom,"ZX",true,(Left),Right)
			SetSideTopLeftorBottomRight(BR2,Back,Bottom,BackBottom,"BackTop","FrontBottom",FrontTop,"ZY",true,(Left),Right)
			
			SetSideTopLeftorBottomRight(TR,Front,Top,FrontTop,"BackTop","FrontBottom",BackBottom,"ZY",true,(Left),Right)
			SetTopTopRightorBottomLeft(BR,Front,Bottom,FrontBottom,"BackBottom","FrontTop",BackTop,"ZX",true,(Left),Right)
			
		if not Left or (Left and (BackTopLeft or FrontTopLeft)):
			SetSideTopLeftorBottomRight(TL2,Back,Top,BackTop,"BackBottom","FrontTop",FrontBottom,"ZY",true, (Right),Left)
			SetTopTopRightorBottomLeft(BL2,Back,Bottom,BackBottom,"BackTop","FrontBottom",FrontTop,"ZX", true, (Right),Left)
			
			SetTopTopRightorBottomLeft(TL,Front,Top,FrontTop,"BackTop","FrontBottom",BackBottom,"ZX", true, (Right),Left)
			SetSideTopLeftorBottomRight(BL,Front,Bottom,FrontBottom,"BackBottom","FrontTop",BackTop,"ZY", true, (Right),Left)
		
		if not Back or (Back and (BackTopLeft or FrontTopLeft)):
			SetFrontTopLeftorBottomRight(TR2,Right,Top,TopRight,"TopLeft","BottomRight",BottomLeft,"XY",true,(Front),Back)

			SetFrontTopRightorBottomLeft(TL2,Left,Top,TopLeft,"BottomLeft","TopRight",BottomRight,"XY",true,(Front),Back)
			
			SetFrontTopRightorBottomLeft(BR2,Right,Bottom,BottomRight,"BottomLeft","TopRight",TopLeft,"XY",true,(Front),Back)
			
			
			SetFrontTopLeftorBottomRight(BL2,Left,Bottom,BottomLeft,"TopLeft","BottomRight",TopRight,"XY",true,(Front),Back)
		



		SlopeActive(TRS,TRS2,"TopRight",Top,Right,false,false,FrontTopRight,BackTopRight,Front,Back)
		SlopeActive(TLS,TLS2,"TopLeft",Top,Left,true,true,FrontTopLeft,BackTopLeft,Front,Back)
		SlopeActive(FLS,FLS2,"FrontLeft",Front,Left,false,false,FrontTopLeft,FrontBottomLeft,Top,Bottom)
		SlopeActive(BLS,BLS2,"BackLeft",Back,Left,true ,false,BackTopLeft,BackBottomLeft,Top,Bottom)
		SlopeActive(FTS,FTS2,"FrontTop",Top,Front,false,false,FrontTopLeft,FrontTopRight,Left,Right)
		SlopeActive(BTS,BTS2,"BackTop",Top,Back,false,true,BackTopRight,BackTopLeft,Right,Left)
		process=false
		

func SlopeActive(sprite,sprite2,booleanActivate,booleanSide1,booleanSide2,flip,flipbottom,S1,S2,A1,A2):

	if get(booleanActivate):
		if not booleanSide1:
			sprite.visible=true
		else:
			sprite.visible=false
		if not booleanSide2:
			sprite2.visible=true
		else:
			sprite2.visible=false
		

		sprite.SetRightSide(A2, S2,flip,false)
		sprite.SetLeftSide(A1, S1,flip,false)
		sprite2.SetRightSide(A2, S2,flip,true)
		sprite2.SetLeftSide(A1, S1,flip,true)
		
		
			
	else:
		sprite.visible=false
		sprite2.visible=false


func NotORIncludes(variable):
	if variable=="Front":
		if not(Front  or FrontTop  or FrontLeft or
		FrontRight  or FrontBottom ):
			return true
			
	elif variable=="Back":
		if not(Back  or BackTop  or BackLeft or
		BackRight  or BackBottom ):
			return true
	
	elif variable=="Top":
		if not(TopLeft or Top or TopRight  or FrontTop   or BackTop ):
			return true
	
	elif variable=="Bottom":
		if not (BottomLeft or Bottom or BottomRight  or FrontBottom   or BackBottom ):
			return true
	
	elif variable=="Right":
		if not (TopRight or Right or BottomRight  or 
		FrontRight   or BackRight ):
			return true
	
	elif variable=="Left":
		if not (TopLeft or Left or BottomLeft  or FrontLeft   or BackLeft ):
			return true
	
	else:
		return false
	pass

func IncludesSpecific(ListofAllows, needAllActive):
	#Check if something is off
	for items in ListofAllows:
		if get(items)==false:
			return true
			
	var allvalues=["TopLeft","Top", "Left", "Right", "BottomLeft", "Bottom",
	 "BottomRight", "Front", "FrontTopLeft", "FrontTop","FrontTopRight","FrontLeft"
	,"FrontRight","FrontBottomLeft","FrontBottom","FrontBottomRight","Back","BackTopLeft","BackTop"
	,"BackTopRight","BackLeft","BackBottomRight","BackBottomLeft","BackBottom"]
	var OtherList=[]
	#use all or use given list only

	for items in ListofAllows:
		if allvalues.has(items):
			var index = allvalues.find(items)
			allvalues.remove_at(index)
	OtherList=allvalues

	var itemcount = OtherList.size()-1
	var currentcount=0
	for items in OtherList:
		if not needAllActive:
			
			if get(items)==true:
				return true
		else:
			if currentcount<itemcount:
				if get(items)==true:
					currentcount+=1
			else:
				return true
	
	return false

func NotIncludesDiagonal():
	if not(TopLeft or TopRight or BottomLeft or BottomRight):
		return true
	return false
	
	
func SetFrontTopRightorBottomLeft(sprite,booleanSide,booleanUp,booleancorner,booleanNeighbor1, booleanneighbor2=false,booleanDiagonal=false,Slope="",enableCorner=true,OtherSides=false,Front=false):
	sprite.SetSlope(false,Slope)
	var facing2="Front"
	if sprite.name=="Faces" or  sprite.name=="Faces2" or  sprite.name=="Faces3" or  sprite.name=="Faces4":
		facing2="Back"
	if booleanSide and booleanUp:
		sprite.SetCubeFront(Full,false,false)
	else:

		if booleancorner and enableCorner:
			sprite.isalreadysloped=true
			sprite.CubeFront.visible=true
			if booleanUp and not booleanSide:
				sprite.SetCubeFront(DiagonalConnected,false,false)
			elif booleanSide and not booleanUp :
				sprite.SetCubeFront(DiagonalConnected,true,true)
			else:

				sprite.SetCubeFront(DiagonalInner,false,false)
		elif booleanSide and not booleanUp:
			sprite.SetCubeFront(VerticalStraight,false,false)
		elif booleanUp and not booleanSide:
			sprite.SetCubeFront(HorizontalStraight,false,true)
		elif enableCorner and ( get(booleanNeighbor1) or get(booleanneighbor2)) and not sprite.isalreadysloped and (not OtherSides or (OtherSides and (get(facing2+booleanNeighbor1)or get(facing2+booleanneighbor2)))):
			sprite.lockF=true
			sprite.SetSlope(true,Slope)
			var facing="Back"
			if sprite.name=="Faces" or  sprite.name=="Faces2" or  sprite.name=="Faces3" or  sprite.name=="Faces4":
				facing="Front"
			if Front and(get(facing+booleanNeighbor1)or get(facing+booleanneighbor2)) :
				sprite.SetSpriteSlope(Full,Slope)
				sprite.CubeFront.visible=false
			else:
				sprite.SetSpriteSlope(VerticalStraight,Slope)
				sprite.CubeFront.visible=true
			sprite.SetCubeFront(DiagonalOuter,false,true)

				
		else:
			if  booleanDiagonal or booleancorner:
				if sprite.lockS or sprite.lockT:
					sprite.SetAllSprite(corner,false,true)
				sprite.CubeFront.visible=true
				sprite.isalreadysloped=true
			sprite.SetCubeFront(corner,false,true)
	

			
func SetFrontTopLeftorBottomRight(sprite,booleanSide,booleanUp,booleancorner,booleanNeighbor1, booleanneighbor2,booleanDiagonal,Slope="",enableCorner=true,OtherSides=false,Front=false):
	sprite.SetSlope(false,Slope)
	var facing2="Front"
	if sprite.name=="Faces" or  sprite.name=="Faces2" or  sprite.name=="Faces3" or  sprite.name=="Faces4":
		facing2="Back"
	if booleanSide and booleanUp:
			sprite.SetCubeFront(Full,false,false)
	else:

		if booleancorner and enableCorner:
			sprite.isalreadysloped=true
			sprite.CubeFront.visible=true
			if booleanUp and not booleanSide:
				sprite.SetCubeFront(DiagonalConnected,true,true)
			elif booleanSide and not booleanUp :
				sprite.SetCubeFront(DiagonalConnected,false,false)
			else:

				sprite.SetCubeFront(DiagonalInner,false,false)
		elif booleanSide and not booleanUp:
			sprite.SetCubeFront(HorizontalStraight,false,true)
		elif booleanUp and not booleanSide:
			sprite.SetCubeFront(VerticalStraight,false,true)
		
		elif enableCorner and (get(booleanNeighbor1) or get(booleanneighbor2)) and not sprite.isalreadysloped and (not OtherSides or (OtherSides and (get(facing2+booleanNeighbor1)or get(facing2+booleanneighbor2)))):
			sprite.lockF=true
			sprite.SetSlope(true,Slope)
			
			var facing="Back"
			if sprite.name=="Faces" or  sprite.name=="Faces2" or  sprite.name=="Faces3" or  sprite.name=="Faces4":
				facing="Front"

			if (Front and (get(facing+booleanNeighbor1)or get(facing+booleanneighbor2))):

				sprite.SetSpriteSlope(Full,Slope)
				sprite.CubeFront.visible=false
			else:
				sprite.SetSpriteSlope(VerticalStraight,Slope)
			sprite.SetCubeFront(DiagonalOuter,false,true)
		
		else:
			
			
			if booleanDiagonal or booleancorner:
				if sprite.lockS or sprite.lockT:
					sprite.SetAllSprite(corner,false,true)
					sprite.CubeFront.visible=true
				sprite.CubeFront.visible=true
				sprite.isalreadysloped=true
			
			sprite.SetCubeFront(corner,false,true)
	

		
func SetSideTopRightorBottomLeft(sprite,booleanSide,booleanUp,booleancorner,booleanNeighbor1, booleanneighbor2,booleanDiagonal,Slope="",enableCorner=true,OtherSides=false,Front=false):
	sprite.SetSlope(false,Slope)
	var facing2="Right"

	if sprite.name=="Faces" or  sprite.name=="Faces4" or  sprite.name=="Faces32" or  sprite.name=="Faces42":
		facing2="Left"
	if booleanSide and booleanUp:
		sprite.SetCubeSide(Full,false,false)
	else:
		if booleancorner and enableCorner:
			sprite.isalreadysloped=true
			sprite.CubeSide.visible=true
			if booleanUp and not booleanSide:
				sprite.SetCubeSide(DiagonalConnected,false,false)
			elif booleanSide and not booleanUp :
				sprite.SetCubeSide(DiagonalConnected,true,true)
			else:

				sprite.SetCubeSide(DiagonalInner,false,false)
		elif booleanSide and not booleanUp:
			sprite.SetCubeSide(VerticalStraight,false,false)
		elif booleanUp and not booleanSide:
			sprite.SetCubeSide(HorizontalStraight,false,true)
		elif enableCorner and (get(booleanNeighbor1) or get(booleanneighbor2)) and not sprite.isalreadysloped and (not OtherSides or (OtherSides and (get(booleanNeighbor1)or get(booleanneighbor2)))):
			sprite.lockS=true
			sprite.SetSlope(true,Slope)
			var facing="Left"
			if sprite.name=="Faces" or  sprite.name=="Faces2" or  sprite.name=="Faces3" or  sprite.name=="Faces4":
				facing="Right"
			if Front and(get(booleanNeighbor1)or get(booleanneighbor2)):
				sprite.SetSpriteSlope(Full,Slope)
				sprite.CubeSide.visible=false
			else:
				sprite.SetSpriteSlope(VerticalStraight,Slope)
				sprite.CubeSide.visible=true
			sprite.SetCubeSide(DiagonalOuter,false,true)
	
		else:
			
			if booleanDiagonal or booleancorner:
				
				if sprite.lockT or sprite.lockF:
					sprite.SetAllSprite(corner,false,true)
				sprite.CubeSide.visible=true
				sprite.isalreadysloped=true
			
			sprite.SetCubeSide(corner,false,true)
	
	
			
func SetSideTopLeftorBottomRight(sprite,booleanSide,booleanUp,booleancorner,booleanNeighbor1, booleanneighbor2,booleanDiagonal,Slope="",enableCorner=true,OtherSides=false,Front=false):
	sprite.SetSlope(false,Slope)
	if booleanSide and booleanUp:
			sprite.SetCubeSide(Full,false,false)
	else:
		var facing2="Right"

		if sprite.name=="Faces" or  sprite.name=="Faces4" or  sprite.name=="Faces32" or  sprite.name=="Faces42":
			facing2="Left"
		if booleancorner:
			sprite.CubeSide.visible=true
			sprite.isalreadysloped=true
			if booleanUp and not booleanSide:
				sprite.SetCubeSide(DiagonalConnected,true,true)
			elif booleanSide and not booleanUp :
				sprite.SetCubeSide(DiagonalConnected,false,false)
			else:

				sprite.SetCubeSide(DiagonalInner,false,false)
		elif booleanSide and not booleanUp:
			sprite.SetCubeSide(HorizontalStraight,false,true)
		elif booleanUp and not booleanSide:
			sprite.SetCubeSide(VerticalStraight,false,true)
		
		elif enableCorner and (get(booleanNeighbor1) or get(booleanneighbor2)) and not sprite.isalreadysloped and (not OtherSides or (OtherSides and (get(booleanNeighbor1+facing2)or get(booleanneighbor2+facing2)))):
			sprite.lockS=true
			sprite.SetSlope(true,Slope)
			var facing="Left"
			
			if sprite.name=="Faces" or  sprite.name=="Faces4" or  sprite.name=="Faces32" or  sprite.name=="Faces42":
				facing="Right"
			if Front and(get(booleanNeighbor1+facing)or get(booleanneighbor2+facing)):
				sprite.SetSpriteSlope(Full,Slope)
				sprite.CubeSide.visible=false
			else:
				sprite.SetSpriteSlope(VerticalStraight,Slope)
				sprite.CubeSide.visible=true
			sprite.SetCubeSide(DiagonalOuter,false,true)
		else:
			
			if booleanDiagonal or booleancorner:
				if sprite.lockT or sprite.lockF:
					sprite.SetAllSprite(corner,false,true)
				sprite.CubeSide.visible=true
				sprite.isalreadysloped=true
			sprite.SetCubeSide(corner,false,true)

		
func SetTopTopRightorBottomLeft(sprite,booleanSide,booleanUp,booleancorner,booleanNeighbor1, booleanneighbor2,booleanDiagonal,Slope="",enableCorner=true,OtherSides=false,Front=false):
	sprite.SetSlope(false,Slope)
	var facing2="Right"
	if sprite.name=="Faces" or  sprite.name=="Faces4" or  sprite.name=="Faces32" or  sprite.name=="Faces42":
		facing2="Left"
	if booleanSide and booleanUp:
		sprite.SetCubeTop(Full,false,false)
	else:

		if booleancorner and enableCorner:
			sprite.isalreadysloped=true
			sprite.CubeTop.visible=true
			if booleanUp and not booleanSide:
				sprite.SetCubeTop(DiagonalConnected,false,false)
			elif booleanSide and not booleanUp :
				sprite.SetCubeTop(DiagonalConnected,true,true)
			else:

				sprite.SetCubeTop(DiagonalInner,false,false)
		elif booleanSide and not booleanUp:
			sprite.SetCubeTop(VerticalStraight,false,false)
		elif booleanUp and not booleanSide:
			sprite.SetCubeTop(HorizontalStraight,false,true)
		elif enableCorner and (get(booleanNeighbor1) or get(booleanneighbor2)) and not sprite.isalreadysloped and ((not OtherSides )or ( OtherSides and (get(booleanNeighbor1)or get(booleanneighbor2)))):
			
			sprite.lockT=true
			sprite.SetSlope(true,Slope)
			var facing="Left"
			if sprite.name=="Faces" or  sprite.name=="Faces4" or  sprite.name=="Faces32" or  sprite.name=="Faces42":
				facing="Right"
			if Front and(get(booleanNeighbor1)or get(booleanneighbor2)):
				sprite.SetSpriteSlope(Full,Slope)
				sprite.CubeTop.visible=false
			else:
				sprite.SetSpriteSlope(VerticalStraight,Slope)
				sprite.CubeTop.visible=true
			sprite.SetCubeTop(DiagonalOuter,false,true)
		
				
		else:
			
			if booleanDiagonal or booleancorner:
				if sprite.lockS or sprite.lockF:
					sprite.SetAllSprite(corner,false,true)
				sprite.CubeTop.visible=true
				sprite.isalreadysloped=true
			sprite.SetCubeTop(corner,false,true)
	
			
func SetTopTopLeftorBottomRight(sprite,booleanSide,booleanUp,booleancorner,booleanNeighbor1, booleanneighbor2,booleanDiagonal,Slope="",enableCorner=true,OtherSides=false,Front=false):
	sprite.SetSlope(false,Slope)
	var facing2="Right"
	if sprite.name=="Faces" or  sprite.name=="Faces4" or  sprite.name=="Faces32" or  sprite.name=="Faces42":
		facing2="Left"
	if booleanSide and booleanUp:
			sprite.SetCubeTop(Full,false,false)
	else:

		if booleancorner and enableCorner:
			sprite.isalreadysloped=true
			sprite.CubeTop.visible=true
			if booleanUp and not booleanSide:
				sprite.SetCubeTop(DiagonalConnected,true,true)
			elif booleanSide and not booleanUp :
				sprite.SetCubeTop(DiagonalConnected,false,false)
			else:

				sprite.SetCubeTop(DiagonalInner,false,false)
		elif booleanSide and not booleanUp:
			sprite.SetCubeTop(HorizontalStraight,false,true)
		elif booleanUp and not booleanSide:
			sprite.SetCubeTop(VerticalStraight,false,true)
		
		elif enableCorner and (get(booleanNeighbor1) or get(booleanneighbor2)) and not sprite.isalreadysloped and ((not OtherSides )or ( OtherSides and (get(booleanNeighbor1)or get(booleanneighbor2)))):
			sprite.lockT=true
			sprite.SetSlope(true,Slope)
			var facing="Left"
			if sprite.name=="Faces" or  sprite.name=="Faces4" or  sprite.name=="Faces32" or  sprite.name=="Faces42":
				facing="Right"
			if Front and(get(booleanNeighbor1)or get(booleanneighbor2)):
				sprite.SetSpriteSlope(Full,Slope)
				sprite.CubeTop.visible=false
			else:
				sprite.SetSpriteSlope(VerticalStraight,Slope)
				sprite.CubeTop.visible=true
			sprite.SetCubeTop(DiagonalOuter,false,true)
	
		else:
			
			if booleanDiagonal or booleancorner:
				if sprite.lockS or sprite.lockF:
					sprite.SetAllSprite(corner,false,true)
				sprite.CubeTop.visible=true
				sprite.isalreadysloped=true
			sprite.SetCubeTop(corner,false,true)
	
	
			
		
