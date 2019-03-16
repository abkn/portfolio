

import java.util.*;

final int SIZE = 50;
final int STONE_SIZE = (int)(SIZE*0.7);
final int NONE = 0;
final int BLACK = 1;
final int WHITE = 2;

int[][] field;
int[][] fieldValueEval;
boolean black_turn = true;

int stoneID = 0;

void setup() {
  size(400, 400);//8*SIZE,8*SIZE);
  field = new int[8][8];
   initialization();
  
  //autoPlay();  // 黒がコンピュータのとき、ここのコメントを外す
}



void draw() {
  updateEval();

  background(0, 128, 0);

  // lines
  stroke(0);
  for (int i=1; i<8; ++i) {
    line(i*SIZE, 0, i*SIZE, height);
    line(0, i*SIZE, width, i*SIZE);
  }


  // draw stones
  noStroke();
  for (int i=0; i<8; i++) {
    for (int j=0; j<8; j++) {

      if (field[i][j]==BLACK) {
        fill(0);  //color black
        ellipse((i*2+1)*SIZE/2, (j*2+1)*SIZE/2, STONE_SIZE, STONE_SIZE);
      } else if (field[i][j]==WHITE) {
        fill(255); // color white
        ellipse((i*2+1)*SIZE/2, (j*2+1)*SIZE/2, STONE_SIZE, STONE_SIZE);
      }
    }
  }
  
  
  // 置けるフィールド
  puttableField();
}

void mousePressed() {
  if (mouseX<400) {
    int x = mouseX/SIZE;
    int y = mouseY/SIZE;

  println("x="+x+", y="+y);
    // チェック、反転
    
    boolean puttable = canPutHere(x, y);
    println(puttable);//canPutHere(x,y));
    
    if(!puttable) return;
    
    if(field[x][y]==NONE && puttable){
      stoneID++;
      reverseStoneParent(x,y);
    }
    
    black_turn = !black_turn;
    
//    autoPlay();
  }
}


void autoPlay(){
  List<PlayerField> list = new ArrayList<PlayerField>();
  int puttableFieldCounter = 0;
  for(int x=0; x<8; x++){
    for(int y=0; y<8; y++){
      boolean puttable = canPutHere(x,y);
      if(puttable){
        puttableFieldCounter++;
        
        float eval = fieldEval[x][y];  // 評価計算(仮)
        
        list.add(new PlayerField(x, y, eval));
      }
    }
  }
  if(puttableFieldCounter!=0){
    Collections.sort(list, new PlayerFieldComparator());
    int x = list.get(list.size()-1).getX();
    int y = list.get(list.size()-1).getY();
    stoneID++;
    reverseStoneParent(x, y);
    black_turn =! black_turn;
    return;
  }else{
    black_turn =! black_turn;
    return;
  }
}

// fieldのクラス
public class PlayerField{
  private float eval;
  private int x;
  private int y;
  
  PlayerField(int xx, int yy, float eeval){
    this.x = xx;
    this.y = yy;
    this.eval = eeval;
  }
  
  int getX(){return this.x;}
  int getY(){return this.y;}
  float getEval(){return this.eval;}
}

// fieldを比較するためのクラス
public class PlayerFieldComparator implements Comparator<PlayerField>{
  public int compare(PlayerField a, PlayerField b){
    float no1 = a.getEval();
    float no2 = b.getEval();
    if(no1 > no2){
      return 1;
    }else if(no1 == no2){
      return 0;
    }else{
      return -1;
    }
  }
}

// 盤面評価
int[][] fieldEval = {{30, -12, 0, -1, -1, 0, -12, 30},
                     {-12, -15, -3, -3, -3, -3, -15, -12},
                     {0, -3, 0, -1, -1, 0, -3, 0},
                     {-1, -3, -1, -1, -1, -1, -3, -1},
                     {-1, -3, -1, -1, -1, -1, -3, -1},
                     {0, -3, 0, -1, -1, 0, -3, 0},
                     {-12, -15, -3, -3, -3, -3, -15, -12},
                     {30, -12, 0, -1, -1, 0, -12, 30}};

// 隅の石がNULLでなければ、盤面評価を更新する
void updateEval(){
  if(field[0][0]!=0){
    fieldEval[0][1] = 30;
    fieldEval[1][0] = 30;
    fieldEval[1][1] = 30;
  }
  if(field[0][7]!=0){
    fieldEval[0][6] = 30;
    fieldEval[1][6] = 30;
    fieldEval[1][7] = 30;
  }
  if(field[7][0]!=0){
    fieldEval[6][0] = 30;
    fieldEval[6][1] = 30;
    fieldEval[7][1] = 30;
  }
  if(field[7][7]!=0){
    fieldEval[6][7] = 30;
    fieldEval[6][6] = 30;
    fieldEval[7][6] = 30;
  }
}

/* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */
boolean blackPuttable = true;
void puttableField(){
  int puttableFieldCounter=0;
  for(int i=0; i<8; i++){
    for(int j=0; j<8; j++){
        boolean left = canPutHereSub(i, j, -1, 0);
        boolean right = canPutHereSub(i, j, 1, 0);
        boolean up = canPutHereSub(i, j, 0, -1);
        boolean down = canPutHereSub(i, j, 0, 1);
        boolean leftup = canPutHereSub(i, j, -1, -1);
        boolean leftdown = canPutHereSub(i, j, -1, 1);
        boolean rightup = canPutHereSub(i, j, 1, -1);
        boolean rightdown = canPutHereSub(i, j, 1, 1);
        if(left|right|up|down|leftup|leftdown|rightup|rightdown){
          fill(#BBBBFF);
          rectMode(CENTER);
          rect((i*2+1)*SIZE/2, (j*2+1)*SIZE/2, STONE_SIZE, STONE_SIZE);
          puttableFieldCounter++;
        }
        if(puttableFieldCounter==0){
          blackPuttable = false;
        }else{
          blackPuttable = true;
        }
    }
  }
}
/* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */
void reverseStoneParent(int x, int y){
boolean left = canPutHereSub(x, y, -1, 0);
  boolean right = canPutHereSub(x, y, 1, 0);
  boolean up = canPutHereSub(x, y, 0, -1);
  boolean down = canPutHereSub(x, y, 0, 1);
  boolean leftup = canPutHereSub(x, y, -1, -1);
  boolean leftdown = canPutHereSub(x, y, -1, 1);
  boolean rightup = canPutHereSub(x, y, 1, -1);
  boolean rightdown = canPutHereSub(x, y, 1, 1);
  
    if(left){
    reverseStone(x,y,-1,0);
  }
  if(right){
    reverseStone(x,y,1,0);
  }
  if(down){
    reverseStone(x,y,0,1);
  }
  if(up){
    reverseStone(x,y,0,-1);
  }
  if(leftup){
    reverseStone(x,y,-1,-1);
  }
  if(rightdown){
    reverseStone(x,y,1,1);
  }
  if(leftdown){
    reverseStone(x,y,-1,1);
  }
  if(rightup){
    reverseStone(x,y,1,-1);
  }
}

boolean canPutHere(int x, int y){
  boolean left = canPutHereSub(x, y, -1, 0);
  boolean right = canPutHereSub(x, y, 1, 0);
  boolean up = canPutHereSub(x, y, 0, -1);
  boolean down = canPutHereSub(x, y, 0, 1);
  boolean leftup = canPutHereSub(x, y, -1, -1);
  boolean leftdown = canPutHereSub(x, y, -1, 1);
  boolean rightup = canPutHereSub(x, y, 1, -1);
  boolean rightdown = canPutHereSub(x, y, 1, 1);
  
  // reverseStoneParent(x,y);
  
  return left|right|up|down|leftup|leftdown|rightup|rightdown;
}

boolean canPutHereSub(int x, int y, int i, int j){
  if(field[x][y]!=NONE){
    return false;
  }
  boolean inside = inside(x+i, y+j);
  if(!inside)return false;
  if(field[x+i][y+j] == getCurrentStone()){
    return false;
  }else if ( field[x+i][y+j] == getOppositeStone()){
    return checkDirection(x+i, y+j, i, j);
  }else{
    return false;
  }
}

boolean checkDirection(int x, int y, int i, int j){
  boolean inside = inside(x+i, y+j);
  if(!inside)return false;
  if(field[x+i][y+j]==getCurrentStone()){
    return true;
  }else if(field[x+i][y+j]==getOppositeStone()){
    return checkDirection(x+i, y+j, i, j);
  }else{
    return false;
  }
}

int getCurrentStone(){
  if(black_turn){
    return BLACK;
  }else{
    return WHITE;
  }
}

int getOppositeStone(){
  if(!black_turn){
    return BLACK;
  }else{
    return WHITE;
  }
}

boolean inside(int x, int y){
  if((0<=x && x<8 ) && (0<=y && y<8)) return true;
  else return false;
}


void reverseStone(int x, int y, int i, int j){
  println("reverseX"+x+", Y"+y+"");
  field[x][y] = getCurrentStone();
  if(field[x+i][y+j]==NONE){
  }else if(field[x+i][y+j]==getCurrentStone()){
    
  }else{
    reverseStone(x+i,y+j, i, j);
  }
}
/* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */

void initialization() {
  for (int i=0; i<8; ++i) {
    for (int j=0; j<8; ++j) {
      field[i][j] = NONE;
    }
  }
  field[3][3] = BLACK;
  field[3][4] = WHITE;
  field[4][3] = WHITE;
  field[4][4] = BLACK;
  exampleState = "default";
}

void example() {
  for (int i=0; i<8; ++i) {
    for (int j=0; j<8; ++j) {
      field[i][j] = NONE;
    }
  }
  field[3][3] = BLACK;
  field[3][4] = WHITE;
  field[4][3] = WHITE;
  field[4][4] = BLACK;
  field[5][1] = WHITE;
  field[5][2] = BLACK;
  field[4][2] = WHITE;
  exampleState = "example";
}

void example1(){
    for (int i=0; i<8; ++i) {
    for (int j=0; j<8; ++j) {
      field[i][j] = NONE;
    }
  }
  field[3][3] = WHITE;
  field[3][4] = BLACK;
  field[4][3] = BLACK;
  field[4][4] = WHITE;
  exampleState = "example1";
}

void example2(){
      for (int i=0; i<8; ++i) {
    for (int j=0; j<8; ++j) {
      field[i][j] = NONE;
    }
  }
  field[3][3] = BLACK;
  field[3][4] = BLACK;
  field[4][3] = WHITE;
  field[4][4] = WHITE;
  field[4][2] = BLACK;
  exampleState = "example2";
}

/* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */
// スペースキーでスクリーンショット
int savecounter=0;
String exampleState = "";
void keyPressed(){
  switch (keyCode){
    case 32:
      save("shot"+savecounter+exampleState+".png");
      savecounter++;
      break;
    case 37:
      initialization();
      break;
    case 38:
      example();
      break;
    case 39:
      example1();
      break;
    case 40:
      example2();
      break;
    case 83:
      if(!blackPuttable){
        black_turn=!black_turn;
        autoPlay();
      }
      break;
  }
}