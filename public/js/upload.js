$(document).ready(function () {
	var url = $("#fileName").val();
	function showMessage() {
		$("#displayMessage").html("We are now processing your request. You will be redirected shortly.");
	}

	$("#files").on('change', function() {
		var fileName = $("#files").val().split('\\').pop();
		$("#fileName").val(fileName);
	});

	$("#genes").on('change', function() {
		var geneName = $("#genes").val().split('\\').pop();
		console.log(geneName);
		$("#geneName").val(geneName);
	});

	$("#chromosomals").on('change', function() {
		var chromosomalName = $("#chromosomals").val().split("\\").pop();
		$("#chromosomalName").val(chromosomalName);
	});

	$("#principals").on('change', function() {
		var principalName = $("#principals").val().split("\\").pop();
		$("#principalName").val(principalName);
	})

	$("form").submit(function() {
		showMessage();
	});
});