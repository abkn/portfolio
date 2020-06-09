attribute vec3  position;
attribute vec4  random;    //四つの乱数が含まれる
uniform   mat4  mvpMatrix; // mvpMatrix
uniform   float time;      // 経過時間
uniform   float timeScale; // 経過時間のスケール
uniform   float moveScale; // 動く大きさの幅
uniform   float flowSpeed; // 流れる速度
uniform   float glowSpeed; // 点滅する速度
uniform   float zScale;    // 奥行きのスケール
uniform   float pointSize; // ポイントサイズ

varying   float vAlpha;    // フラグメントシェーダにアルファを送る

const float PI = 3.1415926;

void main(){
    // 経過時間にランダムの影響を加える
    float t = time * timeScale + random.w * PI;
    // 乱数を組み合わせてサインやコサインを計算し動かす量を算出
    // 2)動く軌道のへんか
    float moveX = cos(random.x * t);
    float moveY = sin(random.y * t);
    float moveZ = sin(random.z * t);

    // ローカルの Z 座標は -1.0 ～ 1.0 の範囲なので、一度 0.0 ～ 1.0 に変換
    float z = (position.z + 1.0) * 0.5;
    // fract を使って小数点以下の数値だけを取り出す
    z = fract(z + t * flowSpeed + moveZ * moveScale);
    // この時点の Z は 0.0 ～ 1.0 未満なので、この数値を使って簡易フォグを掛ける
    vAlpha = smoothstep(0.0, 0.1, z);
    // -1.0 ～ 1.0 に戻す
    z = z * 2.0 - 1.0;
    // 各種の影響を頂点に加えた状態の vec3 を作り、行列と乗算
    vec3 p = vec3(
        position.x + moveX * moveScale,
        position.y + moveY * moveScale,
        z * zScale
    );
    gl_Position = mvpMatrix * vec4(p, 1.0);

    // 頂点の大きさを変化させる
    // 3)頂点の大きさがランダム
    float g = (random.x * 2.0) * glowSpeed * PI;
    gl_PointSize = pointSize * sin(time * g);
}
