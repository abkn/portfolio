precision highp float;
attribute vec3  position;
attribute vec2  uv;
uniform   vec2  resolution;
varying   vec2  fragCoord;

void main(){
    gl_Position = vec4(position, 1.0);
    fragCoord = uv * resolution;
}
