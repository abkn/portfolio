var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {

  if (req.session.passport) {
    var profile_image_url = req.session.passport.user._json.profile_image_url;
    req.session.user = {
      name: req.session.passport.user.username,
      id: req.session.passport.user.id,
      image: profile_image_url.replace("_normal", ""), // 取得するアイコンサイズの変更
      type: "typeA",
      color: "#00ff00",
    };
    res.redirect('../'); // indexにリダイレクトする
  } else {
    res.render('login.ejs');
  }

});

module.exports = router;
