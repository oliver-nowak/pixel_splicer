package {
	import flash.display.*;
	import flash.text.*;
	import flash.geom.Matrix;

	public class buttonEngine extends SimpleButton {
		private var _width:Number;
		private var _height:Number;

		private var buttonTextField:TextField = new TextField();

		private var buttonFormat:TextFormat = new TextFormat();

		private var buttonFont:Font = new AgencyFB();
		
		public function buttonEngine(width:Number, height:Number, type:String) {
			_width = width;
			_height = height;

			switch (type) {
				case "Load" :
					upState = load_UpState("Load");
					overState = load_OverState("Load");
					downState = load_DownState("Load");
					hitTestState = upState;
					break;

				case "Splice" :
					upState = splice_UpState("Splice");
					overState = splice_OverState("Splice");
					downState = splice_DownState("Splice");
					hitTestState = upState;
					break;

				case "Clear" :
					upState = clear_UpState("Clear");
					overState = clear_OverState("Clear");
					downState = clear_DownState("Clear");
					hitTestState = upState;
					break;

				default :
					break;
			}
		}
		private function load_UpState(_type:String):Sprite {
			var sprite:Sprite = new Sprite();

			var background:Shape = createBackground();
			var loadText:TextField = createText(_type);

			sprite.addChild(background);
			sprite.addChild(loadText);

			return sprite;
		}
		private function load_OverState(_type:String):Sprite {
			var sprite = new Sprite();

			var background:Shape = createBackground2();
			var loadText:TextField = createText(_type);

			sprite.addChild(background);
			sprite.addChild(loadText);

			return sprite;
		}
		private function load_DownState(_type:String):Sprite {
			var sprite:Sprite = new Sprite();
			var background:Shape = createBackground();
			var loadText:TextField = createText(_type);

			sprite.addChild(background);
			sprite.addChild(loadText);

			return sprite;
		}
		private function clear_UpState(_type:String):Sprite {
			var sprite:Sprite = new Sprite();
			var background:Shape = createBackground();
			var loadText:TextField = createText(_type);

			sprite.addChild(background);
			sprite.addChild(loadText);
			
			return sprite;
		}
		private function clear_OverState(_type:String):Sprite {
			var sprite:Sprite = new Sprite();
			var background:Shape = createBackground2();
			var loadText:TextField = createText(_type);

			sprite.addChild(background);
			sprite.addChild(loadText);
			return sprite;
		}
		private function clear_DownState(_type:String):Sprite {
			var sprite:Sprite = new Sprite();
			var background:Shape = createBackground();
			var loadText:TextField = createText(_type);

			sprite.addChild(background);
			sprite.addChild(loadText);

			return sprite;
		}
		private function splice_UpState(_type:String):Sprite {
			var sprite:Sprite = new Sprite();
			var background:Shape = createBackground();
			var loadText:TextField = createText(_type);

			sprite.addChild(background);
			sprite.addChild(loadText);

			return sprite;
		}
		private function splice_OverState(_type:String):Sprite {
			var sprite:Sprite = new Sprite();
			var background:Shape = createBackground2();
			var loadText:TextField = createText(_type);

			sprite.addChild(background);
			sprite.addChild(loadText);
			return sprite;
		}
		private function splice_DownState(_type:String):Sprite {
			var sprite:Sprite = new Sprite();
			var background:Shape = createBackground();
			var loadText:TextField = createText(_type);

			sprite.addChild(background);
			sprite.addChild(loadText);

			return sprite;
		}
		private function createText(_type:String):TextField {
			var buttonTextField = new TextField();
			var buttonFormat = new TextFormat();
			
			buttonFormat.font = buttonFont.fontName;
			buttonFormat.size = 20;
			buttonFormat.align = TextFormatAlign.RIGHT;
			buttonFormat.color = 0x000000;
			buttonFormat.letterSpacing = 0;
			buttonFormat.bold = true;

			/*if (_type == "Splice") {
				buttonFormat.letterSpacing = 4;
			}*/

			buttonTextField.defaultTextFormat = buttonFormat;
			buttonTextField.text = _type;
			buttonTextField.autoSize = TextFieldAutoSize.CENTER;
			buttonTextField.embedFonts = true;
			buttonTextField.antiAliasType = AntiAliasType.ADVANCED;
			buttonTextField.x = 16;
			buttonTextField.y = 5;

			if (_type == "Splice") {
				buttonTextField.x = 14;
				buttonTextField.y = 5;
			}

			return buttonTextField;
		}
		private function createBackground():Shape {
			var shape = new Shape();

			shape.graphics.lineStyle(1,0x000000,1);
			shape.graphics.beginFill(0xFFFFFF,1);
			shape.graphics.drawRect(0,0,66,34);
			shape.graphics.endFill();

			return shape;
		}
		
		private function createBackground2():Shape {
			var shape = new Shape();
			var buttonMatrix:Matrix = new Matrix();
			
			buttonMatrix.createGradientBox(66,34,1.57,0,0);
			shape.graphics.beginGradientFill(GradientType.LINEAR, [0xCCCCCC, 0x666666], [1,1], [0x00, 0xFF], buttonMatrix, SpreadMethod.PAD);

			shape.graphics.lineStyle(1,0x000000,1);
			
			shape.graphics.drawRect(0,0,66,34);
			shape.graphics.endFill();

			return shape;
		}
	}
}