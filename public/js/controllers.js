
function fileCtrl ($scope) {
	controllers.controller('FileCtrl', ['scope',
		function ($scope) {
			$scope.partialDownloadLink = 'http://localhost:8080/download?filename=';
			$scope.filename = '';
			$scope.uploadFile = function() {
				$scope.processQueue();
	    	};
	    	$scope.reset = function() {
	    		$scope.resetDropzone();
	    	};
		}
	]);
}



angular.module('fileApp').controller('fileCtrl', fileCtrl)