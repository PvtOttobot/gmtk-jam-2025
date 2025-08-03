shader_type canvas_item;
uniform float power : hint_range(0.,1.) = 0.0; // 0 = on, 1 = off

void fragment() {
    vec2  uv    = UV;
    float distY = abs(uv.y - 0.5);
    float bar   = smoothstep(mix(0.0, 0.06, power), 0.0, distY);

    vec4  col   = texture(TEXTURE, uv) * (1.0 - power);      // dim
    vec4  flash = vec4(1.0) * (1.0 - bar) * pow(1.0 - power, 0.2);

    COLOR = mix(col, flash, 1.0) * (1.0 - power);            // fade
}
