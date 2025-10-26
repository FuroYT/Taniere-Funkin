#pragma header

uniform vec2 uResolution;  // screen resolution in pixels
uniform vec2 uCenter;      // rectangle center in pixels
uniform vec2 uSize;        // width and height of rectangle in pixels
uniform float uRotation;   // rotation in radians
#define iChannel0 bitmap   // camera texture

// Rotate a point around the origin
vec2 rotate(vec2 point, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(
        point.x * c - point.y * s,
        point.x * s + point.y * c
    );
}

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 pixelPos = uv * uResolution; // convert UV to pixels

    // Transform coordinates relative to rectangle center
    vec2 pos = pixelPos - uCenter;

    // Apply rotation
    pos = rotate(pos, -uRotation);

    // Check if inside rectangle bounds
    vec2 halfSize = uSize * 0.5;
    if(abs(pos.x) > halfSize.x || abs(pos.y) > halfSize.y) {
        gl_FragColor = vec4(0.0,0.0,0.0,0.0);
    } else {
        gl_FragColor = flixel_texture2D(iChannel0, uv);
    }
}
