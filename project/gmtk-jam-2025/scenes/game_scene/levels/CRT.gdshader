shader_type canvas_item;

uniform sampler2D ST : hint_screen_texture, filter_linear_mipmap_anisotropic;
uniform vec4 scanline_color : source_color = vec4(0,0,0,1);
uniform vec4 flicker_color  : source_color = vec4(0,0,0,1);
uniform float scanlines_count     = 10.0;
uniform float scanlines_intensity = 0.05;
uniform float flicker_speed       = 30.0;
uniform float flicker_intensity : hint_range(0.0, 1.0, 0.001) = 0.025;
uniform float color_offset = 1.5;
uniform float blur         = 0.15;
uniform float power : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2  ps   = 1.0 / vec2(textureSize(ST, 0));
    float off  = color_offset * ps.x;

    float r = textureLod(ST, SCREEN_UV + vec2( off, 0.0), blur).r;
    float g = textureLod(ST, SCREEN_UV,                       blur).g;
    float b = textureLod(ST, SCREEN_UV + vec2(-off, 0.0),     blur).b;
    vec3  col = vec3(r, g, b);

    float f = sin((UV.y - TIME * flicker_speed) * 10.0) * flicker_intensity;
    col = mix(col, flicker_color.rgb, f);

    float s = sin(FRAGCOORD.y * scanlines_count) * scanlines_intensity;
    col = mix(col, scanline_color.rgb, s);

    col *= 1.0 - power;

    float dist = abs(UV.y - 0.5);

    float close_p   = clamp(power * 1.2, 0.0, 1.0);
    float stripe_h  = 0.5 * (1.0 - close_p);
    float fade      = smoothstep(stripe_h, stripe_h + 0.04, dist);
    vec3  base_col  = mix(col, vec3(0.0), fade);

    float bar_phase = smoothstep(0.75, 0.95, power);
    float thick0    = 0.02 * (1.0 - bar_phase);
    float bar_mask  = (1.0 - smoothstep(thick0, thick0 + 0.005, dist)) * bar_phase;
    vec3  white_bar = vec3(1.0) * bar_mask * (1.0 - bar_phase);

    vec3  final_rgb = base_col + white_bar;
    COLOR = vec4(final_rgb, 1.0);
}
