var express = require('express');
var fileUpload = require('express-fileupload');
var fs = require('fs');
var exec = require('child_process').exec;
var router = express.Router();
var http = require('http');
var request = require('request');
var validUrl = require('valid-url');

router.get('/', function (req, res, next){
  res.render('index', {'genes' : []});
  });

function encodeQueryData(data){
  "use strict"
  let ret = []
  for (let d in data)
    ret.push(encodeURIComponent(d) + "=" + encodeURIComponent(data[d]));
  return ret.join("&");
}

// Deletes the files that were uploaded or downloaded.
function cleanUploadResultsAndUploads(bed_name, res){
  fs.unlink(bed_name, function (error){
    if (error)
     {
       console.log(error);
      }
  });
  fs.readdir('behst/uploadResults', function (error, files){
    if (error){
      console.log(error);
      }
    files.forEach(function (element){
      fs.unlink("behst/uploadResults/" + element, function (error){
        if (error){
          console.log(error);
          }
        });
    });
  });
 }





// This calls the BEHST application and generates the redirect URL.
function execBehst(bedName, gene, chromosomal, principal, res, req)
{
  exec('bash behst/bin/project.sh'
       + " " + bedName 
       + " behst/data/" 
       + " " + parseInt(req.body.query)
       + " " + parseInt(req.body.target) 
       + " " + gene 
       + " " + principal 
       + " " + chromosomal,

       function (err, stdout , stderr){
         if (stderr || err){
           console.log(stdout);
           console.log("errored out")
           res.status(500);
           res.render('error', {error : err});
           return null;
         }
         project = stdout;
         project = project.split("\n");
         project.forEach(function (element){
           if (element.trim().indexOf("gene_list.txt") != -1 && element.trim().charAt(0) == "b"){
             fs.readFile(element.trim(), function (err, data){
               if (err){
                 res.status(500);
                 res.render('error', {error : err});
                 return null;
               }
               data = data.toString().split("\n");
               var baseUri = 'http://biit.cs.ut.ee/gprofiler/index.cgi?';
               queryString = ""
               data.forEach(function (element, index, array){
                 queryString = queryString + element + " ";
                 if (index == array.length - 1)
                   genes.push( baseUri + encodeQueryData({query : queryString.trim(), species : "hsapiens"}));
               });
               res.redirect(genes[0]);
               genes.pop();
               var uploads = [bedName, gene, chromosomal, principal];
               var length = uploads.length;
               
               for (i = 0; i < length; i++) {
                path = uploads[i].split('/')

                if (path[1] != "data") {
                  cleanUploadResultsAndUploads(uploads[i], res);
                }
               }
               fs.readdir('behst/results', function(err, files) {
                if (err) {
                  console.log(err)
                }
                else {
                  fs.unlink('behst/results/' + files[1], function(err) {
                    if (err) {
                      console.log(err)
                    }
                  });
                }
               }); 
             });
           };
         });
       });
}


// Checks if the file is in the given directory
function checkIfFile(file, cb) {
  fs.stat(file, function fsStat(err, stats) {
    if (err) {
      if (err.code == 'ENOENT') {
        return cb(null, false);
      } else {
        return cb(err)
      }
    }
    return cb(null, stats.isFile());
  });
}


//Downloads the file from the Uri, or saves the file locally if uploaded
function downloadFileOrURI(name, file) {
  return new Promise(function(resolve,reject) {
    if (typeof file == 'undefined') {
      fileName = name.split("/");
      fileName = fileName[fileName.length - 1];
    }
    else {
      fileName = name;
    }
    checkIfFile('behst/data/' + fileName, function(err, isFile) {
      // This renaming of the file name is needed as the fileName is not updated
      if (typeof file == 'undefined') {
        fileName = name.split("/");
        fileName = fileName[fileName.length - 1];
      }
      else {
        fileName = name;
      }
      if (isFile) {
        resolve('behst/data/' + fileName)
      }
      else if (file) {
        fs.writeFile('behst/uploads/' + file.name, file.data,
          function (err) {
            if (err)
              reject(err)
            resolve('behst/uploads/' + file.name)
          });
      }
      else if (!isFile) {
        request.get(name, {timeout: 600000}, function(err, resp, body) {
          if (err || resp.statusCode != 200) {
            reject(err)
          }
          if (resp.statusCode == 200) {
            fileName = name.split("/")
            fileName = fileName[fileName.length - 1];
            data = body
            fs.writeFile('behst/uploads/' + fileName, data, 
              function (err) {
                if (err)
                  reject(err)
                resolve('behst/uploads/' + fileName);
              });
          }
        });
      }
      else {
        reject(err)
      }
    });
  });
}

//Saves the file names into promise array and calls the BEHST application
router.post('/', function (req, res, next){
  genes = []
  promiseArray = []
  promiseArray.push(downloadFileOrURI(req.body.file, req.files.upload));
  promiseArray.push(downloadFileOrURI(req.body.gene, req.files.geneUpload));
  promiseArray.push(downloadFileOrURI(req.body.chromosomal, req.files.chromosomalUpload));
  promiseArray.push(downloadFileOrURI(req.body.principal, req.files.principalUpload));
  Promise.all(promiseArray).then(
    function (values){
      execBehst(values[0], values[1], values[2], values[3], res, req);
      }, 
    function (err){
      console.error(err)
    });
});

module.exports = router;
