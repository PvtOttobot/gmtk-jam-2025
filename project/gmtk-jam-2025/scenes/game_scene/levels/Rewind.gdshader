//credit to https://www.shadertoy.com/view/4lB3Dc
	
shader_type canvas_item;
uniform sampler2D screen_tex : hint_screen_texture, repeat_disable;

float rand(vec2 c){
    return fract(sin(dot(c, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment(){
    float t = TIME;
    vec2  uv = SCREEN_UV;
    vec2  p  = uv;
    vec4  col = vec4(0.0);

    p.x += (rand(vec2(t, uv.y)) - 0.5) / 64.0;
    p.y += (rand(vec2(t))       - 0.5) / 64.0;

    col += (vec4(-0.5) + vec4(
        rand(vec2(uv.y, t)),
        rand(vec2(uv.y, t + 1.0)),
        rand(vec2(uv.y, t + 2.0)),
        0.0)) * 0.1;

    float yinv = 1.0 - p.y;
    float w = rand(vec2(floor(yinv * 80.0), floor(p.x * 50.0)) + vec2(t, 0.0));

    if (w > 11.5 - 30.0 * yinv || w < 1.5 - 5.0 * yinv)
        col += texture(screen_tex, p);
    else
        col = vec4(1.0);

    COLOR = col;
}
