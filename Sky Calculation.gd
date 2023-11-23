@tool
extends Node

@export var button: bool = false : set = set_button
@export var color:Color
func set_button(new_value: bool) -> void:
	var distance=1
	var density=1
	var rotation=.75
	var rayleighScatteringCoefficient = pow(density, 0.5) * 1.5e-6

	#Calculate the Mie scattering coefficient
	var mieScatteringCoefficient = pow(density, 0.5) * 5e-9

	#Calculate the ozone absorption coefficient
	var ozoneAbsorptionCoefficient = 0.02 * density

	#Calculate the sun's zenith angle
	var zenithAngle = acos(distance)

	#Calculate the amount of Rayleigh scattering
	var rayleighScattering = rayleighScatteringCoefficient * (1 - cos(zenithAngle))

	#Calculate the amount of Mie scattering
	var mieScattering = mieScatteringCoefficient * (1 - cos(zenithAngle))

	#Calculate the amount of ozone absorption
	var ozoneAbsorption = ozoneAbsorptionCoefficient * zenithAngle

	#Calculate the red component of the sky color
	var red = 1.0 - (rayleighScattering * 0.65 + mieScattering * 0.2 + ozoneAbsorption * 0.15)

	#Calculate the green component of the sky color
	var green = 1.0 - (rayleighScattering * 0.55 + mieScattering * 0.3 + ozoneAbsorption * 0.15)

	#Calculate the blue component of the sky color
	var blue = 1.0 - (rayleighScattering * 0.35 + mieScattering * 0.4 + ozoneAbsorption * 0.25)

	#Adjust the color based on the rotation of the earth
	red *= 1 + 0.1 * sin(2 * rotation * 3.14)
	green *= 1 - 0.1 * sin(2 * rotation * 3.14)
	blue *= 1 + 0.2 * sin(2 * rotation * 3.14)
	print(red)
	print(green)
	print(blue)
