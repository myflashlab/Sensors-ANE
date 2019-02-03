package
{
import com.doitflash.consts.Direction;
import com.doitflash.consts.Orientation;
import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
import com.doitflash.starling.utils.list.List;
import com.doitflash.text.modules.MySprite;

import com.luaye.console.C;

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.InvokeEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

import com.myflashlab.air.extensions.sensors.*;
import com.myflashlab.air.extensions.dependency.OverrideAir;


/**
 * ...
 * @author Hadi Tavakoli - 7/24/2016 11:25 AM
 */
public class Main extends Sprite
{
	private const BTN_WIDTH:Number = 150;
	private const BTN_HEIGHT:Number = 60;
	private const BTN_SPACE:Number = 2;
	private var _txt:TextField;
	private var _body:Sprite;
	private var _list:List;
	private var _numRows:int = 1;
	
	public function Main():void
	{
		Multitouch.inputMode = MultitouchInputMode.GESTURE;
		NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
		NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
		NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
		NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
		
		stage.addEventListener(Event.RESIZE, onResize);
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		C.startOnStage(this, "`");
		C.commandLine = false;
		C.commandLineAllowed = false;
		C.x = 20;
		C.width = 250;
		C.height = 150;
		C.strongRef = true;
		C.visible = true;
		C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
		
		_txt = new TextField();
		_txt.autoSize = TextFieldAutoSize.LEFT;
		_txt.antiAliasType = AntiAliasType.ADVANCED;
		_txt.multiline = true;
		_txt.wordWrap = true;
		_txt.embedFonts = false;
		_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>Sensors ANE V" + Sensors.VERSION + "</font>";
		_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
		this.addChild(_txt);
		
		_body = new Sprite();
		this.addChild(_body);
		
		_list = new List();
		_list.holder = _body;
		_list.itemsHolder = new Sprite();
		_list.orientation = Orientation.VERTICAL;
		_list.hDirection = Direction.LEFT_TO_RIGHT;
		_list.vDirection = Direction.TOP_TO_BOTTOM;
		_list.space = BTN_SPACE;
		
		init();
		onResize();
	}
	
	private function onInvoke(e:InvokeEvent):void
	{
		NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
	}
	
	private function handleActivate(e:Event):void
	{
		NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
	}
	
	private function handleDeactivate(e:Event):void
	{
		NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
	}
	
	private function handleKeys(e:KeyboardEvent):void
	{
		if(e.keyCode == Keyboard.BACK)
		{
			e.preventDefault();
			NativeApplication.nativeApplication.exit();
		}
	}
	
	private function onResize(e:* = null):void
	{
		if(_txt)
		{
			_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
			
			C.x = 0;
			C.y = _txt.y + _txt.height + 0;
			C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
			C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
		}
		
		if(_list)
		{
			_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
			_list.row = _numRows;
			_list.itemArrange();
		}
		
		if(_body)
		{
			_body.y = stage.stageHeight - _body.height;
		}
	}
	
	private function init():void
	{
		// Remove OverrideAir debugger in production builds
		OverrideAir.enableDebugger(function ($ane:String, $class:String, $msg:String):void
		{
			trace($ane+" ("+$class+") "+$msg);
		});
		
		Sensors.init();
		
		// applies to Android only. On iOS you can't control the delay
		Sensors.setSensorDelay(Sensors.SENSOR_DELAY_NORMAL);
		
		//----------------------------------------------------------------------
		
		var btn1:MySprite = createBtn("listen to ACCELEROMETER", 0xDFE4FF);
		btn1.addEventListener(MouseEvent.CLICK, startAccelerometer);
		_list.add(btn1);
		
		function startAccelerometer(e:MouseEvent):void
		{
			Sensors.listener.addEventListener(SensorsEvents.ACCELEROMETER, onAccelerometer);
		}
		
		//----------------------------------------------------------------------
		
		var btn2:MySprite = createBtn("Stop ACCELEROMETER", 0xDFE4FF);
		btn2.addEventListener(MouseEvent.CLICK, stopAccelerometer);
		_list.add(btn2);
		
		function stopAccelerometer(e:MouseEvent):void
		{
			Sensors.listener.removeEventListener(SensorsEvents.ACCELEROMETER, onAccelerometer);
		}
		
		//----------------------------------------------------------------------
		
		var btn3:MySprite = createBtn("listen to USER_ACCELEROMETER", 0xbac0e0);
		btn3.addEventListener(MouseEvent.CLICK, startUserAccelerometer);
		_list.add(btn3);
		
		function startUserAccelerometer(e:MouseEvent):void
		{
			Sensors.listener.addEventListener(SensorsEvents.USER_ACCELEROMETER, onUserAccelerometer);
		}
		
		//----------------------------------------------------------------------
		
		var btn4:MySprite = createBtn("Stop USER_ACCELEROMETER", 0xbac0e0);
		btn4.addEventListener(MouseEvent.CLICK, stopUserAccelerometer);
		_list.add(btn4);
		
		function stopUserAccelerometer(e:MouseEvent):void
		{
			Sensors.listener.removeEventListener(SensorsEvents.USER_ACCELEROMETER, onUserAccelerometer);
		}
		
		//----------------------------------------------------------------------
		
		var btn5:MySprite = createBtn("listen to GYROSCOPE", 0x9fa5c6);
		btn5.addEventListener(MouseEvent.CLICK, startGyroscope);
		_list.add(btn5);
		
		function startGyroscope(e:MouseEvent):void
		{
			Sensors.listener.addEventListener(SensorsEvents.GYROSCOPE, onGyroscope);
		}
		
		//----------------------------------------------------------------------
		
		var btn6:MySprite = createBtn("Stop GYROSCOPE", 0x9fa5c6);
		btn6.addEventListener(MouseEvent.CLICK, stopGyroscope);
		_list.add(btn6);
		
		function stopGyroscope(e:MouseEvent):void
		{
			Sensors.listener.removeEventListener(SensorsEvents.GYROSCOPE, onGyroscope);
		}
	}
	
	private function onAccelerometer(e:SensorsEvents):void
	{
		trace("onAccelerometer: " + e.x, e.y, e.z);
	}
	
	private function onUserAccelerometer(e:SensorsEvents):void
	{
		trace("onUserAccelerometer: " + e.x, e.y, e.z);
	}
	
	private function onGyroscope(e:SensorsEvents):void
	{
		trace("onGyroscope: " + e.x, e.y, e.z);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	private function createBtn($str:String, $color:uint=0xDFE4FF):MySprite
	{
		var sp:MySprite = new MySprite();
		sp.addEventListener(MouseEvent.MOUSE_OVER, onOver);
		sp.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		sp.addEventListener(MouseEvent.CLICK, onOut);
		sp.bgAlpha = 1;
		sp.bgColor = $color;
		sp.drawBg();
		sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
		sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
		
		function onOver(e:MouseEvent):void
		{
			sp.bgAlpha = 1;
			sp.bgColor = 0xFFDB48;
			sp.drawBg();
		}
		
		function onOut(e:MouseEvent):void
		{
			sp.bgAlpha = 1;
			sp.bgColor = $color;
			sp.drawBg();
		}
		
		var format:TextFormat = new TextFormat("Arimo", 16, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
		
		var txt:TextField = new TextField();
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.antiAliasType = AntiAliasType.ADVANCED;
		txt.mouseEnabled = false;
		txt.multiline = true;
		txt.wordWrap = true;
		txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
		txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
		txt.defaultTextFormat = format;
		txt.text = $str;
		
		txt.y = sp.height - txt.height >> 1;
		sp.addChild(txt);
		
		return sp;
	}
}
	
}