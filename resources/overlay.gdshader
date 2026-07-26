shader_type canvas_item;
render_mode blend_mix;

// The screen contents beneath this sprite
uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

// How strongly the paper texture blends in, 0.0 - 1.0
uniform float opacity : hint_range(0.0, 1.0) = 0.1;

// 0 = Multiply, 1 = Overlay, 2 = Screen, 3 = Soft Light, 4 = Hard Light, 5 = Darken, 6 = Linear Burn
uniform int blend_mode : hint_range(0, 6) = 0;

vec4 blend_multiply(vec4 base, vec4 blend){
	return base * blend;
}

vec4 blend_screen(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

vec4 blend_darken(vec4 base, vec4 blend){
	return min(base, blend);
}

vec4 blend_overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

vec4 blend_hard_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

vec4 blend_soft_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend),
		sqrt(max(base, 0.0)) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend),
		limit);
}

vec4 blend_linear_burn(vec4 base, vec4 blend){
	return base + blend - 1.0;
}

void fragment(){
	// What's on screen beneath this sprite
	vec4 base = texture(screen_texture, SCREEN_UV);
	// The paper sprite's own texture (this node's texture, e.g. paper grain)
	vec4 paper = texture(TEXTURE, UV) * COLOR;

	vec4 blended;
	if (blend_mode == 0) {
		blended = blend_multiply(base, paper);
	} else if (blend_mode == 1) {
		blended = blend_overlay(base, paper);
	} else if (blend_mode == 2) {
		blended = blend_screen(base, paper);
	} else if (blend_mode == 3) {
		blended = blend_soft_light(base, paper);
	} else if (blend_mode == 4) {
		blended = blend_hard_light(base, paper);
	} else if (blend_mode == 5) {
		blended = blend_darken(base, paper);
	} else {
		blended = blend_linear_burn(base, paper);
	}

	// Mix by opacity, further weighted by the paper texture's own alpha
	// (so transparent bits of a torn-edge paper texture don't tint the screen)
	vec3 final_rgb = mix(base.rgb, blended.rgb, opacity * paper.a);
	COLOR = vec4(final_rgb, 1.0);
}
