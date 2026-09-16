#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uIntensity;
uniform vec3 uHighlight;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;

  float topSheen = exp(-uv.y * 18.0) * (1.0 - smoothstep(0.28, 0.96, uv.x));
  float leftSheen = exp(-uv.x * 20.0) * (1.0 - smoothstep(0.24, 0.86, uv.y));
  float diagonal = exp(-pow((uv.x * 0.58 + uv.y) - 0.3, 2.0) * 22.0);
  diagonal *= 1.0 - smoothstep(0.18, 0.92, length(uv));
  vec2 cornerPoint = (uv - vec2(0.09, 0.08)) * vec2(2.8, 3.6);
  float cornerLens = exp(-dot(cornerPoint, cornerPoint) * 5.0);
  float reflection = clamp(
    topSheen * 0.24 + leftSheen * 0.18 + diagonal * 0.08 + cornerLens * 0.2,
    0.0,
    1.0
  );
  float alpha = reflection * uIntensity;

  fragColor = vec4(uHighlight * alpha, alpha);
}
