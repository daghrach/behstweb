
var http = require('http');
var express = require('express')
var hogan = require('hogan-express');
var fs = require('fs');
var fileUpload = require('express-fileupload');
var execSync = require('child_process').execSync;
var path = require('path')


var index = require('./routes/index');
var app = express();

app.set('view engine', 'pug');
app.set('views', require('path').join(__dirname, '/views'));
app.use('/behst',express.static(path.join(__dirname, 'public')));
app.use(fileUpload());

app.use('/behst', index);
app.listen(3000, function(){});


