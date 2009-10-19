////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////pixel.Splicer///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//added Splice Area "Max Dimensions" Text
//05.26.08 - v.1001 published
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TO DO:
////////add ability to change transparency of window panes
////////add ability to change color of window panes
////////add SAVE button, with user-defined file path & file name
////////scale frames larger than Splice Area Dimensions
////////add more splice algorithms
////////spliced Images save over each other - add unique ID
////////make Saved Images Folder more obvious (add text notification of file path after splice?)
////////add visual cue (text? animation?) after clicking splice button that image is being spliced (or about to be)
////////move Top-Level Functions to Classes

////////////////////////////////////////////////////////IMPORT Custom Classes///////////////////////////////////////////////
import drawInterface;///////////draws the Interface Elements
import buttonEngine;///////////draws the Buttons
import loadFrames;///////////loads Images into memory
import spliceImage;///////////splices Images
import infoBox;///////////creates Info Box
//import Square;
//import customizeNativeWindow;

//////////////////////////////////////////////////////VARIABLES/////////////////////////////////////////////////////////

//////////////////////////////////////////////////////INITIALIZE variables from imported Classes////////////////////////
var menu:drawInterface = new drawInterface();
var _infoBox:infoBox = new infoBox;
var loadButton = new buttonEngine(64,44,"Load");
var spliceButton = new buttonEngine(64,44,"Splice");
var clearButton = new buttonEngine(64,44,"Clear");
var _loadFrames:loadFrames;
var _spliceImage:spliceImage;
//var mainWindow:customizeNativeWindow = new customizeNativeWindow(main);
//var main:NativeWindow = this.stage.nativeWindow;

/////////////////////////////////////////////////////INITIALIZE GLOBAL variables////////////////////////////////////// 
var gridArray:Array = new Array();
var gridMax:Array = new Array();
var gridMin:Array = new Array();

var gridPosition:uint = new uint();
var grid_X:uint = new uint();
var grid_Y:uint = new uint();
var max_X:uint = new uint();
var max_Y:uint = new uint();
var totalSquares:uint = new uint();
var gridDepth:uint = new uint();
var gridRow:uint = new uint();
var squareCount:uint = new uint();
var depthCount:uint = new uint();
var fadeCount:uint = new uint();

var timer:Timer = new Timer(15, 108);
var fadeTimer:Timer = new Timer(15,150);
var easeTimer:Timer = new Timer(15,150);

var moveHandle:Sprite = new Sprite();
var closeHandle:Sprite = new Sprite();

var buttonShadow:DropShadowFilter = new DropShadowFilter();

//////////////////////////////////////////////////////CONSTANTS [for drawSpliceArea() function]//////////////////////////////////////
max_X = 12;
max_Y = 9;
grid_X = 134;
grid_Y = 88;
totalSquares = max_X * max_Y;
gridDepth = 0;
squareCount = 0;
depthCount = 0;
fadeCount = 0;

/////////////////////////////////////////////////////CUSTOMIZE Main Window Graphics (Optional)////////////////////////////////////////
//addChild(mainWindow);

/////////////////////////////////////////////////////CREATE and DISPLAY Interface//////////////////////////////////////////
//trace("spliceAlpha " + menu.getSpliceAlpha("test"));

addChild(menu);

//menu.setSpliceAlpha(.1);

/////////////////////////////////////////////////////CREATE Window Chrome Controls/////////////////////////////////////////
createWindowControls();

/////////////////////////////////////////////////////CREATE Info Box///////////////////////////////////////////////////////
addInfoBox();

//////////////////////////////////////////////////////CREATE and DISPLAY Buttons///////////////////////////////////////////
drawButtons();

/////////////////////////////////////////////////////DRAW and FADE OUT spliceArea Squares//////////////////////////////////
drawSpliceArea();
fadeSpliceArea();
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////Top Level FUNCTIONS /////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function addInfoBox():void {

	_infoBox.x = this.width - 55;
	_infoBox.y = 1;

	addChild(_infoBox);
}

