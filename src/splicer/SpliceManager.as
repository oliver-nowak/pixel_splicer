package splicer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	public class SpliceManager extends Sprite
	{
		private var _container:BitmapData;
		private var _containerArray:Array = new Array();
		private var _loadedImage:Bitmap;
		private var _bitmapArray:Array = new Array();
		private var _loadedBitmap:Bitmap;
		private var _loadedBitmapArray:Array = new Array();
		private var _spliceContainer:BitmapData;
		private var _randomNumberGen:PM_PRNG;
		private var _randomNumber:Number;

		private var splicedImage:Bitmap = new Bitmap();
		private var clickableSprite:Sprite = new Sprite();

		private var spliceSample:Array = new Array();
		private var spliceSource:Array = new Array();

		private var inspectPixel:TextField = new TextField();
		private var formatText:TextFormat = new TextFormat();
		private var pixelSample:uint = new uint(0);
		private var inspectionFont:Font = new AgencyFB();
		
		private var scaleWidth:Number = new Number();
		private var scaleHeight:Number = new Number();
		public var iWidth:Number = new Number();
		public var iHeight:Number = new Number();
		
		public function SpliceManager()
		{
		}
		
		public function spliceImage(_imageWidth:uint, _imageHeight:uint, _frames:uint, _imageArray:Array):void {
			//iWidth = 0;
			//iHeight = 0;
			
			scaleWidth = 1;
			scaleHeight = 1;
			
			scaleBitmaps(_imageWidth, _imageHeight);//empty function
			trace("SCALE: " + iWidth);
			trace("SCALEWIDTH : " + scaleWidth);
			trace("SCALEH: " + iHeight);
			trace("SCALEHEIGHT: " + scaleHeight);
			createBitmapContainers(iWidth, iHeight, _frames);
			convertImages(_frames, _imageArray);
			
			placeBitmaps(_frames);
			
			spliceBitmaps(iWidth, iHeight, _frames);
			saveImage(_imageWidth, _imageHeight);
		}
		
		public function get Width():Number {
			return iWidth;
		}
		
		public function get Height():Number {
			return iHeight;
		}
			
		private function createBitmapContainers(_containerWidth:uint, _containerHeight:uint, _frameTotal:uint):void {
			for (var i:uint = 0; i < _frameTotal; i++) {
				var _container = new BitmapData(_containerWidth, _containerHeight, false, 0xCCCCCC);
				_containerArray.push(_container);
			}
			trace("spliceImage.createBitmapContainers.Width : " + _containerArray[0].width);
			trace("spliceImage.createBitmapContainers.Height : " + _containerArray[0].height);
			trace("spliceImage.createBitmapContainers.frameTotal : " + _frameTotal);
			trace("spliceImage.createBitmapContainers._containerArray.length : " + _containerArray.length);
		}
		private function convertImages(_imageTotal:uint, _imageBitmaps:Array):void {
			trace("spliceImage.convertImages._imageBitmaps[1].width : " + _imageBitmaps[1].width);

			for (var i:uint = 0; i < _imageTotal; i++) {
				var _loadedImage = Bitmap(_imageBitmaps[i].content);
				_bitmapArray.push(_loadedImage);
			}
			trace("spliceImage.convertImages._bitmapArray.length : " + _bitmapArray.length);
			trace("spliceImage.convertImages._bitmapArray.width : " + _bitmapArray[0].width);
		}
		private function scaleBitmaps(_iWidth:uint, _iHeight:uint):void {
			trace("SCALE: " + iWidth);
			iWidth = _iWidth;
			iHeight = _iHeight;
			
			
			if(iWidth > 399) {
				scaleWidth = 399 / iWidth;
				scaleHeight = scaleWidth;
				
				iWidth = iWidth * scaleWidth;
				iHeight = iHeight * scaleHeight;
				
				if(iHeight > 299) {
					scaleHeight = 299 / iHeight;
					scaleWidth = scaleHeight;
					
					iHeight = iHeight * scaleHeight;
					iWidth = iWidth * scaleWidth;
				}
			}
			// for IMAGES that are NOT from video files
			// this function should scale all image files to one size, SPECIFIED by the user
		}
		private function placeBitmaps(bitmapTotal:uint):void {
			for (var i:uint = 0; i < bitmapTotal; i++) {
				var scaleMatrix:Matrix = new Matrix();
				scaleMatrix.scale(scaleWidth,scaleHeight);
				_containerArray[i].draw(_bitmapArray[i], scaleMatrix);
				var _loadedBitmap = new Bitmap(_containerArray[i]);
				_loadedBitmapArray.push(_loadedBitmap);
			}
			trace("spliceImage.placeBitmaps._loadedBitmapArray.width : " + _loadedBitmapArray[0].width);
			trace("spliceImage.placeBitmaps._loadedBitmapArray.length : " + _loadedBitmapArray.length);
		}
		private function spliceBitmaps(frameWidth:uint, frameHeight:uint, maxNumber:uint):void {

			var _randomNumberGen = new PM_PRNG();
			_randomNumberGen.seed = Math.floor(Math.random()*(999999999-4545455+1))+4545455;

			var _spliceContainer:BitmapData = new BitmapData(frameWidth, frameHeight, false, 0xCCCCCC);

			trace("spliceImage.createSpliceContainer._spliceContainer.width : " + _spliceContainer.width);
			trace("spliceImage.spliceBitmaps._spliceContainer.width : " + _spliceContainer.width);

			for (var bitmapHeight:int = 0; bitmapHeight < frameHeight; bitmapHeight++) {
				//height (j)
				for (var bitmapWidth:int = 0; bitmapWidth < frameWidth; bitmapWidth++) {
					//width (k)
					for (var bitmapPixel:int = 0; bitmapPixel < 1; bitmapPixel++) {
						//pixel (l)
						var _randomNumber = _randomNumberGen.nextIntRange(0, (maxNumber - 1));
						//pixel source (n)
						_spliceContainer.copyPixels(_loadedBitmapArray[_randomNumber].bitmapData, new Rectangle(bitmapWidth+bitmapPixel, bitmapHeight, bitmapWidth+bitmapPixel+1, bitmapHeight), new Point(bitmapWidth+bitmapPixel, bitmapHeight));
						spliceSample.push(_loadedBitmapArray[_randomNumber].bitmapData.getPixel(bitmapWidth, bitmapHeight));//info for Inspect Pixel
						spliceSource.push(_randomNumber);//info for Inspect Pixel

					}
				}
			}
			//var splicedImage:Bitmap = new Bitmap(_spliceContainer);

			splicedImage = new Bitmap(_spliceContainer);
			trace("spliceImage.spliceBitmaps.splicedImage.width : " + splicedImage.width);

			clickableSprite.x = 0;
			clickableSprite.y = 0;

			addChild(clickableSprite);
			clickableSprite.addChild(splicedImage);

			clickableSprite.addEventListener(MouseEvent.CLICK, spriteClick);
			clickableSprite.addEventListener(MouseEvent.ROLL_OUT, rollout);

			addChild(inspectPixel);
		}
		
		private function saveImage(saveWidth:uint, saveHeight:uint):void {
			trace("spliceImage.saveImage.splicedImage.width : " + splicedImage.width);
			
			var testBitmapData:BitmapData = new BitmapData(saveWidth, saveHeight, false, 0xCCCCCC);
			testBitmapData.draw(splicedImage, new Matrix());
			
			var file:File = File.desktopDirectory;
			file = file.resolvePath("Spliced Images/test.jpg");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
				var data:ByteArray = getJPG(testBitmapData);
				fileStream.writeBytes(data, 0, data.length);
				fileStream.close();

			function getJPG(gene:BitmapData):ByteArray {
				var jpg:JPGEncoder = new JPGEncoder(100);
				return jpg.encode(testBitmapData);
			}
		}
		
		private function spriteClick(event:MouseEvent):void {
			trace(clickableSprite.mouseX);
			pixelSample = clickableSprite.mouseX * clickableSprite.mouseY;

			trace("Image # : " + spliceSource[pixelSample]);

			formatText.font = inspectionFont.fontName;
			formatText.size = 18;
			formatText.align = TextFormatAlign.LEFT;
			formatText.color = 0x990000;
			formatText.letterSpacing = 0;
			//bannerFormat.bold = true;

			inspectPixel.defaultTextFormat = formatText;
			inspectPixel.autoSize = TextFieldAutoSize.LEFT;
			inspectPixel.embedFonts = true;
			inspectPixel.x = 100;
			inspectPixel.y = 350;

			inspectPixel.text = "Pixel X-Coordinate : " + Math.round(clickableSprite.mouseX) + "\n"+"Pixel Y-Coordinate : " + Math.round(clickableSprite.mouseY) + "\n"+"Pixel Array Location : "+pixelSample+"\n"+"Color : 0x"+spliceSample[pixelSample].toString(16)+"\n"+"Total Sampled Pixels : "+spliceSample.length+"\n"+"Source (as array index) : "+spliceSource[pixelSample];

		}
		private function rollout(event:MouseEvent):void {
			inspectPixel.text = "";
		}

	}
}