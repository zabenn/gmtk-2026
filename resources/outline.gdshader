shader_type canvas_item;
uniform float maxLineWidth: hint_range(0.0, 100.0) = 6.0;
uniform float minLineWidth: hint_range(0.0, 100.0) = 2.0;
uniform float speed: hint_range(0.0, 10.0) = 5.0;
uniform float blockSize: hint_range(0.001, 100.0) = 20.0;
uniform vec4 color: source_color;
// How far the noisy edge can eat into the texture itself (0 = none).
uniform float overlapAmount: hint_range(0.0, 5.0) = 2.0;
// Modulates the main texture body.
uniform vec4 textureColor: source_color = vec4(1.0);
// Used to compensate for alpha values.
uniform float tolerance: hint_range(0.0, 0.999) = 0.5;
varying vec2 node_scale;

// Compensate UV for outline.
void vertex() {
	node_scale = vec2(length(MODEL_MATRIX[0].xy), length(MODEL_MATRIX[1].xy));
	vec2 offset = TEXTURE_PIXEL_SIZE * max(maxLineWidth, minLineWidth) * 2.0 / node_scale;
	VERTEX = vec2(VERTEX.x * (1.0 + offset.x), VERTEX.y * (1.0 + offset.y));
}

// Checks a fragment for the edge of an uv.
bool border(vec2 uv) {
	vec2 uvBorder = abs(uv - vec2(0.5));
	return max(step(0.5, uvBorder.x), step(0.5, uvBorder.y)) > 0.0;
}

// Gets alpha of given fragment if not near the edge.
float get_alpha(sampler2D tex, vec2 uv){
	float res = 0.0;
	if (!border(uv)) {
		res = texture(tex, uv).a;
	}
	return res;
}

// Pseudorandom number
float hash(vec2 p, float s) {
	return fract(35.1 * sin(dot(vec3(112.3, 459.2, 753.2), vec3(p, s))));
}

// Noise function.
float noise(vec2 p, float s) {
	vec2 d = vec2(0, 1);
	vec2 b = floor(p);
	vec2 f = fract(p);
	return mix(
		mix(hash(b + d.xx, s), hash(b + d.yx, s), f.x),
		mix(hash(b + d.xy, s), hash(b + d.yy, s), f.x), f.y);
}

// Randomize line width at fragment.
float get_line_width(vec2 p, float s) {
	p /= blockSize;
	float w = 0.0;
	float intensity = 1.0;
	for (int i = 0; i < 3; i++) {
		w = mix(w, noise(p, s), intensity);
		p /= 2.0;
		intensity /= 2.0;
	}
	return mix(maxLineWidth, minLineWidth, w);
}

// Checks for neighboring pixels.
float compute_outline(vec2 size, sampler2D tex, vec2 uv) {
	float res = 0.0;
	for (float i = -1.0; i < 2.0; i += 2.0) {
		res += get_alpha(tex, uv + vec2(i * size.x, 0.0));
		res += get_alpha(tex, uv + vec2(0.0, i * size.y));
		for (float j = -1.0; j < 2.0; j += 2.0) {
			res += get_alpha(tex, uv + vec2(i * size.x, j * size.y));
			res += get_alpha(tex, uv + vec2(i * size.x, j * size.y * 0.5));
		}
	}
	return res;
}

// Checks for neighboring pixels.
float in_range(vec2 size, sampler2D tex, vec2 uv) {
	float res = 0.0;
	for (float i = -1.0; i < 2.0; i += 2.0) {
		res += get_alpha(tex, uv + vec2(i * size.x, 0.0));
		res += get_alpha(tex, uv + vec2(0.0, i * size.y));
		for (float j = -1.0; j < 2.0; j += 2.0) {
			res += get_alpha(tex, uv + vec2(i * size.x, j * size.y));
			res += get_alpha(tex, uv + vec2(i * size.x, j * size.y * 0.5));
		}
	}
	return res;
}

void fragment() {
	// Correct image size to account for outline in frame.
	vec2 uv = UV;
	uv -= vec2(0.5);
	vec2 edge = TEXTURE_PIXEL_SIZE * max(maxLineWidth, minLineWidth) * 2.0 / node_scale;
	uv = uv + uv * edge;
	uv += vec2(0.5);

	vec4 texColor = texture(TEXTURE, uv);
	vec4 newColor = texColor * textureColor;

	if (max(maxLineWidth, minLineWidth) > 0.0) {
		float timeStep = floor(TIME * speed);

		// Per-fragment noise that jitters the alpha threshold, so the
		// outline zone randomly intrudes into (or recedes from) the
		// texture's own body instead of hugging a clean silhouette.
		float edgeNoise = noise(uv / TEXTURE_PIXEL_SIZE / blockSize, timeStep + 100.0);
		float effectiveTolerance = clamp(tolerance + (edgeNoise - 0.5) * overlapAmount, 0.0, 0.999);

		if (texColor.a <= effectiveTolerance || border(uv)) {
			vec2 size = TEXTURE_PIXEL_SIZE / node_scale;
			size *= get_line_width(uv / TEXTURE_PIXEL_SIZE, timeStep);
			vec4 finalColor = step(1.0 - tolerance, in_range(size, TEXTURE, uv)) * color;
			newColor = finalColor;
		}
	}

	COLOR = newColor;
}