function createWindowControls():void {
	moveHandle = createSprite(0xFFFFFF, 623, 460, 0, 0, false);
	moveHandle.alpha = 0;
	moveHandle.addEventListener(MouseEvent.MOUSE_DOWN, onStartMove);

	closeHandle = createSprite(0xFFFFFF, 20, 20, this.width - 25, 1, true);
	closeHandle.alpha = 1;
	closeHandle.addEventListener(MouseEvent.CLICK, closeApplication);
}

function createSprite(color:int, width_:uint, height_:uint, x:uint, y:uint, _char:Boolean):Sprite {
	var s:Sprite = new Sprite();
	s.graphics.lineStyle(1,0x000000);
	s.graphics.beginFill(color);
	s.graphics.drawRect(0, 0, width_, height_);
	s.graphics.endFill();
	s.x = x;
	s.y = y;
	this.addChild(s);

	if(_char) {
	var _boxFormat:TextFormat = new TextFormat();
	_boxFormat.font = "Arial";
	_boxFormat.size = 18;
	_boxFormat.align = TextFormatAlign.LEFT;
	_boxFormat.color = 0x000000;
	_boxFormat.letterSpacing = 0;
	//bannerFormat.bold = true;

	var _boxField:TextField = new TextField();
	_boxField.defaultTextFormat = _boxFormat;
	_boxField.text = "x";
	_boxField.autoSize = TextFieldAutoSize.RIGHT;
	//boxField.embedFonts = true;
	_boxField.antiAliasType = AntiAliasType.ADVANCED;
	_boxField.selectable = false;
	_boxField.x = 4.5;
	_boxField.y = -3;

	s.addChild(_boxField);
	
	}

	return s;
}

function easeSpliceArea():void {

	easeTimer.addEventListener(TimerEvent.TIMER, fadeIn);
	easeTimer.start();
}

function fadeSpliceArea():void {
	fadeTimer.reset();
	fadeTimer.addEventListener(TimerEvent.TIMER, fadeOut);
	fadeTimer.start();
}

function drawSpliceArea():void {
	for (depthCount = 0; depthCount < 9; depthCount++) {
		for (var i:uint = 0; i< 12; i++) {

			gridArray.push(new Square());
			gridPosition = grid_X + (i * 40);
			gridDepth = grid_Y + (depthCount * 40);
			trace(gridPosition);
			trace(gridDepth);
			gridMax.push(gridPosition);
			gridMin.push(gridDepth);

		}
	}
	for (squareCount = 0; squareCount < totalSquares; squareCount++) {
		gridArray[squareCount].x = gridMax[squareCount];
		gridArray[squareCount].y = gridMin[squareCount];
		gridArray[squareCount].alpha = 0;
		addChild(gridArray[squareCount]);
	}
	timer.addEventListener(TimerEvent.TIMER, animateSquare);
	timer.start();

}

function drawButtons():void {

	loadButton.x=60;
	loadButton.y=193;

	clearButton.x = 60;
	clearButton.y = 269;

	spliceButton.x = 60;
	spliceButton.y = 231;

	//loadButton.buttonMode=true;
	loadButton.addEventListener(MouseEvent.CLICK,_loadButtonDown);

	//clearButton.buttonMode = true;
	clearButton.addEventListener(MouseEvent.CLICK, _clearButtonDown);

	//spliceButton.buttonMode = true;
	spliceButton.addEventListener(MouseEvent.MOUSE_DOWN, _spliceButtonDown);

	buttonShadow.quality = BitmapFilterQuality.HIGH;
	buttonShadow.distance = 3;
	buttonShadow.strength = 1;
	buttonShadow.alpha = 1;
	buttonShadow.color = 0x000000;
	buttonShadow.angle = 135;

	loadButton.filters = [buttonShadow];
	clearButton.filters = [buttonShadow];
	spliceButton.filters = [buttonShadow];

	/*clearButton.alpha = .5;
	clearButton.mouseEnabled = false;
	
	spliceButton.alpha = .5;
	spliceButton.mouseEnabled = false;*/

	addChild(loadButton);
	addChild(spliceButton);
	addChild(clearButton);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////TIMER EVENTS///////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function clearDisplay(_tick:TimerEvent):void {
	removeChild(_loadFrames);
	removeChild(_spliceImage);

	fadeTimer.reset();
	fadeSpliceArea();
}

