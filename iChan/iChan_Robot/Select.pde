//セレクト画面のクラス

class Select {



  int ichan=0; //ichan=1はおてんば愛ちゃん、ichan=2はおいろけ愛ちゃん、ichan=3はアメリカン愛ちゃん

  PImage ichan1_1; //おてんば愛ちゃん　笑顔
  PImage ichan1_2; //おてんば愛ちゃん　怒り顔
  PImage ichan2_1; //お色気愛ちゃん　笑顔
  PImage ichan2_2; //お色気愛ちゃん　怒り顔
  PImage ichan3_1; //アメリカン愛ちゃん　笑顔
  PImage ichan3_2; //アメリカン愛ちゃん　怒り顔 

  Select() {
    init();
  }

  void init() {

    ichan1_1 = loadImage("ichan1_1.png");
    ichan1_2 = loadImage("ichan1_2.png");
    ichan2_1 = loadImage("ichan2_1.png");
    ichan2_2 = loadImage("ichan2_2.png");
    ichan3_1 = loadImage("ichan3_1.png");
    ichan3_2 = loadImage("ichan3_2.png");
  }

  void draw() {
    //セレクト画面
    fill(255, 149, 254);
    textSize(37);
    text("どのあいちゃんにするぅ??", 20, 100);
    text("きょうは...", 25, 500);
    image(ichan1_1, 30, 200, 120, 160);
    image(ichan2_1, 180, 200, 120, 160);
    image(ichan3_1, 330, 200, 120, 160);


    if (mouseX>=30&&mouseX<=150&&mouseY>=200&&mouseY<=360) {
      strokeWeight(10);
      stroke(255, 0, 0);
      image(ichan1_1, 30, 200, 120, 160);
      noFill();
      rect(30, 200, 120, 160);
      fill(255, 255, 0);
      text("おてんばあいちゃん!!", 50, 550);
      fill(255, 255, 0);
      text("やっほー!!", 20, 180);
      player1.play();
    } else if (mouseX>=180&&mouseX<=300&&mouseY>=200&&mouseY<=360) {
      strokeWeight(10);
      stroke(255, 0, 0);
      image(ichan2_1, 180, 200, 120, 160);
      noFill();
      rect(180, 200, 120, 160);
      fill(255, 0, 0);
      text("おいろけあいちゃん!!", 60, 550);
      fill(255, 0, 0);
      text("うふんっっ!!", 140, 180);
    } else if (mouseX>=330&&mouseX<=450&&mouseY>=200&&mouseY<=360) {
      strokeWeight(10);
      stroke(255, 0, 0);
      image(ichan3_1, 330, 200, 120, 160);
      noFill();
      rect(330, 200, 120, 160);
      fill(0, 0, 255);
      text("あめりかんあいちゃん!!", 50, 550);
      fill(0, 0, 255);
      text("Hello!!", 330, 180);
      player9.play();
    }
  }

  void mouseclicked() {
    if (mouseX>=30&&mouseX<=150&&mouseY>=200&&mouseY<=360) {
      ichan=1;
    } else if (mouseX>=180&&mouseX<=300&&mouseY>=200&&mouseY<=360) {
      ichan=2;
    } else if (mouseX>=330&&mouseX<=450&&mouseY>=200&&mouseY<=360) {
      ichan=3;
    }
  }
}

