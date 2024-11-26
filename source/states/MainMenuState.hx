package states;

import backend.WeekData;
import backend.Achievements;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

import flixel.addons.display.FlxBackdrop;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;

import objects.AchievementPopup;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import openfl.Lib;

//import audio.SpectogramSprite;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.3'; //This is also used for Discord RPC
	public static var novaFlareEngineVersion:String = '1.1.3';
	public static var curSelected:Int = 0;
    public static var saveCurSelected:Int = 0;
    
	var menuItems:FlxTypedGroup<FlxSprite>;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	var optionTween:Array<FlxTween> = [];
	var selectedTween:Array<FlxTween> = [];
	var cameraTween:Array<FlxTween> = [];
	
	var optionShit:Array<String> = [
		'story_mode', // 0
		'freeplay', // 1
		//#if MODS_ALLOWED 'mods', #end
	//	#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits', // 2
		//#if !switch 'donate', #end
		'options' // 3
	];

	var magenta:FlxSprite;
	
    //var musicDisplay:SpectogramSprite;
	
	//var camFollow:FlxObject;

	var SoundTime:Float = 0;
	var BeatTime:Float = 0;
	
	var ColorArray:Array<Int> = [
		0xFF9400D3,
		0xFF4B0082,
		0xFF0000FF,
		0xFF00FF00,
		0xFFFFFF00,
		0xFFFF7F00,
		0xFFFF0000
	                                
	    ];
	public static var currentColor:Int = 1;    
	public static var currentColorAgain:Int = 0;
			
	var bgMove:FlxBackdrop;
	//public static var Mainbpm:Float = 0;
	//public static var bpm:Float = 0;
	

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		//Lib.application.window.title = "NF Engine - MainMenuState";
		
        
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end		

		camGame = initPsychCamera();
		camOther = new FlxCamera();
		camOther.bgColor.alpha = 0;
				
		FlxG.cameras.add(camOther, false);		

		persistentUpdate = persistentDraw = true;
		
		

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		
	    bgMove = new FlxBackdrop(Paths.image('backdrop'), XY, 0, 0);
		bgMove.alpha = 0.1;
		bgMove.color = ColorArray[currentColor];		
		bgMove.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		bgMove.antialiasing = ClientPrefs.data.antialiasing;
		add(bgMove);
        bgMove.screenCenter(XY);
		bg.scrollFactor.set(0, 0);
		
		/*musicDisplay = new SpectogramSprite(FlxG.sound.music);
		add(musicDisplay);*/

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.6;
		if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}

		for (i in 0...optionShit.length)
		{
			
			var menuItem:FlxSprite = new FlxSprite(-600, 0);
			menuItem.scale.x = 0.7;
			menuItem.scale.y = 0.7;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " selected", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.x = 1500;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;			
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();


			switch (i)
			{
			    case 0:
				FlxTween.tween(menuItem, {x:164}, 2.2, {ease: FlxEase.expoInOut});
				menuItem.y = 2;

			    case 1:
				FlxTween.tween(menuItem, {x:134}, 2.2, {ease: FlxEase.expoInOut});
				menuItem.y = 41;

			    case 2:
				FlxTween.tween(menuItem, {x:114}, 2.2, {ease: FlxEase.expoInOut});
				menuItem.y = 9;

			    case 3:
				FlxTween.tween(menuItem, {x:104}, 2.2, {ease: FlxEase.expoInOut});
				menuItem.y = 34;
			}	
		}  


		FlxG.camera.flash(FlxColor.BLACK, 1.5);

		//FlxG.camera.follow(camFollow, null, 0);

		//var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "NovaFlare Engine v" + novaFlareEngineVersion/* + ' - HOTFIX'*/, 12)
	//	versionShit.scrollFactor.set();
	//	versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	//	versionShit.antialiasing = ClientPrefs.data.antialiasing;
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + '0.2.8', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		versionShit.antialiasing = ClientPrefs.data.antialiasing;
		// NG.core.calls.event.logEvent('swag').send();

		checkChoose();
        
		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');
        
		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end
		
		#if !mobile
		FlxG.mouse.visible = true;
		#end
        
		addTouchPad(NONE, 'E');
        
		super.create();
	}
	
	var canBeat:Bool = true;
	var usingMouse:Bool = true;
	
	var endCheck:Bool = false;

	override function update(elapsed:Float)
	{
	
	    #if (debug && android)
	        if (FlxG.android.justReleased.BACK)
		    FlxG.debugger.visible = !FlxG.debugger.visible;
		#end
	
	
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if (!ClientPrefs.data.freeplayOld) {
			    if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		    } else {
		        if(FreeplayStatePsych.vocals != null) FreeplayStatePsych.vocals.volume += 0.5 * elapsed;
		    }
		}

		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if (FlxG.mouse.justPressed) usingMouse = true;
		
        if(!endCheck){
		
		
		if (controls.UI_UP_P)
			{
			    usingMouse = false;
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
			    changeItem(1);
			}
			
			    
			if (controls.ACCEPT) {
			    usingMouse = false;				    			    
			    
			    menuItems.forEach(function(spr:FlxSprite)
		        {
		            if (curSelected == spr.ID){
        				if (spr.animation.curAnim.name == 'selected') {
        				    checkChoose();
        				    selectSomething();
            			} else {
            			    FlxG.sound.play(Paths.sound('scrollMenu'));	
            			    spr.animation.play('selected');
            			}
        			}
    			});
		    }
		    
		menuItems.forEach(function(spr:FlxSprite)
		{
			if (usingMouse && canClick)
			{
				if (!FlxG.mouse.overlaps(spr)) {
				    if (FlxG.mouse.pressed
				    #if mobile && !FlxG.mouse.overlaps(TouchPad.buttonA) #end){
        			    spr.animation.play('idle');
    			    }
				    if (FlxG.mouse.justReleased 
				    #if mobile && !FlxG.mouse.overlaps(TouchPad.buttonA) #end){
					    spr.animation.play('idle');			        			        
			        } //work better for use virtual pad
			    }
    			if (FlxG.mouse.overlaps(spr)){
    			    if (FlxG.mouse.justPressed){
    			        if (spr.animation.curAnim.name == 'selected') selectSomething();
    			        else spr.animation.play('idle');
    			    }
    				if (FlxG.mouse.pressed){
        			    curSelected = spr.ID;
			    	
        			    if (spr.animation.curAnim.name == 'idle'){
        			        FlxG.sound.play(Paths.sound('scrollMenu'));	 
        			        spr.animation.play('selected');		
        			    }	
        			    
        			    menuItems.forEach(function(spr:FlxSprite){
            	            if (spr.ID != curSelected)
            			    {
                			    spr.animation.play('idle');
                			    spr.centerOffsets();
                			}
            		    });
    			    }   			    
			    }			    
			    if(saveCurSelected != curSelected) checkChoose();
			}
		});
		
			if (controls.BACK)
			{
				endCheck = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}		
				
			else if (controls.justPressed('debug_1') || touchPad.buttonE.justPressed)
			{
				endCheck = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			
		
        }
      
        SoundTime = FlxG.sound.music.time / 1000;
        BeatTime = 60 / bpm;
        
        if ( Math.floor(SoundTime/BeatTime) % 4  == 0 && canBeat) {
        
            canBeat = false;
           
            currentColor++;            
            if (currentColor > 6) currentColor = 1;
            currentColorAgain = currentColor - 1;
            if (currentColorAgain <= 0) currentColorAgain = 6;
            
            FlxTween.color(bgMove, 0.6, ColorArray[currentColorAgain], ColorArray[currentColor], {ease: FlxEase.cubeOut});           
			camGame.zoom = 1 + 0.015;			
			cameraTween[0] = FlxTween.tween(camGame, {zoom: 1}, 0.6, {ease: FlxEase.cubeOut});
		    
			//menuItems.forEach(function(spr:FlxSprite)	{
				//spr.scale.x = 0.7;
			//	spr.scale.y = 0.7;
				   // FlxTween.tween(spr.scale, {x: 0.7}, 0.7, {ease: FlxEase.cubeOut});
				   // FlxTween.tween(spr.scale, {y: 0.7}, 0.7, {ease: FlxEase.cubeOut});
			
				
         //   });
            
        }
        if ( Math.floor(SoundTime/BeatTime + 0.5) % 4  == 2) canBeat = true;        
        
        bgMove.alpha = 0.1;
   
		

		menuItems.forEach(function(spr:FlxSprite)
		{
		    spr.updateHitbox();
		    spr.centerOffsets();
		    spr.centerOrigin();
		});
		
		
		
		super.update(elapsed);
	}    	
    
    function selectSomething()
	{
		endCheck = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		FlxG.camera.flash(FlxColor.WHITE, 1);

//		FlxTween.tween(zerogf, {x:-1500}, 2.4, {ease: FlxEase.expoInOut});

	//	FlxTween.tween(zerobf, {x:-1500}, 2.4, {ease: FlxEase.expoInOut});

	//	FlxTween.tween(mainSide, {x:1500}, 2.2, {ease: FlxEase.expoInOut});
		
		/*if (ClientPrefs.data.flashing)
		FlxFlicker.flicker(magenta, 1.1, 0.15, false);*/

		if (cameraTween[0] != null) cameraTween[0].cancel();

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {x: 1500}, 2.2, {
								ease: FlxEase.expoInOut,
							});
							
						}
						else
						{
							

							FlxTween.tween(spr, {x: 1500}, 2.2, {
								ease: FlxEase.expoInOut,
							});

							FlxTween.tween(spr, {alpha: 0}, 2.2, {
								ease: FlxEase.expoInOut,
							});													
			}
		});

		FlxTween.tween(camGame, {zoom: 1.1}, 1.2, {ease: FlxEase.cubeInOut});
		FlxTween.tween(camGame, {angle: 0}, 0.8, { //not use for now
		        ease: FlxEase.cubeInOut,
		        onComplete: function(twn:FlxTween)
			{
			    var daChoice:String = optionShit[curSelected];

				    switch (daChoice)
					{
						case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
							case 'freeplay':
							    if (!ClientPrefs.data.freeplayOld) MusicBeatState.switchState(new FreeplayState());
								else MusicBeatState.switchState(new FreeplayStatePsych());
							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								MusicBeatState.switchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
								}
				    }
				}
		});
	}
	
	function checkChoose()
	{
	    if (curSelected >= menuItems.length)
	        curSelected = 0;
		if (curSelected < 0)
		    curSelected = menuItems.length - 1;
		    
		saveCurSelected = curSelected;
		    
	    menuItems.forEach(function(spr:FlxSprite){
	        if (spr.ID != curSelected)
			{
			    spr.animation.play('idle');
			    spr.centerOffsets();
		    }			

            if (spr.ID == curSelected && spr.animation.curAnim.name != 'selected')
			{
			    spr.animation.play('selected');
			    spr.centerOffsets();
		    }
		    
		    spr.updateHitbox();
        });        
	}
	
	
}
