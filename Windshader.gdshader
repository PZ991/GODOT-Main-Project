shader_type spatial;
render_mode blend_mix,depth_prepass_alpha,cull_disabled,diffuse_burley,specular_schlick_ggx;

uniform sampler2D albedo;
uniform sampler2D noise1;
uniform sampler2D noise2;
uniform float distortionspeed;
uniform float distortion_factor;

void fragment(){
	vec2 noise_uv = UV +TIME*distortionspeed;
	vec2 noise_uv2 = UV -TIME*distortionspeed+vec2(0.6,0);
	
	vec2 noise=vec2(texture(noise1,noise_uv).r,texture(noise2,noise_uv).r);
	vec2 noisev2=vec2(texture(noise1,noise_uv2).r,texture(noise2,noise_uv2).r);
	
	vec2 base_uv=UV+(noise+noisev2)*distortion_factor;
	ALBEDO=texture(albedo,base_uv).rgb;

	ALPHA=texture(albedo,base_uv).a;
}