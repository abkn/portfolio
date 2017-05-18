//お天気が表示されるクラス

class Weather {



  XML xml = loadXML( "http://weather.livedoor.com/forecast/rss/area/130010.xml" );
  XML [] item = xml.getChild("channel").getChildren("item");

  PImage img1; //晴の画像
  PImage img2; //雨の画像
  PImage img3; //曇の画像
  PImage img4; //雪の画像

  int mode=0;

  Weather() {
    init();
  }

  void init() {


    img1 = loadImage("hare.png");
    img2 = loadImage("ame.png");
    img3 = loadImage("kumori.png");
    img4 = loadImage("yuki.png");
  }

  void draw() {
    background(255);
    for ( int i=2; i<3; i++ ) {
      String str = item[i].getChild("description").getContent();

      String tenki=str.substring( str.indexOf("天気は")+3, str.indexOf("天気は")+4 );
      String hare="晴";
      String ame="雨";
      String kumori="曇";
      String yuki="雪";

      if (select.ichan==1) {
        if (tenki.equals(hare)) {
          image(img1, 0, 100, 480, 480);
          player3.play();
        } else if (tenki.equals(ame)) {
          image(img2, 0, 100, 480, 480);
          player2.play();
        } else if (tenki.equals(kumori)) {
          image(img3, 0, 100, 480, 480);
          player5.play();
        } else if (tenki.equals(yuki)) {
          image(img4, 0, 100, 480, 480);
          player4.play();
        }
      } else if (select.ichan==2) {
        if (tenki.equals(hare)) {
          image(img1, 0, 100, 480, 480);
        } else if (tenki.equals(ame)) {
          image(img2, 0, 100, 480, 480);
        } else if (tenki.equals(kumori)) {
          image(img3, 0, 100, 480, 480);
        } else if (tenki.equals(yuki)) {
          image(img4, 0, 100, 480, 480);
        }
      } else if (select.ichan==3) {
        if (tenki.equals(hare)) {
          image(img1, 0, 100, 480, 480);
          player10.play();
        } else if (tenki.equals(ame)) {
          image(img2, 0, 100, 480, 480);
          player11.play();
        } else if (tenki.equals(kumori)) {
          image(img3, 0, 100, 480, 480);
          player12.play();
        } else if (tenki.equals(yuki)) {
          image(img4, 0, 100, 480, 480);
          player13.play();
        }
      }
    }
  }
}

