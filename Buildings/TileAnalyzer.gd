@tool
extends Node3D


class_name TileAnalyzer
@export var points:Array[Node3D]

@export_group("Diagonal_Connected_Inner")
@export var diagonal_connected_inner: Texture
@export var record_diagonal_connected_inner=false
@export var diagonal_connected_inner_datapoints=[]

@export_group("Diagonal_Inner")
@export var diagonal_inner: Texture
@export var record_diagonal_inner=false
@export var diagonal_inner_datapoints=[]

@export_group("Diagonal_Outer")
@export var diagonal_outer: Texture
@export var record_diagonal_outer=false
@export var diagonal_outer_datapoints=[]

@export_group("Full")
@export var full: Texture
@export var record_full=false
@export var full_datapoints=[]

@export_group("Straight")
@export var straight: Texture
@export var record_straight=false
@export var straight_datapoints=[]

@export_group("StraightV2")
@export var straightV2: Texture
@export var record_straightV2=false
@export var straightV2_datapoints=[]

@export_group("Corner")
@export var corner: Texture
@export var record_corner=false
@export var corner_datapoints=[]


@export_group("Sprite Front Handlers")
@export var FrontBottomLeftCorner:Sprite3D
@export var FrontBottomRightCorner:Sprite3D
@export var FrontTopLeftCorner:Sprite3D
@export var FrontTopRightCorner:Sprite3D

@export_group("Sprite Right Handlers")
@export var RightBottomLeftCorner:Sprite3D
@export var RightBottomRightCorner:Sprite3D
@export var RightTopLeftCorner:Sprite3D
@export var RightTopRightCorner:Sprite3D

@export_group("Sprite Left Handlers")
@export var LeftBottomLeftCorner:Sprite3D
@export var LeftBottomRightCorner:Sprite3D
@export var LeftTopLeftCorner:Sprite3D
@export var LeftTopRightCorner:Sprite3D

@export_group("Sprite Back Handlers")
@export var BackBottomLeftCorner:Sprite3D
@export var BackBottomRightCorner:Sprite3D
@export var BackTopLeftCorner:Sprite3D
@export var BackTopRightCorner:Sprite3D

@export_group("Sprite Top Slope Handlers")
@export var TopBackLeftSlope:Sprite3D
@export var TopBackRightSlope:Sprite3D
@export var TopFrontRightSlope:Sprite3D
@export var TopFrontLeftSlope:Sprite3D

@export_group("Sprite Bottom Slope Handlers")
@export var BottomBackLeftSlope:Sprite3D
@export var BottomBackRightSlope:Sprite3D
@export var BottomFrontRightSlope:Sprite3D
@export var BottomFrontLeftSlope:Sprite3D


@export_group("Sprite Connectors Handlers")
@export var C1:Sprite3D
@export var C2:Sprite3D
@export var C3:Sprite3D
@export var C4:Sprite3D

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
@export var FrontTopLeft=false
@export var FrontTop=false
@export var FrontTopRight=false
@export var FrontLeft=false
@export var FrontRight=false
@export var FrontBottomLeft=false
@export var FrontBottom=false
@export var FrontBottomRight=false

@export_group("Testing Back")
@export var Back=false
@export var BackTopLeft=false
@export var BackTop=false
@export var BackTopRight=false
@export var BackLeft=false
@export var BackRight=false
@export var BackBottomLeft=false
@export var BackBottom=false
@export var BackBottomRight=false


@export_group("Update Sprite")
@export var updatetexture=false
@export var updatesize=false

@export_group("Update Collider")
@export var outputcollider=false
@export var collision_shape_3d_2 :CollisionShape3D

@export var finaldatapoint=[]


