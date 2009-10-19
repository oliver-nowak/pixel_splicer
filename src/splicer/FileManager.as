package splicer
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	
	public class FileManager
	{
		private static var instance:FileManager;
		
		private var fileManager:FileManager;
		
		private var files:File = File.applicationDirectory;
		private var imagesFilter:FileFilter = new FileFilter("Images", "*.jpg");
		
		public var imageFiles:Array;
		public var fileArray:Array;
		private var filePath:String = new String();
		private var frame:uint = new uint();
		
		public static function getInstance():FileManager
		{
			if (instance == null) {
				instance = new FileManager();
			}
			return instance;
		}
		
		public function FileManager()
		{
		}
		
		public function loadFiles():void
		{	
			files.addEventListener(FileListEvent.SELECT_MULTIPLE,filesSelected);
			files.browseForOpenMultiple("Select Files", [imagesFilter]);
		}
		
		public function getFrameWidth():uint {
			var loadedFrameWidth:uint = fileArray[1].width;
			trace("loadFrames.getFrameWidth " + (loadedFrameWidth));
			return loadedFrameWidth;
		}
		
		public function getFrameHeight():uint {
			var loadedFrameHeight:uint = fileArray[1].height;
			trace("loadFrames.getFrameHeight " + (loadedFrameHeight));
			return loadedFrameHeight;
		}
		
		public function getFrameTotal():uint {
			var frameTotal:uint = imageFiles.length;
			trace("loadFrames.getFrameTotal : " + frameTotal);
			return frameTotal;
		}
		
		public function getImages(index:uint):Loader {
			var _image:Loader = new Loader();
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
				var fileLoader:Loader = new Loader();
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
			}
		}

	}
}