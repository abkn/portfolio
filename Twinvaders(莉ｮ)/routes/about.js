var express = require('express');
var router = express.Router();

router.get('/', function(req, res) {
  if (req.session.user) {
    res.render('about.ejs', {
      user: req.session.user.name,
      id: req.session.user.id,
      image: req.session.user.image,
      type: req.session.user.type,
      color: req.session.user.color,
    });
  } else {
    res.render('login.ejs');
  }
});

module.exports = router;
