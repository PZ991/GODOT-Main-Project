extends Resource

class_name Terrainshapedata
@export var top: Material
@export var bottom: Material
@export var front: Material
@export var back: Material
@export var side: Material

@export var top_mesh: PackedScene
@export var bottom_mesh: PackedScene
@export var front_mesh: PackedScene
@export var back_mesh: PackedScene
@export var side_mesh: PackedScene

@export var Slope_mesh: PackedScene
@export var Slopeside_mesh: PackedScene
@export var Slopecorner_mesh: PackedScene
@export var Slopecornerside1_mesh: PackedScene
@export var Slopecornerside2_mesh: PackedScene


@export var Convex_mesh: PackedScene
@export var Convexside_mesh: PackedScene
@export var Convexcorner_mesh: PackedScene
@export var Convexcornerside1_mesh: PackedScene
@export var Convexcornerside2_mesh: PackedScene


@export var Concave_mesh: PackedScene
@export var Concaveside_mesh: PackedScene
@export var Concavecorner_mesh: PackedScene
@export var Concavecornerside1_mesh: PackedScene
@export var Concavecornerside2_mesh: PackedScene


@export var cornerbottom: PackedScene
@export_category("3 X 3 X 3 allow shape")
@export var X3Y3Z3=true
@export var X3Y2Z3=true
@export var X3Y1Z3=true
@export var X3Y3Z2=true
@export var X3Y2Z2=true
@export var X3Y1Z2=true
@export var X3Y3Z1=true
@export var X3Y2Z1=true
@export var X3Y1Z1=true
@export_category("2 X 3 X 3 allow shape")
@export var X2Y3Z3=true
@export var X2Y2Z3=true
@export var X2Y1Z3=true
@export var X2Y3Z2=true
@export var X2Y2Z2=true
@export var X2Y1Z2=true
@export var X2Y3Z1=true
@export var X2Y2Z1=true
@export var X2Y1Z1=true
@export_category("1 X 3 X 3 allow shape")
@export var X1Y3Z3=true
@export var X1Y2Z3=true
@export var X1Y1Z3=true
@export var X1Y3Z2=true
@export var X1Y2Z2=true
@export var X1Y1Z2=true
@export var X1Y3Z1=true
@export var X1Y2Z1=true
@export var X1Y1Z1=true

@export_category("Shape Limit")
@export var useslope=false
@export var useconvex=false
@export var useconcave=false
@export var usecorner=false

@export_category("Generation Limit")
#X and Z depends if Z axis is 3 or 9 which is only 3X3 or 9X9 cubes
@export var only3Y=true
@export var only2Y=false
@export var only1Y=false

@export_category("2Sided")
@export var use2sidedslope=false
@export var use2concaveslope=false
@export var use2convexslope=false

@export var slope2_mesh: PackedScene
@export var Convex2_mesh: PackedScene
@export var Convex2top_mesh: PackedScene
@export var Concave2_mesh: PackedScene

@export var slopediagonal:PackedScene

@export_category("3Sided")
@export var use3sidedslope=false
@export var use3concaveslope=false
@export var use3convexslope=false

@export var slope3_mesh: PackedScene
@export var Convex3_mesh: PackedScene
@export var Convex3top_mesh: PackedScene
@export var Concave3_mesh: PackedScene
@export var Concave3corner_mesh: PackedScene

@export_category("4Sided")
@export var use4sidedslope=false
@export var use4concaveslope=false
@export var use4convexslope=false

@export var slope4_mesh: PackedScene
@export var Convex4_mesh: PackedScene
@export var Convex4top_mesh: PackedScene
@export var Concave4_mesh: PackedScene

@export_category("Shape Option")
@export var useslopetop=false
@export var useconvextop=false
@export var useconcavetop=false

@export var useslopebottom=false
@export var useconvexbottom=false
@export var useconcavebottom=false
