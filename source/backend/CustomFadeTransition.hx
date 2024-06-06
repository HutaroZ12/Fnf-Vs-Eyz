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
	var loadAlpha:FlxSprite;
	
	var loadLeftTween:FlxTween;
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
		loadLeft = new FlxSprite(isTransIn ? 0 : -1280, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingL'));
		loadLeft.scrollFactor.set();
		loadLeft.antialiasing = ClientPrefs.data.antialiasing;
		add(loadLeft);
		loadLeft.setGraphicSize(FlxG.width, FlxG.height);
		loadLeft.updateHitbox();
		
		if(!isTransIn) {
		    try{	
			loadLeftTween = FlxTween.tween(loadLeft, {x: 10}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});
					
		}
		else {
		    try{	    
			loadLeftTween = FlxTween.tween(loadLeft, {x: -1280}, duration, {
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

		} else {
		    try{	    
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
