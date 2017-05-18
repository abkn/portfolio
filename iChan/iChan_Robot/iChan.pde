//愛ちゃんのクラス

class iChan {


  PImage ichan1_1; //元気っ子愛ちゃん　笑顔
  PImage ichan1_2; //元気っ子愛ちゃん　怒り顔
  PImage ichan2_1; //お色気愛ちゃん　笑顔
  PImage ichan2_2; //お色気愛ちゃん　怒り顔
  PImage ichan3_1; //アメリカン愛ちゃん　笑顔
  PImage ichan3_2; //アメリカン愛ちゃん　怒り顔
  PImage dameyo; // だめよだめだめ

  iChan() {

    init();
  }

  void init() {


    ichan1_1 = loadImage("ichan1_1.png");
    ichan1_2 = loadImage("ichan1_2.png");
    ichan2_1 = loadImage("ichan2_1.png");
    ichan2_2 = loadImage("ichan2_2.png");
    ichan3_1 = loadImage("ichan3_1.png");
    ichan3_2 = loadImage("ichan3_2.png");
    dameyo = loadImage("dameyo.png");
  }

  void draw() {

    if (select.ichan==1 && in1<300 && in3<300) {
      image(ichan1_1, 0, 0, 480, 640);
    } else if (select.ichan==2 && in1<300 && in3<300) {
      image(ichan2_1, 0, 0, 480, 640);
    } else if (select.ichan==3 && in1<300 && in3<300) {
      image(ichan3_1, 0, 0, 480, 640);
    } else if (select.ichan==1 && in3>300 && in1<300) {
      image(ichan1_2, 0, 0, 480, 640);
      player8.play();
    } else if (select.ichan==2 && in3>300 && in1<300) {
      image(ichan2_2, 0, 0, 480, 640);
    } else if (select.ichan==3 && in3>300 && in1<300) {
      image(ichan3_2, 0, 0, 480, 640);
      player16.play();
    } else if (in1>300 && select.ichan!=3) {
      image(dameyo, 0, 0, 480, 640);
      player6.play();
    } else if (in1>300 && select.ichan==3) {
      image(dameyo, 0, 0, 480, 640);
      player14.play();
    }
  }
}

