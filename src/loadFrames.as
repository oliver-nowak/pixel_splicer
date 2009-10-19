package {
	import flash.filesystem.File;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.events.FileListEvent;
	import flash.net.*;
	import flash.display.Loader;
	import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	//import flash.desktop.*;

	public class loadFrames extends Sprite {

		private var files:File=File.applicationDirectory;
		private var imagesFilter:FileFilter = new FileFilter("Images", "*.jpg");
		private var fileLoader:Loader = new Loader();
		private var frame:uint = new uint();

		public var imageFiles:Array;
		public var fileArray:Array;
		
		private var propertyFormat:TextFormat = new TextFormat();
		private var propertyTextField:TextField = new TextField();
		private var filePathText:TextField = new TextField();
		private var filePath:String = new String();
		private var propertyFont:Font = new AgencyFB();
		
		private var loadedFrameWidth:uint;
		private var loadedFrameHeight:uint;
		private var frameTotal:uint;
		private var _image:Loader;
		
		public function loadFrames():void {
			loadFiles();
			//getFrameWidth();
			//getFrameHeight();
			//getFrameTotal();
			//getImages(_index:uint);
		}
		
		public function get pathText():String {
			return filePathText.text;
		}
		
		public function set pathText(_string:String):void {
			filePathText.text = _string;
		}
		
		public function loadFiles():void {
			files.addEventListener(FileListEvent.SELECT_MULTIPLE,filesSelected);
			files.browseForOpenMultiple("Select Files", [imagesFilter]);
			/*trace("windows open : " + NativeApplication.nativeApplication.openedWindows.length);
			trace("window : " + NativeApplication.nativeApplication.openedWindows[1])*/;
		}
		
		public function getFrameWidth():uint {
			var loadedFrameWidth = fileArray[1].width;
			trace("loadFrames.getFrameWidth " + (loadedFrameWidth));
			return loadedFrameWidth;
		}
		
		public function getFrameHeight():uint {
			var loadedFrameHeight = fileArray[1].height;
			trace("loadFrames.getFrameHeight " + (loadedFrameHeight));
			return loadedFrameHeight;
		}
		
		public function getFrameTotal():uint {
			var frameTotal = imageFiles.length;
			trace("loadFrames.getFrameTotal : " + frameTotal);
			return frameTotal;
		}
		
		public function getImages(index:uint):Loader {
			var _image = fileArray;
			_image = fileArray[index];
			return _image;
		}
		
		private function filesSelected(event:FileListEvent):void {
			trace("files selected");  
			imageFiles = new Array();
			fileArray = new Array();
			frame = 0;

			for (var i:uint = 0; i < event.files.length; i++) {
				//trace(event.files[i].nativePath);
				filePath = event.files[1].nativePath;
				var fileLoader = new Loader();
				imageFiles.push(event.files[i].nativePath);
				trace(imageFiles[i]);
				
				fileArray.push(fileLoader);
				
				var url:String = imageFiles[i];
				var request:URLRequest = new URLRequest(url);
				
				fileArray[i].load(request);
				fileArray[i].contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			}
		}
		
		private function loadComplete(event:Event):void {
			trace("Frame " + frame + " Width : " + event.target.width);
			trace("Frame " + frame + " Height : " + event.target.height);
			frame++;
			
			trace("loadFrames.loadComplete.frame : " + frame);
			
			if (frame == imageFiles.length) {
				var loadedFrameWidth:uint = new uint(event.target.width);
				trace("loadFrames.loadedFrameWidth " + loadedFrameWidth);
				var loadedFrameHeight:uint = new uint(event.target.height);
				trace("loadFrames.loadedFrameHeight " + loadedFrameHeight);
				
				propertyText();
			}
		}
		
		function propertyText():void {
			trace("loadFrames.propertyText");
			propertyFormat.font = propertyFont.fontName;
			propertyFormat.size = 18;
			propertyFormat.align = TextFormatAlign.CENTER;
			propertyFormat.color = 0x000000;
			propertyFormat.letterSpacing = 0;
			//bannerFormat.bold = true;

			propertyTextField.defaultTextFormat = propertyFormat;   
			
			if (frame == 1) {
				trace("inside conditional");
				propertyTextField.text = imageFiles.length + " Frame Loaded" + "\r" + fileArray[0].width + " x " + fileArray[0].height + "\r" + (fileArray[0].width * fileArray[0].height) + " pixels";
			} else {
			propertyTextField.text = imageFiles.length + " Frames Loaded" + "\r" + fileArray[0].width + " x " + fileArray[0].height + "\r" + (fileArray[0].width * fileArray[0].height) + " pixels";
			}
			trace("loadFrames.propertyText.fileArray[0].height : " + fileArray[0].height);
			propertyTextField.autoSize = TextFieldAutoSize.LEFT;
			propertyTextField.embedFonts = true;
			propertyTextField.antiAliasType = AntiAliasType.ADVANCED;
			propertyTextField.width = 100;
			propertyTextField.height = 70;
			propertyTextField.x = 11;
			propertyTextField.y = 95;
			
			addChild(propertyTextField);
			
			propertyFormat.size = 18;
			
			filePathText.defaultTextFormat = propertyFormat;
			filePathText.autoSize = TextFieldAutoSize.LEFT;
			filePathText.embedFonts = true;
			filePathText.antiAliasType = AntiAliasType.ADVANCED;
			filePathText.x = 145;
			filePathText.y = 425;
			
			filePathText.text = filePath;
			
			addChild(filePathText);
		}
	}
}