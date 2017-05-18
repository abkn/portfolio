//penlight.pde
//draw penlight
//2014/7/21


//変数の準備
int [][] backLight = new int [12][5];
int col=0;
float colPr=0;
float colPg=0;
float colPb=0;
float colMr=0;
float colMg=0;
float colMb=0;
int lightCol=1;
int lightAct=0;

//ウィンドウの大きさの設定
void setup(){
  size(1200,600);
  
//配列backlight[backX][backY]に繰り返しを用いてランダムに5個の値を振る
   int backX=0;
  while(backX<12){
    int backY=0;
    while(backY<5){
      backLight[backX][backY]=(int)random(5);
      backY++;
    }
    backX++;
  }
}

//描画
void draw(){
  background(0);
  backLight();
  drawPenlight();
}

//背景のペンライトの海を描画する関数
void backLight(){
  //角度の設定
  float angle = atan2( height-mouseY, mouseX-width/2 );
  //backLight[backX][backY]の値によって色指定
  int backX=0;
  while(backX<12){
    int backY=0;
    while(backY<5){
      if(backLight[backX][backY]==0){
        stroke(0,255,0);
      }else if(backLight[backX][backY]==1){
        stroke(250,5,140);
      }else if(backLight[backX][backY]==2){
        stroke(255,0,0);
      }else if(backLight[backX][backY]==3){
        stroke(255,255,0);
      }else if(backLight[backX][backY]==4){
        stroke(55,10,100);
      }
      line(50+backX*100,height-backY*125,backX*100+50+50*cos(angle),
             height-backY*125-50*sin(angle));
      backY++;
    }
    backX++;
    backY=0;
  }
}

//ペンライトを描画する関数
void drawPenlight(){
//角度の設定
  float angle = atan2( height-mouseY, mouseX-width/2 );
  stroke(255);
  strokeWeight(5);
  fill(255);
//持ち手の部分の描画
  quad(width/2+25*cos((angle)+radians(90)),
        height-25*sin((angle)+radians(90)),
 
      width/2+125*cos(angle)+25*cos((angle)+radians(90)),
        height-125*sin(angle)-25*sin((angle)+radians(90)),
        
      width/2+125*cos(angle)+25*cos((angle)+radians(-90)),
        height-125*sin(angle)-25*sin((angle)+radians(-90)),
        
      width/2+25*cos((angle)+radians(-90)),
        height-25*sin((angle)+radians(-90)));

 quad(width/2+125*cos(angle)+75*cos((angle)+radians(90)),
        height-125*sin(angle)-75*sin((angle)+radians(90)),
        
      width/2+200*cos(angle)+75*cos((angle)+radians(90)),
        height-200*sin(angle)-75*sin((angle)+radians(90)),
        
      width/2+200*cos(angle)+75*cos((angle)+radians(-90)),
        height-200*sin(angle)-75*sin((angle)+radians(-90)),
        
      width/2+125*cos(angle)+75*cos((angle)+radians(-90)),
        height-125*sin(angle)-75*sin((angle)+radians(-90)));
        
 strokeWeight(1);
 stroke(0);
 
//赤、緑、黄色の点滅処理　　
 col=col+3;
 if(col>255){
  col=0;
}

//ピンクの点滅処理
  colPr=colPr+2.94;
  if(colPr>250){
    colPr=0;
  }
  
  colPg=colPg+0.0588;
  if(colPg>5){
    colPg=0;
  }
  
  colPb=colPb+1.647;
  if(colPb>140){
    colPb=0;
  }
  
//紫の点滅処理
  colMr=colMr+0.647;
  if(colMr>55){
    colMr=0;
  }
  
  colMg=colMg+0.117647;
  if(colMg>10){
    colMg=0;
  }
  
  colMb=colMb+1.17647;
  if(colMb>100){
    colMb=0;
  }
 
//lightActとlightColの値によってペンライトの反応と色の条件分岐の処理
 if(lightAct==0){
   fill(0);
 }else if(lightAct==1 && lightCol==1){
   fill(255,0,0);
 }else if(lightAct==2 && lightCol==1){
   fill(col,0,0);
  }else if(lightAct==1 && lightCol==2){
   fill(255,255,0);
 }else if(lightAct==2 && lightCol==2){
   fill(col,col,0);
  }else if(lightAct==1 && lightCol==3){
   fill(250,5,140);
 }else if(lightAct==2 && lightCol==3){
   fill(colPr,colPg,colPb);
  }else if(lightAct==1 && lightCol==4){
   fill(0,255,0);
 }else if(lightAct==2 && lightCol==4){
   fill(0,col,0);
 }else if(lightAct==1 && lightCol==5){
   fill(55,10,100);
 }else if(lightAct==2 && lightCol==5){
   fill(colMr,colMg,colMb);
 }
 
//発光部分の描画
 quad(width/2+200*cos(angle)+50*cos((angle)+radians(90)),
        height-200*sin(angle)-50*sin((angle)+radians(90)),
        
      width/2+600*cos(angle)+50*cos((angle)+radians(90)),
        height-600*sin(angle)-50*sin((angle)+radians(90)),
        
      width/2+600*cos(angle)+50*cos((angle)+radians(-90)),
        height-600*sin(angle)-50*sin((angle)+radians(-90)),
        
      width/2+200*cos(angle)+50*cos((angle)+radians(-90)),
        height-200*sin(angle)-50*sin((angle)+radians(-90)));
 
//スイッチボタンの描画
 fill(255);
 strokeWeight(5);
      ellipse( width/2+100*cos(angle),height-100*sin(angle),30,30);
//持ち手の丸部分の描画
stroke(255);
      ellipse(width/2,height,75,75);
}

//マウス操作に対する処理
//持ち手の部分のスイッチボタンを押すことで電源オン→点滅を起こすことができる
void mousePressed(){
   float angle = atan2( height-mouseY, mouseX-width/2 );
  if(dist(width/2+100*cos(angle),height-100*sin(angle),mouseX,mouseY)<15){
    lightAct++;
  }
  if((dist(width/2+100*cos(angle),height-100*sin(angle),mouseX,mouseY)<15)
  && lightAct==3){
    lightAct=0;
  }
}

//キーボードに対する処理
//左右キーでライトの色を変えられる
void keyPressed(){
 
    switch(keyCode){
      case RIGHT:
      lightCol++;
      if(lightCol==6){
        lightCol=1;
      }
      break;
      
      case LEFT:
      lightCol--;
      if(lightCol==0){
        lightCol=5;
      }
      break;
      
//上キーで背景のペンライトの海の色を変えられる
     case UP:
     int backX=0;
     while(backX<12){
       int backY=0;
       while(backY<5){
         backLight[backX][backY]=(int)random(5);
         backY++;
         }
         backX++;
         }
         break;
    }
}