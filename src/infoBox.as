package {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.events.MouseEvent;

	public class infoBox extends Sprite {

		private var boxSprite:Sprite = new Sprite();
		private var boxField:TextField = new TextField();
		private var boxFormat:TextFormat = new TextFormat();
		private var infoFormat:TextFormat = new TextFormat();
		private var infoField:TextField = new TextField();
		private var toggleBox:Boolean = new Boolean();

		public function infoBox():void {

			drawBox(boxSprite);
			addText(boxSprite);
			registerListener(boxSprite);

			addChild(boxSprite);

		}
		private function drawBox(_boxSprite:Sprite):void {
			var sprite:Sprite = new Sprite();

			sprite.graphics.lineStyle(1,0x000000);
			sprite.graphics.beginFill(0xFFFFFF,1);
			sprite.graphics.drawRect(0,0,20,20);
			sprite.graphics.endFill();

			_boxSprite.addChild(sprite);

		}
		private function addText(_boxSprite:Sprite):void {

			boxFormat.font = "Arial";
			boxFormat.size = 18;
			boxFormat.align = TextFormatAlign.LEFT;
			boxFormat.color = 0x000000;
			boxFormat.letterSpacing = 0;
			//bannerFormat.bold = true;

			boxField.defaultTextFormat = boxFormat;
			boxField.text = "i";
			boxField.autoSize = TextFieldAutoSize.RIGHT;
			//boxField.embedFonts = true;
			boxField.antiAliasType = AntiAliasType.ADVANCED;
			boxField.selectable = false;
			boxField.x = 6.5;
			boxField.y = -2;

			_boxSprite.addChild(boxField);
		}
		private function registerListener(_boxSprite:Sprite):void {
			_boxSprite.addEventListener(MouseEvent.CLICK, openInfo);
			//_boxSprite.addEventListener(MouseEvent.MOUSE_OUT, closeInfo)
		}
		private function openInfo(event:MouseEvent):void {
			if (toggleBox) {
				closeInfo();
			} else {

				createTextBox();
			}
			//createText();
			//trace("info rollOver");
		}
		private function createTextBox():void {
			infoFormat.font = "Arial";
			infoFormat.size = 18;
			infoFormat.align = TextFormatAlign.LEFT;
			infoFormat.color = 0x000000;
			infoFormat.letterSpacing = 0;
			//bannerFormat.bold = true;

			infoField.defaultTextFormat = infoFormat;
			infoField.htmlText = "<FONT SIZE='12'>Created by " + "<a href='http://www.olivernowak.com'><u>Oliver Nowak</a></u>" + " in Actionscript 3. </FONT>";
			infoField.autoSize = TextFieldAutoSize.RIGHT;
			//boxField.embedFonts = true;
			infoField.antiAliasType = AntiAliasType.ADVANCED;
			infoField.selectable = false;
			infoField.wordWrap = true;
			infoField.width = 150;
			infoField.height = 400;
			infoField.background = true;
			infoField.backgroundColor = 0xFFFFFF;
			infoField.border = true;
			infoField.x = -150;
			infoField.y = 0;
			
			toggleBox = true;

			addChild(infoField);
		}
		private function closeInfo():void {
			toggleBox = false;
			removeChild(infoField);
		}
	}
}