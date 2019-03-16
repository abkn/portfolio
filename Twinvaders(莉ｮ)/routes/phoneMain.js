var express = require('express');
var router = express.Router();
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('../db/user_data.sqlite');

/* GET users listing. */
router.get('/', function(req, res, next) {
  // console.log(req.query); // submitのGET=を取得

  if (req.session.user) {
    db.serialize(function() {
      db.all("SELECT * FROM user", function(err, rows) {
        if (!err) {
          //  console.log(rows); // データベースを閲覧
          rows.forEach(function(row) {
            if (row.id == req.session.user.id) {
              // 色に関する処理
              if (req.query.color && req.query.type) {
                // 色が変更されていたらGETから
                req.session.user.color = req.query.color;
                // typeが変更されていたらGETから
                req.session.user.type = req.query.type;

                // データベース更新
                var stmt = db.prepare("UPDATE user SET color = ? WHERE id = ?");
                stmt.run(req.session.user.color, req.session.user.id);
                stmt.finalize();

                // データベース更新
                var stmt2 = db.prepare("UPDATE user SET type = ? WHERE id = ?");
                stmt2.run(req.session.user.type, req.session.user.id);
                stmt2.finalize();

                res.render('phoneMain.ejs', {
                  user: req.session.user.name,
                  id: req.session.user.id,
                  image: req.session.user.image,
                  type: req.session.user.type,
                  color: req.session.user.color,
                });
              } else if (!req.query.color && !req.query.type) {
                // 色が変更されていないならデータベースから
                req.session.user.color = row.color;
                // typeが変更されていないならデータベースから
                req.session.user.type = row.type;

                res.render('phoneMain.ejs', {
                  user: req.session.user.name,
                  id: req.session.user.id,
                  image: req.session.user.image,
                  type: req.session.user.type,
                  color: req.session.user.color,
                });
              }
            }
          });
        }
      });
    });
  } else {
    res.render('login.ejs');
  }
});

module.exports = router;
