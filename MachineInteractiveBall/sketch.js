// モデルのURL 
let imageModelURL = 'https://teachablemachine.withgoogle.com/models/xvclUffD/';
let classifier;
let video;
let message = "";
let pos;

function preload() {
  message = 'loading...';
  // モデルをロード
  classifier = ml5.imageClassifier(imageModelURL + 'model.json');  
}

function setup() {
  createCanvas(windowWidth, windowHeight);
  // ビデオをキャプチャー
  video = createCapture(VIDEO);
  video.size(320, 240);
  video.hide();
  //位置を初期化 (画面の中心)
  pos = createVector(width/2, height/2);
  // クラス分けスタート
  classifyVideo();
}

function draw() {
  background(0);
  //ビデオを描画  
  image(video, 0, 0, width, height);
  //現在の位置に円を描画
  fill(255);
  noStroke();
  circle(pos.x, pos.y, 200);
}

// 現在のフレームのクラスを類推
function classifyVideo() {
  classifier.classify(video, gotResult);
}

// 結果を取得したら実行
function gotResult(error, results) {
  // エラー処理
  if (error) {
    message = error;
    console.error(error);
    return;
  }
  //メッセージクリア
  message = '';
  // 解析結果で位置を更新
  if(results[0].label == 'left') {
    pos.x += 10;
    if(pos.x > width) {
      pos.x = 0;
    }
  } 
  if(results[0].label == 'right') {
    pos.x -= 10;
    if(pos.x < 0) {
      pos.x = width;
    }
  }
  if(results[0].label == 'up') {
    pos.y -= 10;
    if(pos.y < 0) {
      pos.y = height;
    }
  }
  if(results[0].label == 'down') {
    pos.y += 10;
    if(pos.y > height) {
      pos.y = 0;
    }
  }
  console.log(results[0].label);
  // 再度クラス分け
  classifyVideo();
}