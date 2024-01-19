@tool
extends Node3D

@export_group("Rendered Objects")
@export var Tileset:PackedScene
@export var corner:Texture
@export var VerticalStraight:Texture
@export var HorizontalStraight:Texture
@export var Full:Texture
@export var DiagonalInner:Texture
@export var DiagonalOuter:Texture
@export var DiagonalConnected:Texture


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

@export_group("Testing")
@export var process=false
@export var TR=Node3D 
@export var TL=Node3D 
@export var BR=Node3D 
@export var BL=Node3D 


func _process(delta):
	if process:
		#var instance = Tileset.instantiate()
		if not Front :
			if not IncludesSpecific(["Top"],false):
				if not FrontTop:
					if not FrontRight:
						TR.SetCubeFront(HorizontalStraight,false,true)
					if not FrontLeft:
						TL.SetCubeFront(VerticalStraight,false,true)
			
			if not IncludesSpecific(["Right"],false) :
				
				if not FrontRight:
					if not FrontTop:
						TR.SetCubeFront(VerticalStraight,false,true)
					if not FrontBottom:
						BR.SetCubeFront(HorizontalStraight,false,true)
					
			if not IncludesSpecific(["Left"],false) :
				
				if not FrontLeft:
					if not FrontTop:
						TL.SetCubeFront(HorizontalStraight,false,true)
					if not FrontBottom:
						BL.SetCubeFront(VerticalStraight,false,true)
			
			if not IncludesSpecific(["Bottom"],false):
				if not FrontBottom:
					if not FrontRight:
						BR.SetCubeFront(VerticalStraight,false,true)
					if not FrontLeft:
						BL.SetCubeFront(HorizontalStraight,false,true)
			
			if not IncludesSpecific(["Top","Right"],false):
				if not FrontTop:
					if not FrontRight:
						TR.SetCubeFront(Full,false,true)
					if not FrontLeft:
						TL.SetCubeFront(VerticalStraight,false,true)
				if not FrontBottom:
					if not FrontRight:
						BR.SetCubeFront(HorizontalStraight,false,true)
			
			if not IncludesSpecific(["Top","Left"],false):
				if not FrontTop:
					if not FrontLeft:
						TL.SetCubeFront(Full,false,true)
					if not FrontRight:
						TR.SetCubeFront(HorizontalStraight,false,true)
				if not FrontBottom:
					if not FrontLeft:
						BL.SetCubeFront(VerticalStraight,false,true)
			
			if not IncludesSpecific(["Top","Bottom"],false):
				if not FrontTop:
					if not FrontRight:
						TR.SetCubeFront(HorizontalStraight,false,true)
					if not FrontLeft:
						TL.SetCubeFront(VerticalStraight,false,true)
				if not FrontBottom:
					if not FrontRight:
						BR.SetCubeFront(VerticalStraight,false,true)
					if not FrontLeft:
						BL.SetCubeFront(HorizontalStraight,false,true)
			
			if not IncludesSpecific(["Left","Right"],false):
				
				if not FrontLeft:
					if not FrontTop:
						TL.SetCubeFront(HorizontalStraight,false,true)
					if not FrontBottom:
						BL.SetCubeFront(VerticalStraight,false,true)
				if not FrontRight:
					if not FrontTop:
						TR.SetCubeFront(VerticalStraight,false,true)
					if not FrontBottom:
						BR.SetCubeFront(HorizontalStraight,false,true)
			
			if not IncludesSpecific(["Bottom","Right"],false):
				if not FrontBottom:
					if not FrontRight:
						BR.SetCubeFront(Full,false,true)
					if not FrontLeft:
						BL.SetCubeFront(HorizontalStraight,false,true)
				if not FrontTop:
					if not FrontRight:
						TR.SetCubeFront(VerticalStraight,false,true)
			
			if not IncludesSpecific(["Bottom","Left"],false):
				if not FrontBottom:
					if not FrontLeft:
						BL.SetCubeFront(Full,false,true)
					if not FrontRight:
						BR.SetCubeFront(VerticalStraight,false,true)
				if not FrontTop:
					if not FrontLeft:
						TL.SetCubeFront(HorizontalStraight,false,true)
			
			if not IncludesSpecific(["Top","Right","Left"],false):
				if not FrontTop:
					if not FrontRight:
						TR.SetCubeFront(Full,false,true)
					if not FrontLeft:
						TL.SetCubeFront(Full,false,true)
				if not FrontBottom:
					if not FrontRight:
						BR.SetCubeFront(HorizontalStraight,false,true)
					if not FrontLeft:
						BL.SetCubeFront(VerticalStraight,false,true)
			
			if not IncludesSpecific(["Bottom","Right","Left"],false):
				if not FrontBottom:
					if not FrontLeft:
						BL.SetCubeFront(Full,false,true)
					if not FrontRight:
						BR.SetCubeFront(Full,false,true)
				if not FrontTop:
					if not FrontLeft:
						TL.SetCubeFront(HorizontalStraight,false,true)
					if not FrontRight:
						TR.SetCubeFront(VerticalStraight,false,true)
			
			if not IncludesSpecific(["Bottom","Right","Top"],false):
				if not FrontBottom:
					if not FrontLeft:
						BL.SetCubeFront(HorizontalStraight,false,true)
					if not FrontRight:
						BR.SetCubeFront(Full,false,true)
				if not FrontTop:
					if not FrontLeft:
						TL.SetCubeFront(VerticalStraight,false,true)
					if not FrontRight:
						TR.SetCubeFront(Full,false,true)
			
			if not IncludesSpecific(["Bottom","Left","Top"],false):
				if not FrontBottom:
					if not FrontLeft:
						BL.SetCubeFront(Full,false,true)
					if not FrontRight:
						BR.SetCubeFront(VerticalStraight,false,true)
				if not FrontTop:
					if not FrontLeft:
						TL.SetCubeFront(Full,false,true)
					if not FrontRight:
						TR.SetCubeFront(HorizontalStraight,false,true)
			
			if not IncludesSpecific(["Bottom","Left","Top","Right"],false):
				if not FrontBottom:
					if not FrontLeft:
						BL.SetCubeFront(Full,false,true)
					if not FrontRight:
						BR.SetCubeFront(Full,false,true)
				if not FrontTop:
					if not FrontLeft:
						TL.SetCubeFront(Full,false,true)
					if not FrontRight:
						TR.SetCubeFront(Full,false,true)
			
			
			
			if Right and Top:
				TR.SetCubeFront(Full,false,false)
			else:
				if TopRight:
					if Top and not Right:
						TR.SetCubeFront(DiagonalConnected,false,false)
					elif Right and not Top :
						TR.SetCubeFront(DiagonalConnected,true,true)
					else:
						TR.SetCubeFront(DiagonalInner,false,false)
				elif Right and not Top:
					TR.SetCubeFront(VerticalStraight,false,false)
				elif Top and not Right:
					TR.SetCubeFront(HorizontalStraight,false,true)
				elif TopLeft or BottomRight:
					TR.SetCubeFront(DiagonalOuter,false,true)
				else:
					TR.SetCubeFront(corner,false,true)
			
			
			if Left and Top:
				TL.SetCubeFront(Full,false,false)
			else:
				if TopLeft:
					if Top and not Left:
						TL.SetCubeFront(DiagonalConnected,true,true)
					elif Left and not Top :
						TL.SetCubeFront(DiagonalConnected,false,false)
					else:
						TL.SetCubeFront(DiagonalInner,false,false)
				elif Left and not Top:
					TL.SetCubeFront(HorizontalStraight,false,true)
				elif Top and not Left:
					TL.SetCubeFront(VerticalStraight,false,true)
				
				elif TopRight or BottomLeft:
					if not Left and not Top:
						TL.SetCubeFront(DiagonalOuter,false,true)
				else:
					TL.SetCubeFront(corner,false,true)
			
			if Right and Bottom:
				BR.SetCubeFront(Full,false,false)
			else:
				if BottomRight:
					if Bottom and not Right:
						BR.SetCubeFront(DiagonalConnected,true,true)
					elif Right and not Bottom :
						BR.SetCubeFront(DiagonalConnected,false,false)
					else:
						BR.SetCubeFront(DiagonalInner,false,false)
				elif Right and not Bottom:
					BR.SetCubeFront(HorizontalStraight,false,true)
				elif Bottom and not Right:
					BR.SetCubeFront(VerticalStraight,false,true)
				
				elif BottomLeft or TopRight:
					if not Right and not Bottom:
						BR.SetCubeFront(DiagonalOuter,false,true)
				else:
					BR.SetCubeFront(corner,false,true)
			
			
			if Left and Bottom:
				Bottom.SetCubeFront(Full,false,false)
			else:
				if BottomLeft:
					if Bottom and not Left:
						BL.SetCubeFront(DiagonalConnected,false,false)
					elif Left and not Bottom :
						BL.SetCubeFront(DiagonalConnected,true,true)
					else:
						BL.SetCubeFront(DiagonalInner,false,false)
				elif Left and not Bottom:
					BL.SetCubeFront(VerticalStraight,false,false)
				elif Bottom and not Left:
					BL.SetCubeFront(HorizontalStraight,false,true)
				elif TopLeft or BottomLeft:
					BL.SetCubeFront(DiagonalOuter,false,true)
				else:
					BL.SetCubeFront(corner,false,true)
			
			
		
			
		process=false


