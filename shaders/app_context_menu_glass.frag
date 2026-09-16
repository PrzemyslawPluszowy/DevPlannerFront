#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uRefraction;
uniform float uBlurRadius;
uniform vec3 uTint;
uniform float uTintAmount;
uniform float uLightIntensity;
uniform sampler2D uTextureInput;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;

#ifdef IMPELLER_TARGET_OPENGLES
  uv.y = 1.0 - uv.y;
#endif

  float leftEdge = exp(-uv.x * 11.0);
  float rightEdge = exp(-(1.0 - uv.x) * 11.0);
  float topEdge = exp(-uv.y * 11.0);
  float bottomEdge = exp(-(1.0 - uv.y) * 11.0);
  vec2 edgeNormal = vec2(leftEdge - rightEdge, topEdge - bottomEdge);
  vec2 refractedUv = clamp(
    uv + edgeNormal * uRefraction,
    vec2(0.001),
    vec2(0.999)
  );

  float edgeDistance = min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));
  float rim = 1.0 - smoothstep(0.0, 0.16, edgeDistance);

  vec2 pixel = vec2(uBlurRadius) / uSize;
  vec4 sampleColor = texture(uTextureInput, refractedUv) * 0.36;
  sampleColor += texture(uTextureInput, refractedUv + vec2(pixel.x, 0.0)) * 0.12;
  sampleColor += texture(uTextureInput, refractedUv - vec2(pixel.x, 0.0)) * 0.12;
  sampleColor += texture(uTextureInput, refractedUv + vec2(0.0, pixel.y)) * 0.12;
  sampleColor += texture(uTextureInput, refractedUv - vec2(0.0, pixel.y)) * 0.12;
  sampleColor += texture(uTextureInput, refractedUv + pixel) * 0.04;
  sampleColor += texture(uTextureInput, refractedUv - pixel) * 0.04;
  sampleColor += texture(uTextureInput, refractedUv + vec2(pixel.x, -pixel.y)) * 0.04;
  sampleColor += texture(uTextureInput, refractedUv + vec2(-pixel.x, pixel.y)) * 0.04;

  vec2 spectralOffset = edgeNormal * uRefraction * 0.3 * rim;
  vec3 refractedSpectrum = vec3(
    texture(uTextureInput, clamp(refractedUv + spectralOffset, vec2(0.001), vec2(0.999))).r,
    texture(uTextureInput, refractedUv).g,
    texture(uTextureInput, clamp(refractedUv - spectralOffset, vec2(0.001), vec2(0.999))).b
  );
  sampleColor.rgb = mix(sampleColor.rgb, refractedSpectrum, rim * 0.1);

  float directionalLight = (1.0 - uv.x) * (1.0 - uv.y);
  vec2 cornerPoint = (uv - vec2(0.09, 0.08)) * vec2(2.8, 3.6);
  float cornerLens = exp(-dot(cornerPoint, cornerPoint) * 5.0);
  float softLight = (rim * directionalLight * 0.08 + cornerLens * 0.12) * uLightIntensity;
  vec3 tintedColor = mix(
    sampleColor.rgb,
    uTint,
    uTintAmount * (0.72 + rim * 0.28)
  );
  tintedColor += vec3(1.0, 0.985, 0.96) * softLight;

  fragColor = vec4(tintedColor, sampleColor.a);
}
