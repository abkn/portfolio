var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var session = require('express-session');
var passport = require('passport');
var TwitterStrategy = require('passport-twitter').Strategy;
var phpExpress = require('php-express')({
  binPath: 'php'
});

var routes = require('./routes/index');
var pcMain = require('./routes/pcMain');
var phoneMain = require('./routes/phoneMain');
var login = require('./routes/login');
var oauth = require('./routes/oauth');
var change = require('./routes/change');
var logout = require('./routes/logout');
var about = require('./routes/about');
var sessionDelete = require('./routes/sessionDelete');

//Twitter Appsにて取得したConsumer Key (API Key)とConsumer Secret (API Secret)を記述
var TWITTER_CONSUMER_KEY = "8prYhfWChseLZUtZyO2XQB1I1";
var TWITTER_CONSUMER_SECRET = "kCeh9MPeNEUm09YIV1do9sVWCBqFCJAJnF9EjPcXudC5zmyNYX";

passport.serializeUser(function (user, done) {
    done(null, user);
});

passport.deserializeUser(function (obj, done) {
    done(null, obj);
});

passport.use(new TwitterStrategy({
        consumerKey: TWITTER_CONSUMER_KEY,
        consumerSecret: TWITTER_CONSUMER_SECRET,
        callbackURL: "http://133.26.45.174:3000/oauth/callback" //Twitterログイン後、遷移するURL
    },
    function (token, tokenSecret, profile, done) {
        //console.log(token, tokenSecret, profile);
        process.nextTick(function () {
            return done(null, profile);
        });
    }
));

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.set('view engine', 'ejs');
app.engine('php', phpExpress.engine);
app.set('view engine', 'php');
app.all(/.+\.php$/, phpExpress.router);

// uncomment after placing your favicon in /public
//app.use(favicon(__dirname + '/public/favicon.ico'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use('/public', express.static(path.join(__dirname, 'public')));

app.use(session({
  secret: 'keyboard cat',
  resave: false,
  saveUninitialized: false,
  cookie: {
    maxAge: 30 * 60 * 1000 // 30min.
  }
}));

var sessionCheck = function(req, res, next) {
  if (req.session.user) {
    next();
  } else {
    res.redirect('/login');
  }
};

app.use(passport.initialize());
app.use(passport.session());

app.use('/login', login);
app.use('/pcMain', pcMain);
app.use('/phoneMain', phoneMain);
app.use('/oauth', oauth);
app.use('/change', change);
app.use('/logout', logout);
app.use('/about', about);
app.use('/sessionDelete', sessionDelete);
app.use('/', sessionCheck, routes);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error.ejs', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error.ejs', {
    message: err.message,
    error: {}
  });
});

module.exports = app;
