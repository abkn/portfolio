import processing.serial.*;
Serial myPort; //シリアルポート

float in0;//手のひら（地図）
float in1;//二の腕（だめよだめだめ）
float in2;//頭（天気）
float in3;//ほっぺ （おこ）

import ddf.minim.*;


Minim minim;

AudioPlayer player1;//おてんばあいさつ
AudioPlayer player2;//おてんば雨
AudioPlayer player3;//おてんば晴れ
AudioPlayer player4;//おてんば雪
AudioPlayer player5;//おてんば曇り
AudioPlayer player6;//おてんばだめよーだめだめ
AudioPlayer player7;//おてんばここに行きたいな
AudioPlayer player8;//おてんば触らないで

AudioPlayer player9;//アメリカンあいさつ
AudioPlayer player10;//アメリカン晴れ
AudioPlayer player11;//アメリカン雨
AudioPlayer player12;//アメリカン曇り
AudioPlayer player13;//アメリカン雪
AudioPlayer player14;//アメリカンだめよーだめだめ
AudioPlayer player15;//アメリカンLet's go with me here!!
AudioPlayer player16;//アメリカンDon't touch me!!


PFont moji;

Map map;
Weather weather;
Select select;
iChan ichan;


void setup() {
  size(480, 640);
  moji=loadFont("Reishoreiryu-48.vlw");
  textFont(moji);
 
  // ポート番号とスピードを指定してシリアルポートをオープン
  myPort = new Serial(this, Serial.list()[0], 9600);
  // 改行コード(\n)が受信されるまで、シリアルメッセージを受けつづける
  myPort.bufferUntil('\n');
 
  minim= new Minim(this);
 player1=minim.loadFile("ichan1_1.wav");
 player2=minim.loadFile("ichan1_2.wav");
 player3=minim.loadFile("ichan1_3.wav");
 player4=minim.loadFile("ichan1_4.wav");
 player5=minim.loadFile("ichan1_5.wav");
 player6=minim.loadFile("ichan1_6.wav");
 player7=minim.loadFile("ichan1_7.wav");
 player8=minim.loadFile("ichan1_8.wav");
 player9=minim.loadFile("ichan2_1.wav");
 player10=minim.loadFile("ichan2_2.wav");
 player11=minim.loadFile("ichan2_3.wav");
 player12=minim.loadFile("ichan2_4.wav");
 player13=minim.loadFile("ichan2_5.wav");
 player14=minim.loadFile("ichan2_6.wav");
 player15=minim.loadFile("ichan2_7.wav");
 player16=minim.loadFile("ichan2_8.wav");
 
  map=new Map();
  weather=new Weather();
  select = new Select();
  ichan=new iChan();
}


void draw() {
  if(in0<300 && in2<300){
    background(0);
    select.draw();
    ichan.draw();
  }
    
  if(in0>300){
    weather.draw();
  }
  if(in2>300){
    map.draw();
  }
  if(in0>300 && in1>300 && in2>300 && in3>300){
    select.draw();
    ichan.draw();
  }
  if((keyPressed==true)&&(key=='a')){
      background(0);
      select.ichan=0;
      select.draw();
    }
}


void mousePressed() {
  select.mouseclicked();
}

void serialEvent(Serial myPort) { 
  // シリアルバッファーを読込み
  String myString = myPort.readStringUntil('\n');
  // 空白文字など余計な情報を消去
  myString = trim(myString);
  // コンマ区切りで複数の情報を読み込む
  int sensors[] = int(split(myString, ','));
  // 読み込んだ情報の数だけ、配列に格納
  if (sensors.length > 3) {
    in0 = sensors[0];
    in1 = sensors[1];
    in2 = sensors[2];
    in3 = sensors[3];
  }
  // 読込みが完了したら、次の情報を要求
  myPort.write("A");
}



