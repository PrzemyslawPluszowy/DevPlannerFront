#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform float uTime;
uniform vec3 uPrimary;
uniform vec3 uTertiary;
uniform vec3 uSurface;

out vec4 fragColor;

float hash(vec2 p) {
  p = fract(p * vec2(123.34, 456.21));
  p += dot(p, p + 45.32);
  return fract(p.x * p.y);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
  float value = 0.0;
  float amp = 0.5;
  for (int i = 0; i < 4; i++) {
    value += amp * noise(p);
    p *= 2.05;
    amp *= 0.5;
  }
  return value;
}

void main() {
  vec2 uv = FlutterFragCoord().xy / uResolution.xy;
  vec2 centered = (uv - 0.5) * vec2(uResolution.x / uResolution.y, 1.0);

  float t = uTime;
  float domainA = fbm(centered * 1.6 + vec2(t * 0.20, -t * 0.12));
  float domainB = fbm(centered * 1.9 + vec2(-t * 0.16, t * 0.18));
  vec2 warped = centered + vec2(domainA - 0.5, domainB - 0.5) * 0.55;

  float radial = length(warped);
  float band = sin((warped.x * 7.5) + (warped.y * 5.5) - (t * 1.1));
  float ring = smoothstep(0.62, 0.04, abs(radial - 0.34 + band * 0.035));

  float blobA = exp(-dot(warped - vec2(-0.38, -0.22), warped - vec2(-0.38, -0.22)) * 6.8);
  float blobB = exp(-dot(warped - vec2(0.44, 0.30), warped - vec2(0.44, 0.30)) * 7.3);
  float mist = fbm(warped * 2.8 + vec2(t * 0.14, -t * 0.11));

  vec3 base = uSurface;
  vec3 layerA = mix(base, uPrimary, blobA * 0.28 + ring * 0.10);
  vec3 layerB = mix(layerA, uTertiary, blobB * 0.30 + mist * 0.12);
  vec3 finalColor = mix(layerB, base, smoothstep(0.10, 1.25, radial) * 0.34);

  fragColor = vec4(finalColor, 1.0);
}
