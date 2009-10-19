package {
	import flash.geom.*;
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.text.AntiAliasType;
	import flash.text.*;
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
	import flash.filesystem.*;
	import images.JPGEncoder;
	import images.BitString;
	import flash.utils.ByteArray;

	public class drawInterface extends Sprite {

		private var bannerFormat:TextFormat = new TextFormat();
		private var bannerTextField:TextField = new TextField();
		private var bannerFont:Font = new PixelFont();
		private var propertyBanner:Shape;
		private var algoBox:Shape;
		private var buttonPaths:Shape;

		private var buttonFont:Font = new AgencyFB();
		private var buttonBanner:Shape;
		private var spliceArea:Shape = new Shape();
		private var versionTextField:TextField = new TextField();
		private var versionTextFormat:TextFormat = new TextFormat();
		private var bannerMatrix:Matrix = new Matrix();
		private var spliceAreaTextFormat:TextFormat = new TextFormat();
		private var spliceAreaTextField:TextField = new TextField();

		private var _spliceImageWidth:uint;
		private var _spliceImageHeight:uint;
		private var _spliceImageTotal:uint;
		private var _spliceImageArray:Array;
		
		private var buttonMatrix:Matrix = new Matrix();
		private var algoMatrix:Matrix = new Matrix();
		
		private var shadow:DropShadowFilter = new DropShadowFilter();
		
		public function drawInterface() {
			
			drawBanner();
			bannerText();
			drawPropertyBanner();
			drawAlgoBanner();
			drawButtonBanner();
			drawSpliceArea();
			versionText();
			spliceAreaText();
		
		}
		
		public function setSpliceAlpha(_trans:Number):void {
			spliceArea.alpha = _trans;
		}
		
		
		private function drawBanner():void {
			var banner = new Shape();
			var bannerMatrix:Matrix = new Matrix();

			bannerMatrix.createGradientBox(607, 72, 0, 0, 0);
			banner.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0x000000], [1,1], [0x00, 0xFF], bannerMatrix, SpreadMethod.PAD);
			banner.graphics.drawRect(0,0,607, 72);
			banner.graphics.endFill();
			banner.x = 8;
			banner.y = 9;
			banner.alpha = .75;
			
			shadow.quality = BitmapFilterQuality.HIGH;
			shadow.distance = 3;
			shadow.strength = 1;
			shadow.alpha = 1;
			shadow.color = 0x000000;
			shadow.angle = 135;
			
			banner.filters = [shadow];

			
			addChild(banner);
		}
		private function drawPropertyBanner():void {
			var propertyBanner = new Shape();

			propertyBanner.graphics.lineStyle(2, 0xCCCCCC, 0);
			propertyBanner.graphics.beginFill(0xCCCCCC, 100);
			propertyBanner.graphics.drawRect(0,0,118, 96);
			propertyBanner.graphics.endFill();

			propertyBanner.x = 8;
			propertyBanner.y = 88;
			
			propertyBanner.alpha = .75;
			
			propertyBanner.filters = [shadow];

			addChild(propertyBanner);
		}
		private function drawAlgoBanner():void {
			var algoBox = new Shape();
			var algoMatrix:Matrix = new Matrix();
			
			algoMatrix.createGradientBox(45, 258, 4.71, 0, 0);
			algoBox.graphics.beginGradientFill(GradientType.LINEAR, [0x666666, 0xCCCCCC], [1,1], [0x00, 0xFF], algoMatrix, SpreadMethod.PAD);

			algoBox.graphics.lineStyle(0, 0x666666, 0);
			//algoBox.graphics.beginFill(0xCCCCCC, 100);
			algoBox.graphics.drawRect(0,0,45, 258);
			algoBox.graphics.endFill();

			algoBox.x = 8;
			algoBox.y = 192;
			
			algoBox.alpha = .75;
			
			algoBox.filters = [shadow];

			addChild(algoBox);
		}
		private function drawButtonBanner():void {
			var buttonBanner = new Shape();
			var buttonMatrix:Matrix = new Matrix();
			
			buttonMatrix.createGradientBox(67,143,1.57,0,0);
			buttonBanner.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x666666], [1,1], [0x00, 0xFF], buttonMatrix, SpreadMethod.PAD);

			buttonBanner.graphics.lineStyle(0, 0x666666, 0);
			//buttonBanner.graphics.beginFill(0x000000, 100);
			buttonBanner.graphics.drawRect(0,0,67, 143);
			buttonBanner.graphics.endFill();

			buttonBanner.x = 60;
			buttonBanner.y = 307;
			
			buttonBanner.alpha = .75
			
			buttonBanner.filters = [shadow];

			addChild(buttonBanner);
		}
		private function drawSpliceArea():void {
			

			spliceArea.graphics.lineStyle(0, 0x666666, 0);
			spliceArea.graphics.beginFill(0xCCCCCC, 100);
			spliceArea.graphics.drawRect(0,0,482, 362);
			spliceArea.graphics.endFill();

			spliceArea.x = 133;
			spliceArea.y = 88;
			
			spliceArea.alpha = .75;
			
			spliceArea.filters = [shadow];

			addChild(spliceArea);
		}
		private function bannerText():void {

			bannerFormat.font = bannerFont.fontName;
			bannerFormat.size = 48;
			bannerFormat.align = TextFormatAlign.RIGHT;
			bannerFormat.color = 0x000000;
			bannerFormat.letterSpacing = 12;
			//bannerFormat.bold = true;

			bannerTextField.defaultTextFormat = bannerFormat;
			bannerTextField.text = "pixel.Splicer";
			bannerTextField.autoSize = TextFieldAutoSize.RIGHT;
			bannerTextField.embedFonts = true;
			bannerTextField.antiAliasType = AntiAliasType.ADVANCED;
			bannerTextField.x = 14;
			bannerTextField.y = 20;

			var myAntiAliasSettings = new CSMSettings(12, 100, -.1);
			var myAliasTable:Array = new Array(myAntiAliasSettings);
			TextRenderer.setAdvancedAntiAliasingTable("bannerFont", FontStyle.ITALIC, TextColorType.DARK_COLOR, myAliasTable);

			addChild(bannerTextField);
		}
		private function versionText():void {
			versionTextFormat.font = buttonFont.fontName;
			versionTextFormat.size = 18;
			versionTextFormat.align = TextFormatAlign.RIGHT;
			versionTextFormat.color = 0xCCCCCC;
			versionTextFormat.letterSpacing = 0;
			bannerFormat.bold = true;

			versionTextField.defaultTextFormat = versionTextFormat;
			versionTextField.text = "v.1.0";
			versionTextField.autoSize = TextFieldAutoSize.RIGHT;
			versionTextField.embedFonts = true;
			versionTextField.antiAliasType = AntiAliasType.ADVANCED;
			versionTextField.x = 584;
			versionTextField.y = 56;

			addChild(versionTextField);
		}
		private function spliceAreaText():void {
			spliceAreaTextFormat.font = buttonFont.fontName;
			spliceAreaTextFormat.size = 18;
			spliceAreaTextFormat.align = TextFormatAlign.CENTER;
			spliceAreaTextFormat.color = 0x000000;
			spliceAreaTextFormat.letterSpacing = 2;
			//bannerFormat.bold = true;

			spliceAreaTextField.defaultTextFormat = spliceAreaTextFormat;
			spliceAreaTextField.text = "Splice Area" + "\r480 x 360";
			spliceAreaTextField.autoSize = TextFieldAutoSize.RIGHT;
			spliceAreaTextField.embedFonts = true;
			spliceAreaTextField.antiAliasType = AntiAliasType.ADVANCED;
			spliceAreaTextField.x = 352;
			spliceAreaTextField.y = 266;

			addChild(spliceAreaTextField);
		}
		
	}
}