func NotORIncludes(variable):
	if variable=="Front":
		if not(Front or FrontTopLeft or FrontTop or FrontTopRight or FrontLeft or
		FrontRight or FrontBottomLeft or FrontBottom or FrontBottomRight):
			return true
			
	elif variable=="Back":
		if not(Back or BackTopLeft or BackTop or BackTopRight or BackLeft or
		BackRight or BackBottomLeft or BackBottom or BackBottomRight):
			return true
	
	elif variable=="Top":
		if not(TopLeft or Top or TopRight or FrontTopLeft or FrontTop or
		FrontTopRight or BackTopLeft or BackTop or BackTopRight):
			return true
	
	elif variable=="Bottom":
		if not (BottomLeft or Bottom or BottomRight or FrontBottomLeft or 
		FrontBottom or FrontBottomRight or BackBottomLeft or BackBottom 
		or BackBottomRight):
			return true
	
	elif variable=="Right":
		if not (TopRight or Right or BottomRight or FrontTopRight or 
		FrontRight or FrontBottomRight or BackTopRight or BackRight 
		or BackBottomRight):
			return true
	
	elif variable=="Left":
		if not (TopLeft or Left or BottomLeft or FrontTopLeft or FrontLeft or 
		FrontBottomLeft or BackTopLeft or BackLeft or BackBottomLeft):
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
	
