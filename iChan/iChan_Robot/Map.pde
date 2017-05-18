//地図を表示するクラス


class Map {



  PImage mapImage;

  String [] Latitude = new String [15]; //緯度
  String [] Longitude = new String [15]; // 経度
  int temp;
  int mode=0;

  Map() {
    init();
  }

  void init() {

    String [] lines = loadStrings("map.txt");
    for (int i=0; i<15; i++) {
      Latitude[i]=lines[i*2];
      Longitude[i]=lines[i*2+1];
    }
    temp=(int)random(0, 15);
    String baseURL = "http://map.olp.yahooapis.jp/OpenLocalPlatform/V1/static?";
    String option = "appid=dj0zaiZpPUo1clFuVEpqcGhRRSZzPWNvbnN1bWVyc2VjcmV0Jng9Y2M-";
    option += "&lat="+Latitude[temp]+"&lon="+Longitude[temp]+"&z=18&width=480&height=640&pointer=on";
    mapImage = loadImage( baseURL + option, "png" );
  }  

  void draw() {
    

   if (select.ichan==1) {
     background(255);
      image( mapImage, 0, 0, 480, 640);
      player7.play();
    } else if (select.ichan==2) {
      background(255);
      image( mapImage, 0, 0, 480, 640);
    } else if (select.ichan==3) {
      background(255);
      image( mapImage, 0, 0, 480, 640);
      player15.play();
    }
  }
}

