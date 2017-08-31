function showMessage() {
	document.getElementById("display_message").innerHTML = "We are now processing your request. You will be redirected shortly.";
}


var process = false;
Dropzone.autoDiscover = false;

dropzoneOptions = {
	dictDefaultMessage: "Drop your file or click here to upload",
	autoProcessQueue: false,
	timeout: 0,
	acceptedFiles: ".bed",
	maxFiles: 1,
	previewTemplate: "<div class='upload'> <span id='file'> </span></div> ",
	init: function() {
		var myDropzone = this;
		this.on("addedfile", function(file) {
			document.getElementById("file").innerHTML = file.name + " Click Start to begin or Delete to remove."
			
		});
		this.on("maxfilesexceeded", function(file) {
			myDropzone.removeAllFiles();
			myDropzone.addFile(file);
		});

		this.element.querySelector(".delete").addEventListener("click", function(e) {
  			if (process == false) {
				e.preventDefault();
      			e.stopPropagation();
      			myDropzone.removeAllFiles();
      		}
  		});

		// First change the button to actually tell Dropzone to process the queue.
		this.element.querySelector(".start").addEventListener("click", function(e) {
			e.preventDefault();
      		e.stopPropagation();
      		if (myDropzone.files.length > 0 ) {
      			myDropzone.processQueue();
      			showMessage();
      			process = true;
      			document.getElementById("del").setAttribute('disabled', 'disabled')
      		} 
  		});
  		this.on("success", function(file, resp) {
  			window.location.href = (resp.url)
  		});
	}
} 


var uploader = document.querySelector('#info');
var newDropzone = new Dropzone(uploader, dropzoneOptions);





