package backend;

import flixel.util.FlxGradient;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.FlxSprite;
import openfl.utils.Assets;
import flixel.FlxObject;

import states.MainMenuState;
 
class CustomFadeTransition extends FlxSubState {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var duration:Float;
	
	var loadLeft:FlxSprite;
	var loadRight:FlxSprite;
	var loadAlpha:FlxSprite;
	
	var loadLeftTween:FlxTween;
	var loadRightTween:FlxTween;
	var loadAlphaTween:FlxTween;
    
    
	public function new(duration:Float, isTransIn:Bool) {		
		this.isTransIn = isTransIn;
		this.duration = duration;
		
		super();
	}
	
	override function create()
	{
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];
		
		if(ClientPrefs.data.CustomFade == 'Move'){
		loadRight = new FlxSprite(isTransIn ? 0 : 1280, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingR'));
		loadRight.scrollFactor.set();
		loadRight.antialiasing = ClientPrefs.data.antialiasing;		
		add(loadRight);
		loadRight.setGraphicSize(FlxG.width, FlxG.height);
		loadRight.updateHitbox();
		
		loadLeft = new FlxSprite(isTransIn ? 0 : -1280, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingL'));
		loadLeft.scrollFactor.set();
		loadLeft.antialiasing = ClientPrefs.data.antialiasing;
		add(loadLeft);
		loadLeft.setGraphicSize(FlxG.width, FlxG.height);
		loadLeft.updateHitbox();
	
		if(!isTransIn) {
		    try{
			//FlxG.sound.play(Paths.sound('loading_close_move'),ClientPrefs.data.CustomFadeSound);
		        }
			loadLeftTween = FlxTween.tween(loadLeft, {x: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});
			
			loadRightTween = FlxTween.tween(loadRight, {x: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});
		
		} else {
		    try{
			    //FlxG.sound.play(Paths.sound('loading_open_move'),ClientPrefs.data.CustomFadeSound);
			}
			loadLeftTween = FlxTween.tween(loadLeft, {x: -1280}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.expoInOut});
			
			loadRightTween = FlxTween.tween(loadRight, {x: 1280}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.expoInOut});
		
			
		}
		}
		else{
		loadAlpha = new FlxSprite( 0, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingAlpha'));
		loadAlpha.scrollFactor.set();
		loadAlpha.antialiasing = ClientPrefs.data.antialiasing;		
		add(loadAlpha);
		loadAlpha.setGraphicSize(FlxG.width, FlxG.height);
		loadAlpha.updateHitbox();
	
		if(!isTransIn) {
		    try{
			  //  FlxG.sound.play(Paths.sound('loading_close_alpha'),ClientPrefs.data.CustomFadeSound);
		        }
			loadAlpha.alpha = 0;
			loadAlphaTween = FlxTween.tween(loadAlpha, {alpha: 1}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.sineInOut});
	
		} else {
		    try{
			    //FlxG.sound.play(Paths.sound('loading_open_alpha'),ClientPrefs.data.CustomFadeSound);
		    }
			loadAlphaTween = FlxTween.tween(loadAlpha, {alpha: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.sineInOut});
		
			
    		}
		}        
		
		super.create();
	}
}