func _process(delta):
	
	if record_corner:
		corner_datapoints.clear()
		for i in points:
			corner_datapoints.append(i.global_position)
		record_corner=false
	
	if record_straightV2:
		straightV2_datapoints.clear()
		for i in points:
			straightV2_datapoints.append(i.global_position)
		record_straightV2=false
	
	if record_straight:
		straight_datapoints.clear()
		for i in points:
			straight_datapoints.append(i.global_position)
		record_straight=false
	
	if record_full:
		full_datapoints.clear()
		for i in points:
			full_datapoints.append(i.global_position)
		record_full=false
	
	if record_diagonal_outer:
		diagonal_outer_datapoints.clear()
		for i in points:
			diagonal_outer_datapoints.append(i.global_position)
		record_diagonal_outer=false
	
	if record_diagonal_inner:
		diagonal_inner_datapoints.clear()
		for i in points:
			diagonal_inner_datapoints.append(i.global_position)
		record_diagonal_inner=false
	
	if record_diagonal_connected_inner:
		diagonal_connected_inner_datapoints.clear()
		for i in points:
			diagonal_connected_inner_datapoints.append(i.global_position)
		record_diagonal_connected_inner=false
	
	
	
	
	if updatesize:
		FrontTopLeftCorner.offset=FrontTopLeftCorner.texture.get_size()*Vector2(-1,0)
		FrontBottomLeftCorner.offset=FrontBottomLeftCorner.texture.get_size()*Vector2(-1,-1)
		FrontBottomRightCorner.offset=FrontBottomRightCorner.texture.get_size()*Vector2(0,-1)
		
	if updatetexture:
		finaldatapoint.clear()
		C1.visible=false
		C2.visible=false
		C3.visible=false
		C4.visible=false
		
		if (TopLeft or Top or Left ):
			if Top and not (Left or TopLeft):
				setSpriteFlips(FrontTopLeftCorner,straight,straight_datapoints,Vector2(-1,-1),true,false)
			elif Left and not (Top or TopLeft):
				setSpriteFlips(FrontTopLeftCorner,straightV2,straightV2_datapoints,Vector2(-1,-1),false,true)
			elif TopLeft and not (Left or Top):
				setSpriteFlips(FrontTopLeftCorner,diagonal_inner,diagonal_inner_datapoints,Vector2(-1,-1),true,false)
				C3.visible=true
				C4.visible=true
			elif TopLeft and Top and not Left:
				setSpriteFlips(FrontTopLeftCorner,diagonal_connected_inner,diagonal_connected_inner_datapoints,Vector2(-1,-1),false,true)
				C3.visible=true
			elif TopLeft and Left and not Top:
				setSpriteFlips(FrontTopLeftCorner,diagonal_connected_inner,diagonal_connected_inner_datapoints,Vector2(-1,-1),true,false)
				C4.visible=true
			elif Top and Left and not TopLeft:
				setSpriteFlips(FrontTopLeftCorner,full,full_datapoints,Vector2(-1,-1),true,false)
			elif TopLeft and Left and Top:
				setSpriteFlips(FrontTopLeftCorner,full,full_datapoints,Vector2(-1,-1),true,false)
		else:
			if BottomLeft:
				setSpriteFlips(FrontTopLeftCorner,diagonal_outer,diagonal_outer_datapoints,Vector2(-1,-1),true,true)
			
			elif TopRight:
				setSpriteFlips(FrontTopLeftCorner,diagonal_outer,diagonal_outer_datapoints,Vector2(-1,-1),true,true)
			else:
				setSpriteFlips(FrontTopLeftCorner,corner,corner_datapoints,Vector2(-1,-1),true,true)
		
		
		if (TopRight or Top or Right ):
			if Top and not (Right or TopRight):
				setSpriteFlips(FrontTopRightCorner,straight,straight_datapoints,Vector2(1,-1),false,false)
			elif Right and not (Top or TopRight):
				setSpriteFlips(FrontTopRightCorner,straightV2,straightV2_datapoints,Vector2(1,-1),true,true)
			elif TopRight and not (Right or Top):
				setSpriteFlips(FrontTopRightCorner,diagonal_inner,diagonal_inner_datapoints,Vector2(1,-1),false,false)
				C1.visible=true
				C2.visible=true
			elif TopRight and Top and not Right:
				setSpriteFlips(FrontTopRightCorner,diagonal_connected_inner,diagonal_connected_inner_datapoints,Vector2(1,-1),true,true)
				C1.visible=true
			elif TopRight and Right and not Top:
				C2.visible=true
				setSpriteFlips(FrontTopRightCorner,diagonal_connected_inner,diagonal_connected_inner_datapoints,Vector2(1,-1),false,false)
			elif Top and Right and not TopRight:
				setSpriteFlips(FrontTopRightCorner,full,full_datapoints,Vector2(1,-1),true,false)
			elif TopRight and Right and Top:
				setSpriteFlips(FrontTopRightCorner,full,full_datapoints,Vector2(1,-1),true,false)
		else:
			if BottomRight:
				setSpriteFlips(FrontTopRightCorner,diagonal_outer,diagonal_outer_datapoints,Vector2(1,-1),false,true)
			elif TopLeft:
				setSpriteFlips(FrontTopRightCorner,diagonal_outer,diagonal_outer_datapoints,Vector2(1,-1),false,true)
			else:
				setSpriteFlips(FrontTopRightCorner,corner,corner_datapoints,Vector2(1,-1),false,true)
				
		
		
		if (BottomLeft or Bottom or Left ):
			if Bottom and not (Left or BottomLeft):
				setSpriteFlips(FrontBottomLeftCorner,straight,straight_datapoints,Vector2(-1,1),true,false)
			elif Left and not (Bottom or BottomLeft):
				setSpriteFlips(FrontBottomLeftCorner,straightV2,straightV2_datapoints,Vector2(-1,1),false,false)
			elif BottomLeft and not (Left or Bottom):
				setSpriteFlips(FrontBottomLeftCorner,diagonal_inner,diagonal_inner_datapoints,Vector2(-1,1),false,false)
			elif BottomLeft and Bottom and not Left:
				setSpriteFlips(FrontBottomLeftCorner,diagonal_connected_inner,diagonal_connected_inner_datapoints,Vector2(-1,1),false,false)
			elif BottomLeft and Left and not Bottom:
				setSpriteFlips(FrontBottomLeftCorner,diagonal_connected_inner,diagonal_connected_inner_datapoints,Vector2(-1,1),true,true)
			elif Bottom and Left and not BottomLeft:
				setSpriteFlips(FrontBottomLeftCorner,full,full_datapoints,Vector2(-1,1),true,false)
			elif BottomLeft and Left and Bottom:
				setSpriteFlips(FrontBottomLeftCorner,full,full_datapoints,Vector2(-1,1),true,false)
		else:
			if TopLeft:
				setSpriteFlips(FrontBottomLeftCorner,diagonal_outer,diagonal_outer_datapoints,Vector2(-1,1),true,false)
			
			elif BottomRight:
				setSpriteFlips(FrontBottomLeftCorner,diagonal_outer,diagonal_outer_datapoints,Vector2(-1,1),true,false)
			else:
				setSpriteFlips(FrontBottomLeftCorner,corner,corner_datapoints,Vector2(-1,1),true,false)
		
		if (BottomRight or Bottom or Right ):
			if Bottom and not (Right or BottomRight):
				setSpriteFlips(FrontBottomRightCorner,straight,straight_datapoints,Vector2(1,1),false,false)
			elif Right and not (Bottom or BottomRight):
				setSpriteFlips(FrontBottomRightCorner,straightV2,straightV2_datapoints,Vector2(1,1),false,false)
			elif BottomRight and not (Right or Bottom):
				setSpriteFlips(FrontBottomRightCorner,diagonal_inner,diagonal_inner_datapoints,Vector2(1,1),true,false)
			elif BottomRight and Bottom and not Right:
				setSpriteFlips(FrontBottomRightCorner,diagonal_connected_inner,diagonal_connected_inner_datapoints,Vector2(1,1),true,false)
			elif BottomRight and Right and not Bottom:
				setSpriteFlips(FrontBottomRightCorner,diagonal_connected_inner,diagonal_connected_inner_datapoints,Vector2(1,1),false,true)
			elif Bottom and Right and not BottomRight:
				setSpriteFlips(FrontBottomRightCorner,full,full_datapoints,Vector2(1,1),true,false)
			elif BottomRight and Right and Bottom:
				setSpriteFlips(FrontBottomRightCorner,full,full_datapoints,Vector2(1,1),true,false)
		else:
			if TopRight:
				setSpriteFlips(FrontBottomRightCorner,diagonal_outer,diagonal_outer_datapoints,Vector2(1,1),false,false)
			elif BottomLeft:
				setSpriteFlips(FrontBottomRightCorner,diagonal_outer,diagonal_outer_datapoints,Vector2(1,1),false,false)
			else:
				setSpriteFlips(FrontBottomRightCorner,corner,corner_datapoints,Vector2(1,1),false,false)
		
	if outputcollider:
		
		var convex=ConvexPolygonShape3D.new()
		var seconddata=[]
		for i in finaldatapoint:

			seconddata.append(i*Vector3(1,1,-1))
		for i in seconddata:
			finaldatapoint.append(i)
		convex.points=finaldatapoint
		collision_shape_3d_2.shape=convex
		outputcollider=false
	
	
	


func setSpriteFlips(sprite,texture,data,areaindex,horizontal,vertical):
	
	
	sprite.flip_v=vertical
	sprite.flip_h=horizontal
	var minX=9999
	var maxX=-9999
	var minY=9999
	var maxY=-9999
	for i in data:
		if i.x>maxX:
			maxX=i.x
		if i.y>maxY:
			maxY=i.y
		if i.x<minX:
			minX=i.x
		if i.y<minY:
			minY=i.y
		
	for i in data:
		var finalX=i.x
		var finalY=i.y		
		
		if not finaldatapoint.has(Vector3(finalX*areaindex.x,finalY*areaindex.y,0.05)):
			
			finaldatapoint.append(Vector3(finalX*areaindex.x,finalY*areaindex.y,0.05))
	sprite.texture=texture

