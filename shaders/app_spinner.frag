#version 460 core

#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;
uniform vec4 uColor;

out vec4 fragColor;

/**
 * Netflix-style Spinner Shader
 * Tworzy plynny, kometowy obrot z wykorzystaniem gradientu katowego.
 */
void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec2 center = vec2(0.5, 0.5);
    vec2 p = uv - center;
    
    // Obliczamy odleglosc od srodka (promien)
    float r = length(p);
    
    // Grubosc pierscienia (0.4 - 0.5 to zewnetrzny obwod)
    float ringInner = 0.38;
    float ringOuter = 0.48;
    
    // Antialiasing krawedzi pierscienia
    float dist = abs(r - (ringInner + ringOuter) * 0.5);
    float edgeWidth = 0.01;
    float mask = 1.0 - smoothstep((ringOuter - ringInner) * 0.5 - edgeWidth, (ringOuter - ringInner) * 0.5 + edgeWidth, dist);
    
    // Kat w zakresie [0, 1]
    float angle = atan(p.y, p.x) / (2.0 * 3.14159265) + 0.5;
    
    // Animacja rotacji
    float rotation = fract(uTime * 0.8);
    float cometAngle = fract(angle - rotation);
    
    // Efekt komety: wygaszanie ogona
    // Uzywamy potegi, aby ogon byl bardziej "ostry" lub "miekkie" przy koncu
    float intensity = pow(cometAngle, 2.5);
    
    // Przerwa w obreczu (gap) - typowe dla nowoczesnych spinnerow
    float gap = smoothstep(0.0, 0.1, cometAngle);
    
    fragColor = uColor * intensity * mask * gap;
}
