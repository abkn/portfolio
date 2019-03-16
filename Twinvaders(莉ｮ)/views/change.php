<?php
  if (isset($_GET["id"])) {
    $id = $_GET["id"];
  }
  if (isset($_GET["image"])) {
    $image = $_GET["image"];
  }
  if (isset($_GET["color"])) {
    $color = $_GET["color"];
  }
  if (isset($_GET["type"])) {
    $type = $_GET["type"];
  }
  if (isset($_GET["user"])) {
    $user = $_GET["user"];
  }
?>
  <!DOCTYPE html>
  <html>

  <head>
    <title>CHANGE</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=10.0, user-scalable=yes">
    <script src="//code.jquery.com/jquery-2.1.0.min.js" type="text/javascript"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/raphael/2.1.2/raphael-min.js" type="text/javascript"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/qunit/1.14.0/qunit.min.js" type="text/javascript"></script>
    <script src="../public/javascript/Colorwheel.js" type="text/javascript"></script>
    <script type="text/javascript">
      var UA;
      var isShake = false;
      var width = 1150;
      var height = 750;
      var x;
      var y;
      var z;
      var alpha;
      var beta;
      var gamma;
      var posX = width / 2;
      var posY = height / 2;
      var angle = 0;
      var frameCount = 0;
      var countBuffer = 0;
      var showFinger = true;
      var finger = new Image();
      var clickCount = -1;
      finger.src = "../public/image/finger.png";
      window.addEventListener('load', function() {

        UA = navigator.userAgent;
        var isMenuShow = false;

        $(".bunObj").click(function() {
          if (isMenuShow) {
            $(".main").animate({
              'margin-left': '-=150px'
            }, 300);
            $(".bun").animate({
              'opacity': '1'
            }, 200);
            $(".bun").show(150);
            $(".cross").animate({
              'opacity': '0'
            }, 100);
            $(".cross").hide(150);
            isMenuShow = false;
          } else {
            $(".main").animate({
              'margin-left': '+=150px'
            }, 300);
            $(".bun").animate({
              'opacity': '0'
            }, 100);
            $(".bun").hide(150);
            $(".cross").animate({
              'opacity': '1'
            }, 200);
            $(".cross").show(100);
            isMenuShow = true;
          }
        });
        if (clickCount == -1) {
          $("input[name='type']").val("<?php print $type;?>");
          if ("<?php print $type;?>" == "typeA") {
            clickCount = 0;
          }
          if ("<?php print $type;?>" == "typeB") {
            clickCount = 1;
          }
          if ("<?php print $type;?>" == "typeC") {
            clickCount = 2;
          }
          if ("<?php print $type;?>" == "typeD") {
            clickCount = 3;
          }
          if ("<?php print $type;?>" == "typeE") {
            clickCount = 4;
          }
          if ("<?php print $type;?>" == "typeF") {
            clickCount = 5;
          }
          if ("<?php print $type;?>" == "typeG") {
            clickCount = 6;
          }
        }
        $("#canvasType").click(function() {
          countBuffer = frameCount;
          showFinger = false;
          clickCount++;
          if (clickCount % 7 == 0) {
            $("input[name='type']").val("typeA");
          }
          if (clickCount % 7 == 1) {
            $("input[name='type']").val("typeB");
          }
          if (clickCount % 7 == 2) {
            $("input[name='type']").val("typeC");
          }
          if (clickCount % 7 == 3) {
            $("input[name='type']").val("typeD");
          }
          if (clickCount % 7 == 4) {
            $("input[name='type']").val("typeE");
          }
          if (clickCount % 7 == 5) {
            $("input[name='type']").val("typeF");
          }
          if (clickCount % 7 == 6) {
            $("input[name='type']").val("typeG");
          }
        });
        update();
      }, false);

      /*-------------------------ColorWheel-------------------------------*/
      function run() {
        function input_example() {
          var cw = Raphael.colorwheel($("#ColorWheel .colorwheel")[0], 150);
          cw.input($("#ColorWheel #input")[0]);
          return cw;
        }

        function callback_example() {
          var cw = Raphael.colorwheel($("#ColorWheel .colorwheel")[0], 150);
          cw.input($("#ColorWheel #input")[0]);
          return cw;
        }
        module("Color Wheel");
        var input = $("#ColorWheel #input");
        var cw = input_example();
        test("setting the color value updates the picker and the input", function() {
          cw.color("#ff0000");
          equal("#ff0000", cw.color().hex, "the color value is set");
          equal("#ff0000", input.val(), "input is set");
        });
        module("Callback");
        test("onchange should happen when user interaction happens", function() {
          var onchange_count = 0;
          cw.onchange(function() {
            onchange_count += 1;
            $("input[name='color']").val(cw.color().hex);
          });
          equal(onchange_count, 0, "onchange has not triggered yet");
          input.val("<?php print $color?>").trigger("keyup");
          equal(onchange_count, 1, "onchange should trigger when input changed");
        });
      }
      $(run);
      /*--------------------------canvas-------------------------------*/

      function update() {
        requestAnimationFrame(update);

        /*閾値を越えたら傾けた角度の分動く*/
        if (Math.abs(30 - beta) > 10) {
          posY += (30 - beta) * 0.1;
        }
        if (Math.abs(x) > 1.0) {
          posX += x;
        }
        /*枠の外には出ないようにする*/
        var limit = 30;
        if (posX >= width - limit) {
          posX = width - limit;
        }
        if (posX <= limit) {
          posX = limit;
        }
        if (posY > height - limit) {
          posY = height - limit;
        }
        if (posY < limit) {
          posY = limit;
        }
        posX = Math.floor(posX);
        posY = Math.floor(posY);

        draw();
        isShake = false;
        frameCount ++ ;
      }

      function draw() {
        var image = "<?php print $image;?>";
        var color = $("input[name='color']").val();
        var type = $("input[name='type']").val();
        var iconX = 200 / 2;
        var iconY = 240 / 2;
        var size = 100;
        var canvas = document.getElementById('canvas');
        var ctx = canvas.getContext('2d');
        ctx.save();
        ctx.shadowColor = color; //指定した色
        ctx.shadowBlur = 10; //シャドウの強さ
        ctx.shadowOffsetX = 0;
        ctx.shadowOffsetY = 0;

        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, 500, 500);

        ctx.shadowBlur = 10; //シャドウを付ける
        ctx.fillStyle = color; //指定した色

        drawUser(type, ctx, iconX, iconY, size); //ドット描写

        /*iconX,iconYに画像を表示*/
        ctx.fillRect(iconX - size / 2 - 1, iconY - size / 2 - 1, size + 2, size + 2);
        ctx.shadowBlur = 0;
        var img = new Image();
        img.src = image;
        ctx.drawImage(img, iconX - size / 2, iconY - size / 2, size, size);
      }

      function drawUser(type, ctx, iconX, iconY, size) {
        DD = new Date(); //時間取得
        var seconds = DD.getSeconds();
        if (seconds % 2 == 0) {
          pose = -1; //ポーズ切り替え
        } else {
          pose = 1;
        }
        if (type == "typeA") {
          if (pose == 1) { //2
            ctx.fillRect(iconX - size / 6, iconY - size * 2 / 3, size / 6, size / 6); //アンテナ
            ctx.fillRect(iconX, iconY - size * 5 / 6, size / 6, size / 6);
            ctx.fillRect(iconX - size / 6, iconY - size, size / 6, size / 6);

            ctx.fillRect(iconX - size * 2 / 3, iconY, size / 6, size / 3); //左腕
            ctx.fillRect(iconX - size * 2 / 3, iconY + size / 2, size / 6, size / 6);
            ctx.fillRect(iconX - size / 2, iconY + size * 2 / 3, size / 6, size / 6);

            ctx.fillRect(iconX + size / 2, iconY, size / 6, size / 3); //右腕
            ctx.fillRect(iconX + size / 2, iconY + size / 2, size / 6, size / 6);
            ctx.fillRect(iconX + size / 3, iconY + size * 2 / 3, size / 6, size / 6);
          } else { //5
            ctx.fillRect(iconX - size / 6, iconY - size * 2 / 3, size / 6, size / 6); //アンテナ
            ctx.fillRect(iconX, iconY - size * 5 / 6, size / 6, size / 6);
            ctx.fillRect(iconX - size / 6, iconY - size, size / 6, size / 6);

            ctx.fillRect(iconX - size * 2 / 3, iconY, size / 6, size / 3); //左腕
            ctx.fillRect(iconX - size * 5 / 6, iconY + size / 6, size / 6, size / 2);
            ctx.fillRect(iconX - size * 2 / 3, iconY + size * 2 / 3, size / 6, size / 6);

            ctx.fillRect(iconX + size / 2, iconY, size / 6, size / 3); //右腕
            ctx.fillRect(iconX + size * 2 / 3, iconY + size / 6, size / 6, size / 2);
            ctx.fillRect(iconX + size / 2, iconY + size * 2 / 3, size / 6, size / 6);
          }
        }
        if (type == "typeB") {
          if (pose == 1) { //1
            ctx.fillRect(iconX - size * 5 / 6, iconY - size / 3, size / 6, size / 3); //左腕
            ctx.fillRect(iconX - size * 2 / 3, iconY - size / 6, size / 6, size / 2);

            ctx.fillRect(iconX + size * 2 / 3, iconY - size / 3, size / 6, size / 3); //右腕
            ctx.fillRect(iconX + size / 2, iconY - size / 6, size / 6, size / 2);

            ctx.fillRect(iconX - size / 3, iconY + size / 2, size / 6, size / 3); //足
            ctx.fillRect(iconX + size / 6, iconY + size / 2, size / 6, size / 3);
          } else { //12
            ctx.fillRect(iconX - size * 5 / 6, iconY - size / 3, size / 6, size / 3); //左腕
            ctx.fillRect(iconX - size * 2 / 3, iconY - size / 6, size / 6, size / 3);

            ctx.fillRect(iconX + size * 2 / 3, iconY - size / 3, size / 6, size / 3); //右腕
            ctx.fillRect(iconX + size / 2, iconY - size / 6, size / 6, size / 3);

            ctx.fillRect(iconX - size * 2 / 3, iconY + size / 2, size / 6, size / 6); //足
            ctx.fillRect(iconX + size / 2, iconY + size / 2, size / 6, size / 6);
          }
        }
        if (type == "typeC") {
          if (pose == 1) { //3
            ctx.fillRect(iconX, iconY - size * 5 / 6, size / 6, size / 3); //アンテナ
            ctx.fillRect(iconX - size / 6, iconY - size * 2 / 3, size / 6, size / 6);

            ctx.fillRect(iconX - size / 2, iconY + size / 2, size / 6, size / 3); //左足
            ctx.fillRect(iconX - size * 2 / 3, iconY + size * 5 / 6, size / 6, size / 6);

            ctx.fillRect(iconX + size / 3, iconY + size / 2, size / 6, size / 3); //右足
            ctx.fillRect(iconX + size / 2, iconY + size * 5 / 6, size / 6, size / 6);
          } else {
            ctx.fillRect(iconX - size / 6, iconY - size * 5 / 6, size / 6, size / 3); //アンテナ
            ctx.fillRect(iconX, iconY - size * 2 / 3, size / 6, size / 6);

            ctx.fillRect(iconX - size / 2, iconY + size / 2, size / 6, size / 6); //左足
            ctx.fillRect(iconX - size / 3, iconY + size * 2 / 3, size / 6, size / 6);
            ctx.fillRect(iconX - size / 6, iconY + size * 5 / 6, size / 6, size / 6);

            ctx.fillRect(iconX + size / 3, iconY + size / 2, size / 6, size / 6); //右足
            ctx.fillRect(iconX + size / 6, iconY + size * 2 / 3, size / 6, size / 6);
            ctx.fillRect(iconX, iconY + size * 5 / 6, size / 6, size / 6);
          }
        }
        if (type == "typeD") {
          if (pose == 1) { //6
            ctx.fillRect(iconX - size / 6, iconY - size * 2 / 3, size / 6, size / 6); //アンテナ
            ctx.fillRect(iconX, iconY - size * 5 / 6, size / 6, size / 6);
            ctx.fillRect(iconX - size / 6, iconY - size, size / 6, size / 6);

            ctx.fillRect(iconX, iconY + size / 2, size / 6, size / 6); //アンテナ
            ctx.fillRect(iconX - size / 6, iconY + size * 2 / 3, size / 6, size / 6);
            ctx.fillRect(iconX, iconY + size * 5 / 6, size / 6, size / 6);

            ctx.fillRect(iconX - size * 2 / 3, iconY - size / 3, size / 6, size * 2 / 3); //端
            ctx.fillRect(iconX + size / 2, iconY - size / 3, size / 6, size * 2 / 3);
          } else {
            ctx.fillRect(iconX, iconY - size * 2 / 3, size / 6, size / 6); //アンテナ
            ctx.fillRect(iconX - size / 6, iconY - size * 5 / 6, size / 6, size / 6);
            ctx.fillRect(iconX, iconY - size, size / 6, size / 6);

            ctx.fillRect(iconX - size / 6, iconY + size / 2, size / 6, size / 6); //アンテナ
            ctx.fillRect(iconX, iconY + size * 2 / 3, size / 6, size / 6);
            ctx.fillRect(iconX - size / 6, iconY + size * 5 / 6, size / 6, size / 6);

            ctx.fillRect(iconX - size * 2 / 3, iconY - size / 3, size / 6, size * 2 / 3); //端
            ctx.fillRect(iconX + size / 2, iconY - size / 3, size / 6, size * 2 / 3);
          }
        }
        if (type == "typeE") {
          if (pose == 1) { //9
            ctx.fillRect(iconX - size / 6, iconY - size * 5 / 6, size / 3, size / 6); //頭
            ctx.fillRect(iconX - size / 3, iconY - size * 2 / 3, size * 2 / 3, size / 6);

            ctx.fillRect(iconX - size * 2 / 3, iconY + size / 6, size / 6, size / 2); //左足
            ctx.fillRect(iconX - size * 5 / 6, iconY + size * 2 / 3, size / 6, size / 6);

            ctx.fillRect(iconX + size / 2, iconY + size / 6, size / 6, size / 2); //右足
            ctx.fillRect(iconX + size * 2 / 3, iconY + size * 2 / 3, size / 6, size / 6);
          } else {
            ctx.fillRect(iconX - size / 6, iconY - size, size / 6, size / 6); //頭
            ctx.fillRect(iconX - size / 6, iconY - size * 5 / 6, size / 3, size / 6);
            ctx.fillRect(iconX - size / 3, iconY - size * 2 / 3, size * 2 / 3, size / 6);

            ctx.fillRect(iconX - size / 2, iconY + size * 2 / 3, size / 6, size / 6); //足
            ctx.fillRect(iconX - size / 3, iconY + size / 2, size / 6, size / 6);
            ctx.fillRect(iconX - size / 6, iconY + size / 2, size / 6, size / 3);
            ctx.fillRect(iconX + size / 6, iconY + size / 2, size / 6, size / 6);
            ctx.fillRect(iconX + size / 3, iconY + size * 2 / 3, size / 6, size / 6);
          }
        }
        if (type == "typeF") {
          if (pose == 1) { //10
            ctx.fillRect(iconX - size / 2, iconY - size * 5 / 6, size / 6, size / 6); //耳
            ctx.fillRect(iconX - size / 3, iconY - size * 2 / 3, size / 6, size / 6);
            ctx.fillRect(iconX + size / 3, iconY - size * 5 / 6, size / 6, size / 6);
            ctx.fillRect(iconX + size / 6, iconY - size * 2 / 3, size / 6, size / 6);

            ctx.fillRect(iconX - size * 5 / 6, iconY + size * 2 / 3, size / 6, size / 6); //足
            ctx.fillRect(iconX - size * 2 / 3, iconY + size / 2, size * 4 / 3, size / 6);
            ctx.fillRect(iconX + size * 2 / 3, iconY + size * 2 / 3, size / 6, size / 6);
          } else {
            ctx.fillRect(iconX - size / 6, iconY - size, size / 6, size / 6); //アンテナ
            ctx.fillRect(iconX, iconY - size * 5 / 6, size / 6, size / 3);

            ctx.fillRect(iconX - size * 5 / 6, iconY + size / 2, size / 6, size / 6); //足
            ctx.fillRect(iconX - size * 2 / 3, iconY + size * 2 / 3, size / 3, size / 6);
            ctx.fillRect(iconX - size / 3, iconY + size / 2, size * 2 / 3, size / 6);
            ctx.fillRect(iconX + size / 3, iconY + size * 2 / 3, size / 3, size / 6);
            ctx.fillRect(iconX + size * 2 / 3, iconY + size / 2, size / 6, size / 6);
          }
        }
        if (type == "typeG") {
          if (pose == 1) { //7
            ctx.fillRect(iconX - size / 6, iconY - size * 5 / 6, size / 6, size / 6);
            ctx.fillRect(iconX, iconY - size * 2 / 3, size / 3, size / 6);
            ctx.fillRect(iconX + size * 2 / 3, iconY - size / 6, size / 6, size / 6);
            ctx.fillRect(iconX + size / 2, iconY, size / 6, size / 3);
            ctx.fillRect(iconX, iconY + size * 2 / 3, size / 6, size / 6);
            ctx.fillRect(iconX - size / 3, iconY + size / 2, size / 3, size / 6);
            ctx.fillRect(iconX - size * 5 / 6, iconY, size / 6, size / 6);
            ctx.fillRect(iconX - size * 2 / 3, iconY - size / 3, size / 6, size / 3);
          } else {
            ctx.fillRect(iconX - size / 2, iconY - size * 5 / 6, size / 6, size / 6);
            ctx.fillRect(iconX - size / 3, iconY - size * 2 / 3, size / 3, size / 6);
            ctx.fillRect(iconX + size * 2 / 3, iconY - size / 2, size / 6, size / 6);
            ctx.fillRect(iconX + size / 2, iconY - size / 3, size / 6, size / 3);
            ctx.fillRect(iconX + size / 3, iconY + size * 2 / 3, size / 6, size / 6);
            ctx.fillRect(iconX, iconY + size / 2, size / 3, size / 6);
            ctx.fillRect(iconX - size * 5 / 6, iconY + size / 3, size / 6, size / 6);
            ctx.fillRect(iconX - size * 2 / 3, iconY, size / 6, size / 3);
          }
        }
      }
    </script>
    <link rel="stylesheet" type="text/css" href="../public/stylesheets/phone.css">
  </head>

  <body>
    <!-- menubar -->
    <div class="menubar">
      <nav class="child">
        <ul>
          <li>
            <form action="/phoneMain" method="get">
              <input type="submit" value="HOME" class="menuHOME">
            </form>
          </li>
          <li>
            <form action="change.php" method="get">
              <input name=id value="<?php print $id ?>" type="hidden">
              <input name=image value="<?php print $image ?>" type="hidden">
              <input name=color value="<?php print $id ?>" type="hidden">
              <input name=type value="<?php print $id ?>" type="hidden">
              <input name=user value="<?php print $user ?>" type="hidden">
              <input type="submit" value="CHANGE" class="menuCHANGE">
            </form>
          </li>
          <li>
            <form action="/about" method="get">
              <input class="menuABOUT" type="submit" value="ABOUT">
            </form>
          </li>
          <li>
            <form action="/logout" method="get">
              <input type="submit" value="LOGOUT" class="menuLOGOUT">
            </form>
          </li>
        </ul>
      </nav>
    </div>
    <!-- main -->
    <div class="main">
      <div class="bunObj">
        <div class="bun top"></div>
        <div class="bun middle"></div>
        <div class="bun bottom"></div>
        <div class="cross right"></div>
        <div class="cross left"></div>
      </div>
      <div class="content">
        <div id="canvasType">
          <canvas width="200" height="240" id="canvas"></canvas>
        </div>
        <div id='ColorWheel'>
          <div class='colorwheel'>
            <form action="/phoneMain" method="get">
              <input id='input' type='hidden'>
              <input id="change" value="Save" type='submit'>
              <input name="color" type="hidden" value="#00ff00">
              <input name="type" type="hidden" value="typeA">
            </form>
          </div>
        </div>
      </div>
    </div>
  </body>

  </html>