function fadeIn(_tick:TimerEvent):void {
	for (var i:uint = 0; i < totalSquares; i++) {
		gridArray[i].alpha +=.02;
	}
}

function fadeOut(_tick:TimerEvent):void {
	for (var i:uint = 0; i < totalSquares; i++) {
		gridArray[i].alpha -=.02;
	}
}

function animateSquare(tick:TimerEvent):void {

	gridArray[fadeCount].alpha = 1;
	fadeCount++;

	if (fadeCount == totalSquares) {
		fadeCount = totalSquares;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////MOUSE EVENTS///////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function onStartMove(event:MouseEvent):void {
	this.stage.nativeWindow.startMove();
}

function closeApplication(event:MouseEvent):void {
	this.stage.nativeWindow.close();
}

function _loadButtonDown(event:MouseEvent):void {
	trace("_loadButton hit");

	_loadFrames = new loadFrames;

	addChild(_loadFrames);

	/*clearButton.alpha = 1;
	clearButton.mouseEnabled = true;
	
	spliceButton.alpha = 1;
	spliceButton.mouseEnabled = true;*/

}

/*function added(event:Event):void {
trace("ADDED_TO_STAGE: " + event.target.name + " : " + event.currentTarget.name);

}*/

function _spliceButtonDown(event:MouseEvent):void {
	trace("_spliceButton hit");
	trace("drawButtons.getFrame Width : " + _loadFrames.getFrameWidth());
	trace("drawButtons.getFrame Height : " + _loadFrames.getFrameHeight());

	var _spliceImageWidth = new uint();
	_spliceImageWidth = _loadFrames.getFrameWidth();

	var _spliceImageHeight = new uint();
	_spliceImageHeight = _loadFrames.getFrameHeight();

	var _spliceImageTotal = new uint();
	_spliceImageTotal = _loadFrames.getFrameTotal();

	var _spliceImageArray = new Array();
	for (var i:uint = 0; i < _spliceImageTotal; i++) {
		_spliceImageArray.push(_loadFrames.getImages(i));
	}
	trace("drawButtons._spliceButtonDown._spliceImageArray.width : " + _spliceImageArray[0].width);

	_spliceImage = new spliceImage(_spliceImageWidth,_spliceImageHeight, _spliceImageTotal, _spliceImageArray);

	_spliceImage.name = "spliceImage";/////////////////////////////////////////////////////////NAME the Object for the Depth Check

	var correct_X:Number = 133;
	var correct_Y:Number = 88;

	var mid_X:Number = 240;
	var mid_Y:Number = 180;

	trace("midX : " + mid_X);

	var midImageWidth:Number =  _loadFrames.getFrameWidth() / 2;
	var midImageHeight:Number = _loadFrames.getFrameHeight() / 2;
	
	trace("SPLICEIMAGEWIDTH : " + _spliceImage.Width);
	
	_spliceImage.x = (correct_X + mid_X) - (_spliceImage.Width / 2);
	_spliceImage.y = (correct_Y + mid_Y) - (_spliceImage.Height / 2);

	//_spliceImage.x = (correct_X + mid_X) - _spliceImage.Width;
	//_spliceImage.y = (correct_Y + mid_Y) - _spliceImage.Height;
	trace("spliceX : " + _spliceImage.x);

	addChildAt(_spliceImage, 2);

	//addChild(_spliceImage);
	//var target:DisplayObject = getChildByName("spliceImage");////////////////////////////////Image DEPTH CHECK/////////////
	//trace("splice Image depth : " + getChildIndex(target)); 
}
function _clearButtonDown(event:MouseEvent):void {
	_loadFrames.pathText = "";
	easeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, clearDisplay);
	easeTimer.reset();
	easeSpliceArea();
}