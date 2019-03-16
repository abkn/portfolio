var express = require('express');
var router = express.Router();
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('../db/user_data.sqlite');

router.get('/', function(req, res, next) {

  db.serialize(function() {
    db.all("SELECT * FROM user", function(err, rows) {
      if (!err) {
        var insertFlag = true;

        // console.log(rows); // データベースを閲覧

        rows.forEach(function(row) {
          if (row.id == req.session.user.id) {
            req.session.user.type = row.type;
            req.session.user.color = row.color;
            insertFlag = false;
          }
        });

        if (insertFlag) {
          var stmt = db.prepare("INSERT INTO user(id, type, color) VALUES (?, ?, ?)");
          stmt.run(req.session.user.id, req.session.user.type, req.session.user.color);
          stmt.finalize();

          res.render('index.ejs');
        } else {
          res.render('index.ejs');
        }
      }
    });
  });
});


module.exports = router;
