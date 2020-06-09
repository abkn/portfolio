precision mediump float;
uniform float lightIntensity; // 光の強さ
uniform vec3  globalColor;    // パーティクルの色

varying float vAlpha;         // 頂点シェーダから送られてきたアルファ値

void main(){
    vec2 coord = gl_PointCoord.st * 2.0 - 1.0;
    // 光の強さをベクトルの長さで割る
    float f = lightIntensity / length(coord);
    f = pow(f, 2.0);
    // アルファに対しても除算の結果をそのまま代入する
    gl_FragColor = vec4(globalColor, vAlpha) * vec4(min(f, 1.0));
}

