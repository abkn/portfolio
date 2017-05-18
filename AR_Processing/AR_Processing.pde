import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker ar;
int x = 0;
PImage img;
PImage imgOut;
int id = 0;

void setup() {
  size( 960, 540, P3D);
  cam = new Capture(this, width, height,"Logitech Webcam C930e");
  cam.start();
  ar = new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG );
  ar.addARMarker("patt.hiro", 80);
  ar.addARMarker("red.pat", 67);
  ar.addARMarker("green.pat", 67);
  ar.addARMarker("blue.pat", 67);
  ar.addARMarker("double.pat", 67);
  ar.addARMarker("reverse.pat", 67);
     
  
  img = loadImage("photo.jpeg");
  imgOut = new PImage(img.width, img.height);
  
}
void draw() {
  

 
  if ( !cam.available() ) return;
  background(0);
  cam.read();
  ar.detect(cam);
  ar.drawBackground(cam);
  if( ar.isExist(0) && !ar.isExist(1) && !ar.isExist(2) && !ar.isExist(3) && !ar.isExist(4) && !ar.isExist(5) ) { //画像のみ
    
    ar.beginTransform(0);
    rotate(PI);
    translate(-50,-50,0);
    image(img,0,0);
    
    ar.endTransform();
  } else if ( ar.isExist(0) && ar.isExist(1) && !ar.isExist(2) && !ar.isExist(3) && !ar.isExist(4) && !ar.isExist(5) ) { //画像と
  
    // マーカの位置姿勢を表わす行列を取得
    PMatrix3D C1 = ar.getMatrix(1);
  

    // カメラ座標系からみたときの、マーカのXYZ軸を表わす方向ベクトル
    PVector vec_x = new PVector( C1.m00, C1.m10, C1.m20 );  // X軸の方向ベクトル（単位ベクトル）
  
    
    // マーカを正面に向けた時のZ軸の回転量を計算
    PVector base = new PVector( -1, 0, 0 ); // 基準となる方向ベクトル
    
    float dot = vec_x.x * base.x + vec_x.y * base.y;
    float det = vec_x.x * base.y - vec_x.y * base.x;
    
    float angle = atan2(-det, dot);    
  
    
    if ( angle< 0 ) {
      angle = 2*PI + angle;
    }
   
    //println( "angle = " +  angle*(255/19*PI) );
    
    ar.beginTransform(0); //ここからマーカ座標系（画像)）
    
    rotate(PI);
    translate(-50,-50,0);
  
    //image(img,0,0);
    img.loadPixels();
    
    for(int y = 0; y < img.height; y++ ){
      for(int x = 0; x < img.width; x++ ){
        color c = img.get(x,y);
        color out_color = color( angle*(255/19*PI), green(c), blue(c) );
         imgOut.set( x, y, out_color);
        
      }
    }
    
    image(imgOut,0,0);
  
    ar.endTransform();

    ar.beginTransform(1);  // ここからマーカ座標系（円）
    
    // 角度を表示
    fill(255, 0, 0);
    rotate(PI/2);
    scale(1,-1);
    arc( 0, 0, 50, 50, 0,  angle  , PIE);

    ar.endTransform();
    
  } else if ( ar.isExist(0)  && !ar.isExist(1) && ar.isExist(2)  && !ar.isExist(3) && !ar.isExist(5) && !ar.isExist(5) ) { //画像と
  
    // マーカの位置姿勢を表わす行列を取得
      PMatrix3D C2 = ar.getMatrix(2);

    // カメラ座標系からみたときの、マーカのXYZ軸を表わす方向ベクトル
  
    PVector vec_x2 = new PVector( C2.m00, C2.m10, C2.m20 );  // X軸の方向ベクトル（単位ベクトル)
    
    // マーカを正面に向けた時のZ軸の回転量を計算
    PVector base = new PVector( -1, 0, 0 ); // 基準となる方向ベクトル
  
    float dot2 = vec_x2.x * base.x + vec_x2.y * base.y;
    float det2 = vec_x2.x * base.y - vec_x2.y * base.x;
    
      float angle2 = atan2(-det2, dot2);
   
    if ( angle2< 0 ) {
      angle2 = 2*PI + angle2;
    }
   
    //println( "angle = " +  angle2*(255/19*PI) );

    ar.beginTransform(0); //ここからマーカ座標系（画像)）
    
    rotate(PI);
    translate(-50,-50,0);
  
    //image(img,0,0);
    img.loadPixels();
    
    for(int y = 0; y < img.height; y++ ){
      for(int x = 0; x < img.width; x++ ){
        color c = img.get(x,y);
        color out_color = color( red(c),angle2*(255/19*PI) , blue(c) );
         imgOut.set( x, y, out_color);
        
      }
    }
    
    image(imgOut,0,0);
  
    ar.endTransform();

    ar.beginTransform(2);  // ここからマーカ座標系（円）
    
    // 角度を表示
    fill(0, 255, 0);
    rotate(PI/2);
    scale(1,-1);
    arc( 0, 0, 50, 50, 0, angle2, PIE);

    ar.endTransform();
  } else if ( ar.isExist(0)  && !ar.isExist(1)  && !ar.isExist(2) && ar.isExist(3) && !ar.isExist(4) && !ar.isExist(5) ) { //画像と
  
    // マーカの位置姿勢を表わす行列を取得
    PMatrix3D C3 = ar.getMatrix(3);
 
    // カメラ座標系からみたときの、マーカのXYZ軸を表わす方向ベクトル
    PVector vec_x3 = new PVector( C3.m00, C3.m10, C3.m20 );  // X軸の方向ベクトル（単位ベクトル）
    
    // マーカを正面に向けた時のZ軸の回転量を計算
    PVector base = new PVector( -1, 0, 0 ); // 基準となる方向ベクトル
    
    float dot3 = vec_x3.x * base.x + vec_x3.y * base.y;
    float det3 = vec_x3.x * base.y - vec_x3.y * base.x;
    
    float angle3 = atan2(-det3, dot3);
   
    if ( angle3< 0 ) {
      angle3 = 2*PI + angle3;
    }
 
    //println( "angle = " +  angle3*(255/19*PI) );

    ar.beginTransform(0); //ここからマーカ座標系（画像)）
    
    rotate(PI);
    translate(-50,-50,0);
  
    //image(img,0,0);
    img.loadPixels();
    
    for(int y = 0; y < img.height; y++ ){
      for(int x = 0; x < img.width; x++ ){
        color c = img.get(x,y);
        color out_color = color( red(c), green(c), angle3*(255/19*PI) );
         imgOut.set( x, y, out_color);
        
      }
    }
    
    image(imgOut,0,0);
  
    ar.endTransform();

    ar.beginTransform(3);  // ここからマーカ座標系（円）
    
    // 角度を表示
    fill(0, 0, 255);
    rotate(PI/2);
    scale(1,-1);
    arc( 0, 0, 50, 50, 0, angle3, PIE);

    ar.endTransform();
    
    //ここまでマーカー２つ
    //ここからマーカーが３つの処理
    
  } else if ( ar.isExist(0) && ar.isExist(1) && ar.isExist(2)  && !ar.isExist(3) && !ar.isExist(4) && !ar.isExist(5) ) { //画像と
  
    // マーカの位置姿勢を表わす行列を取得
    PMatrix3D C1 = ar.getMatrix(1);
    PMatrix3D C2 = ar.getMatrix(2);

    // カメラ座標系からみたときの、マーカのXYZ軸を表わす方向ベクトル
    PVector vec_x = new PVector( C1.m00, C1.m10, C1.m20 );  // X軸の方向ベクトル（単位ベクトル）
    PVector vec_x2 = new PVector( C2.m00, C2.m10, C2.m20 );  // X軸の方向ベクトル（単位ベクトル）
  
    
    // マーカを正面に向けた時のZ軸の回転量を計算
    PVector base = new PVector( -1, 0, 0 ); // 基準となる方向ベクトル
    
    float dot = vec_x.x * base.x + vec_x.y * base.y;
    float det = vec_x.x * base.y - vec_x.y * base.x;
    
    float dot2 = vec_x2.x * base.x + vec_x2.y * base.y;
    float det2 = vec_x2.x * base.y - vec_x2.y * base.x;
    
    float angle1 = atan2(-det, dot);    
    float angle2 = atan2(-det2, dot2);
    
    if ( angle1< 0 ) {
      angle1 = 2*PI + angle1;
    }
    
    if ( angle2< 0 ) {
      angle2 = 2*PI + angle2;
    }
 
    //println( "angle = " +  angle1*(255/19*PI)  );

    ar.beginTransform(0); //ここからマーカ座標系（画像)）
    
    rotate(PI);
    translate(-50,-50,0);
  
    //image(img,0,0);
    img.loadPixels();
    
    for(int y = 0; y < img.height; y++ ){
      for(int x = 0; x < img.width; x++ ){
        color c = img.get(x,y);
        color out_color = color( angle1*(255/19*PI), angle2*(255/19*PI), blue(c) );
         imgOut.set( x, y, out_color);
        
      }
    }
    
    image(imgOut,0,0);
  
    ar.endTransform();

    ar.beginTransform(1);  // ここからマーカ座標系（円）
    
    // 角度を表示
    fill(255, 0, 0);
    rotate(PI/2);
    scale(1,-1);
    arc( 0, 0, 50, 50, 0, angle1, PIE);

    ar.endTransform();
    
    ar.beginTransform(2);  // ここからマーカ座標系（円）
    
    // 角度を表示
    fill(0, 255, 0);
    rotate(PI/2);
    scale(1,-1);
    arc( 0, 0, 50, 50, 0, angle2, PIE);

    ar.endTransform();
    
  } else if ( ar.isExist(0) && ar.isExist(1) && !ar.isExist(2) && ar.isExist(3) && !ar.isExist(4) && !ar.isExist(5) ) { //画像と
  
    // マーカの位置姿勢を表わす行列を取得
    PMatrix3D C1 = ar.getMatrix(1);
    PMatrix3D C3 = ar.getMatrix(3);
 
    // カメラ座標系からみたときの、マーカのXYZ軸を表わす方向ベクトル
    PVector vec_x = new PVector( C1.m00, C1.m10, C1.m20 );  // X軸の方向ベクトル（単位ベクトル）
    PVector vec_x3 = new PVector( C3.m00, C3.m10, C3.m20 );  // X軸の方向ベクトル（単位ベクトル）
   
    // マーカを正面に向けた時のZ軸の回転量を計算
    PVector base = new PVector( -1, 0, 0 ); // 基準となる方向ベクトル
    
    float dot = vec_x.x * base.x + vec_x.y * base.y;
    float det = vec_x.x * base.y - vec_x.y * base.x;
 
    float dot3 = vec_x3.x * base.x + vec_x3.y * base.y;
    float det3 = vec_x3.x * base.y - vec_x3.y * base.x;
    
    float angle1 = atan2(-det, dot);    
    float angle3 = atan2(-det3, dot3);
    
    if ( angle1< 0 ) {
      angle1 = 2*PI + angle1;
    }

    if ( angle3< 0 ) {
      angle3 = 2*PI + angle3;
    }
 
    //println( "angle = " +  angle1*(255/19*PI) );

    ar.beginTransform(0); //ここからマーカ座標系（画像)）
    
    rotate(PI);
    translate(-50,-50,0);

    img.loadPixels();
    
    for(int y = 0; y < img.height; y++ ){
      for(int x = 0; x < img.width; x++ ){
        color c = img.get(x,y);
        color out_color = color( angle1*(255/19*PI), green(c), angle3*(255/19*PI) );
         imgOut.set( x, y, out_color);
        
      }
    }
    
    image(imgOut,0,0);
  
    ar.endTransform();

    ar.beginTransform(1);  // ここからマーカ座標系（円）
    
    // 角度を表示
    fill(255, 0, 0);
    rotate(PI/2);
    scale(1,-1);
    arc( 0, 0, 50, 50, 0, angle1, PIE);

    ar.endTransform();
    
    ar.beginTransform(3);  // ここからマーカ座標系（円）
    
    // 角度を表示
    fill(0, 0, 255);
    rotate(PI/2);
    scale(1,-1);
    arc( 0, 0, 50, 50, 0, angle3, PIE);

    ar.endTransform();
    
  } else if ( ar.isExist(0) && !ar.isExist(1) && ar.isExist(2) && ar.isExist(3) && !ar.isExist(4) && !ar.isExist(5) ) { //画像と
  
    // マーカの位置姿勢を表わす行列を取得
    PMatrix3D C2 = ar.getMatrix(2);
    PMatrix3D C3 = ar.getMatrix(3);
 
    // カメラ座標系からみたときの、マーカのXYZ軸を表わす方向ベクトル
    PVector vec_x2 = new PVector( C2.m00, C2.m10, C2.m20 );  // X軸の方向ベクトル（単位ベクトル）
    PVector vec_x3 = new PVector( C3.m00, C3.m10, C3.m20 );  // X軸の方向ベクトル（単位ベクトル）
  
    // マーカを正面に向けた時のZ軸の回転量を計算
    PVector base = new PVector( -1, 0, 0 ); // 基準となる方向ベクトル
    
    float dot2 = vec_x2.x * base.x + vec_x2.y * base.y;
    float det2 = vec_x2.x * base.y - vec_x2.y * base.x;
    
    float dot3 = vec_x3.x * base.x + vec_x3.y * base.y;
    float det3 = vec_x3.x * base.y - vec_x3.y * base.x;
    
    float angle2 = atan2(-det2, dot2);
    float angle3 = atan2(-det3, dot3);
    
    if ( angle2< 0 ) {
      angle2 = 2*PI + angle2;
    }
    
    if ( angle3< 0 ) {
      angle3 = 2*PI + angle3;
    }
   
    //println( "angle = " +  angle2*(255/19*PI) );

    ar.beginTransform(0); //ここからマーカ座標系（画像)）
    
    rotate(PI);
    translate(-50,-50,0);
  
    img.loadPixels();
    
    for(int y = 0; y < img.height; y++ ){
      for(int x = 0; x < img.width; x++ ){
        color c = img.get(x,y);
        color out_color = color( red(c), angle2*(255/19*PI), angle3*(255/19*PI) );
         imgOut.set( x, y, out_color);
        
      }
    }
    
    image(imgOut,0,0);
  
    ar.endTransform();

    ar.beginTransform(2);  // ここからマーカ座標系（円）
    
    // 角度を表示
    fill(0, 255, 0);
    rotate(PI/2);
    scale(1,-1);
    arc( 0, 0, 50, 50, 0, angle2, PIE);

    ar.endTransform();
    
    ar.beginTransform(3);  // ここからマーカ座標系（円）
    
    // 角度を表示
    fill(0, 0, 255);
    rotate(PI/2);
    scale(1,-1);
    arc( 0, 0, 50, 50, 0, angle3, PIE);

    ar.endTransform();
    
    //ここから二値化、画素反転の処理
    
    
  }  else if ( ar.isExist(0) && !ar.isExist(1) && !ar.isExist(2) && !ar.isExist(3) && ar.isExist(4) && !ar.isExist(5) ) { //画像と
  
    // マーカの位置姿勢を表わす行列を取得
    PMatrix3D C4 = ar.getMatrix(4);

    // カメラ座標系からみたときの、マーカのXYZ軸を表わす方向ベクトル
    PVector vec_x4 = new PVector( C4.m00, C4.m10, C4.m20 );  // X軸の方向ベクトル（単位ベクトル）
    
    // マーカを正面に向けた時のZ軸の回転量を計算
    PVector base = new PVector( -1, 0, 0 ); // 基準となる方向ベクトル
 
    float dot4 = vec_x4.x * base.x + vec_x4.y * base.y;
    float det4 = vec_x4.x * base.y - vec_x4.y * base.x;
  
    float angle4 = atan2(-det4, dot4);
    
    if ( angle4< 0 ) {
      angle4 = 2*PI + angle4;
    }
   
    //println( "angle = " +  angle4*(255/19*PI) );

    ar.beginTransform(0); //ここからマーカ座標系（画像)）
    
    rotate(PI);
    translate(-50,-50,0);

    img.loadPixels();
    
    for(int y = 0; y < img.height; y++ ){
      for(int x = 0; x < img.width; x++ ){
        color c = img.get(x,y);
        
        int r = int(red(c));
        int g = int(green(c));
        int b = int(blue(c));    
        
        if((r + g + b)/3 >= angle4*(255/19*PI)){
          r = 255; g = 255; b = 255;  //白にする
        }else{
          r = 0; g = 0; b = 0;  //それ以外は黒にする        
        }
         
        //ウィンドウのピクセルの色を決定
        color out_color = color(r, g, b);
        imgOut.set( x, y, out_color );
      }
    }
    updatePixels();
    image(imgOut,0,0);
  
    ar.endTransform();

    ar.beginTransform(4);  // ここからマーカ座標系（円）
    
    // 角度を表示
    fill(0, 0, 0);
    rotate(PI/2);
    scale(1,-1);
    arc( 0, 0, 50, 50, 0, angle4, PIE);

    ar.endTransform();
  }  else if ( ar.isExist(0) && !ar.isExist(1) && !ar.isExist(2) && !ar.isExist(3) && !ar.isExist(4) && ar.isExist(5) ) { //画像と
  
    // マーカの位置姿勢を表わす行列を取得
    PMatrix3D C5 = ar.getMatrix(5);

    // カメラ座標系からみたときの、マーカのXYZ軸を表わす方向ベクトル
     PVector vec_x5 = new PVector( C5.m00, C5.m10, C5.m20 );  // X軸の方向ベクトル（単位ベクトル）
    
    // マーカを正面に向けた時のZ軸の回転量を計算
    PVector base = new PVector( -1, 0, 0 ); // 基準となる方向ベクトル
    
    float dot5 = vec_x5.x * base.x + vec_x5.y * base.y;
    float det5 = vec_x5.x * base.y - vec_x5.y * base.x;
    
    float angle5 = atan2(-det5, dot5);
    
     if ( angle5< 0 ) {
      angle5 = 2*PI + angle5;
    }
   
   // println( "angle = " +  angle5*(255/19*PI) );

    ar.beginTransform(0); //ここからマーカ座標系（画像)）
    
    rotate(PI);
    translate(-50,-50,0);
  
    //image(img,0,0);
    img.loadPixels();
    
    for(int y = 0; y < img.height; y++ ){
      for(int x = 0; x < img.width; x++ ){
        color c = img.get(x,y);
        
        int r = int(red(c));
        int g = int(green(c));
        int b = int(blue(c));    
        
        r = int(angle5*(255/19*PI)) - r;
        g = int(angle5*(255/19*PI)) - g;
        b = int(angle5*(255/19*PI)) - b;
         
        //ウィンドウのピクセルの色を決定
        color out_color = color(r, g, b);
        imgOut.set( x, y, out_color );
      }
    }
    updatePixels();
    image(imgOut,0,0);
 
    ar.endTransform();

    ar.beginTransform(5);  // ここからマーカ座標系（円）
    
    // 角度を表示
    fill(255);
    rotate(PI/2);
    scale(1,-1);
    arc( 0, 0, 50, 50, 0, angle5, PIE);

    ar.endTransform();
  }
}