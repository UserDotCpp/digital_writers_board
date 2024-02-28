#thanks https://forum.godotengine.org/t/html5-opening-filesystem-files-in-webgl-export-maybe-with-javascript-workaround/5126/2

extends Node

signal read_completed
signal load_completed(file)

var js_callback =  JavaScriptBridge.create_callback(load_handler);
var js_interface;

func _ready():
	#if OS.get_name() == "HTML5" and OS.has_feature('JavaScript'):
	_define_js()
	js_interface = JavaScriptBridge.get_interface("_HTML5FileExchange");

func _define_js()->void:
	#Define JS script
	JavaScriptBridge.eval("""
	var _HTML5FileExchange = {};
	_HTML5FileExchange.upload = function(gd_callback) {
		canceled = true;
		var input = document.createElement('INPUT'); 
		input.setAttribute("type", "file");
		input.setAttribute("accept", ".save");
		input.click();
		input.addEventListener('change', event => {
			if (event.target.files.length > 0){
				canceled = false;}
			var file = event.target.files[0];
			var reader = new FileReader();
			this.fileType = file.type;
			// var fileName = file.name;
			reader.readAsText(file);
			reader.onloadend = (evt) => { // Since here's it's arrow function, "this" still refers to _HTML5FileExchange
				if (evt.target.readyState == FileReader.DONE) {
					this.result = evt.target.result;
					gd_callback(); // It's hard to retrieve value from callback argument, so it's just for notification
				}
			}
		  });
	}
	""", true)

func load_handler(_args):
	emit_signal("read_completed")
	
func load_file():
	#if OS.get_name() != "HTML5" or !OS.has_feature('JavaScript'):
	#	return

	js_interface.upload(js_callback);

	await self.read_completed

	var fileType = js_interface.fileType;
	var fileContent = JavaScriptBridge.eval("_HTML5FileExchange.result", true) # interface doesn't work as expected for some reason
	
	emit_signal("load_completed", fileContent)
