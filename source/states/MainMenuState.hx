package states;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;

import states.editors.MasterEditorMenu;
import options.OptionsState;

import substates.NoSecretScreen1Substate;

class MainMenuState extends MusicBeatState
{
	public static var sbEngineVersion:String = '3.0.0h';
	public static var psychEngineVersion:String = '0.7.3h';
	public static var fnfEngineVersion:String = '0.3.0 PROTOTYPE';
	public static var currentlySelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;

	var menuBackground:FlxSprite;
	var background:FlxSprite;
	var velocityBackground:FlxBackdrop;
	var zerobf:FlxSprite;
	var zerogf:FlxSprite;
	var mainSide:FlxSprite;
	var versionSb:FlxText;
	var versionPsych:FlxText;
	var versionFnf:FlxText;
	var secretText1:FlxText;
	
	var optionSelect:Array<String> = [
		'story_mode', // 0
		'freeplay', // 1
		'credits', // 2
		'options' // 3
	];

	var camFollow:FlxObject;

	var clickCount:Int = 0;
	var colorTag:FlxColor;
	public static var firstStart:Bool = true;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		Application.current.window.title = "Friday Night Funkin': SB Engine v" + sbEngineVersion;
		if (ClientPrefs.data.cacheOnGPU) Paths.clearStoredMemory();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menus", null);
		#end

		camGame = new FlxCamera();

		FlxG.cameras.reset(camGame);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionSelect.length - 4)), 0.1);
		menuBackground = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		menuBackground.scrollFactor.set(0, yScroll);
		menuBackground.setGraphicSize(Std.int(menuBackground.width * 1.175));
		menuBackground.updateHitbox();
		menuBackground.screenCenter();
		menuBackground.antialiasing = ClientPrefs.data.antialiasing;
		menuBackground.color = 0xfffde871;
		add(menuBackground);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		background = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		background.setGraphicSize(Std.int(background.width * 1.175));
		background.scrollFactor.x = 0;
		background.scrollFactor.y = 0;
		background.updateHitbox();
		background.screenCenter();
		background.visible = false;
		background.antialiasing = ClientPrefs.data.antialiasing;
		switch (ClientPrefs.data.themes) {
			case 'SB Engine':
				background.color = FlxColor.BROWN;
			
			case 'Psych Engine':
				background.color = 0xFFea71fd;
		}
		add(background);

		velocityBackground = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x70000000, 0x0));
		velocityBackground.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		velocityBackground.visible = ClientPrefs.data.velocityBackground;
		velocityBackground.scrollFactor.x = 0;
		velocityBackground.scrollFactor.y = 0;
		add(velocityBackground);

		zerogf = new FlxSprite();
		zerogf.frames = Paths.getSparrowAtlas('menu_GFZ');
		zerogf.antialiasing = ClientPrefs.data.antialiasing;
		zerogf.animation.addByPrefix('idle',"idle",12);	
		zerogf.animation.play('idle');
		zerogf.scrollFactor.set(0, 0.1);
		zerogf.scale.x = 0.9;
		zerogf.scale.y = 0.9;
		zerogf.x = -500;
		zerogf.screenCenter(Y);
		add(zerogf);

		FlxTween.tween(zerogf, {x:-90}, 2.4, {ease: FlxEase.expoInOut});

		zerobf = new FlxSprite();
		zerobf.frames = Paths.getSparrowAtlas('menu_BFZ');
		zerobf.antialiasing = ClientPrefs.data.antialiasing;
		zerobf.animation.addByPrefix('idle',"idle",12);	
		zerobf.animation.play('idle');
		zerobf.scrollFactor.set(0, 0.1);
		zerobf.scale.x = 0.9;
		zerobf.scale.y = 0.9;
		zerobf.x = -500;
		zerobf.screenCenter(Y);
		add(zerobf);

		FlxTween.tween(zerobf, {x:-80}, 2.4, {ease: FlxEase.expoInOut});

		mainSide = new FlxSprite(0).loadGraphic(Paths.image('mainSide'));
		mainSide.scrollFactor.x = 0;
		mainSide.scrollFactor.y = 0;
		mainSide.setGraphicSize(Std.int(mainSide.width * 0.75));
		mainSide.updateHitbox();
		mainSide.screenCenter();
		mainSide.antialiasing = ClientPrefs.data.antialiasing;
		mainSide.x = 1500;
		mainSide.y = -90;
		add(mainSide);

		FlxTween.tween(mainSide, {x: 700}, 2.2, {ease: FlxEase.quartInOut});
		

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;

		for (i in 0...optionSelect.length)
		{
			var offset:Float = 108 - (Math.max(optionSelect.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(FlxG.width * -1.5, (i * 140)  + offset);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionSelect[i]);
			menuItem.animation.addByPrefix('idle', optionSelect[i] + " basic", 12);
			menuItem.animation.addByPrefix('selected', optionSelect[i] + " white", 12);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.scale.x = 0.7;
			menuItem.scale.y = 0.7;
			menuItem.scrollFactor.set(0, yScroll);
			FlxTween.tween(menuItem, {x: menuItem.width / 4 + (i * 60) - 75}, 1.3, {ease: FlxEase.sineInOut});
			menuItems.add(menuItem);
			menuItem.x = 1500;
			var scr:Float = (optionSelect.length - 4) * 0.135;
			if(optionSelect.length < 6) scr = 0;
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.updateHitbox();

		
			switch (i)
			{
			    case 0:
				FlxTween.tween(menuItem, {x:164}, 2.2, {ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{
				finishedFunnyMove = true;
			        changeItem();
			               }	
			        });
				menuItem.y = 2;

			    case 1:
				FlxTween.tween(menuItem, {x:134}, 2.2, {ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{
				finishedFunnyMove = true;
			        changeItem();
			               }	
			        });
				menuItem.y = 41;

			    case 2:
				FlxTween.tween(menuItem, {x:114}, 2.2, {ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{
				finishedFunnyMove = true;
			        changeItem();
			               }	
			        });
				menuItem.y = 9;

			    case 3:
				FlxTween.tween(menuItem, {x:104}, 2.2, {ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{
				finishedFunnyMove = true;
			        changeItem();
			               }	
			        });
				menuItem.y = 34;	
					
			}
		}
		
					           
		FlxG.camera.flash(FlxColor.BLACK, 1.5);

		//FlxG.camera.follow(camFollow, null, 0);

		
		versionSb = new FlxText(12, FlxG.height - 64, 0, "SB Engine v" + sbEngineVersion + " (Modified Psych Engine)" #if debug + " (Running currently on Debug build) " #end, 16);
		versionPsych = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion #if debug + " (Running currently on Debug build) " #end, 16);
		versionFnf = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + fnfEngineVersion #if debug + " (Running currently on Debug build) " #end, 16);
		secretText1 = new FlxText(515, FlxG.height - 24, 0, "Press S For the secret screen!", 16);
		#if android secretText1.text = "Press BACK On your navigation bar for the secret screen!"; #end
		switch (ClientPrefs.data.gameStyle) {
			case 'SB Engine':
				versionSb.setFormat("Bahnschrift", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionPsych.setFormat("Bahnschrift", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionFnf.setFormat("Bahnschrift", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				secretText1.setFormat("Bahnschrift", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

			case 'Psych Engine' | 'Kade Engine' | 'Cheeky':
				versionSb.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionPsych.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionFnf.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				secretText1.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
			case 'Dave and Bambi':
				versionSb.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionPsych.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionFnf.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				secretText1.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
			case 'TGT Engine':
				versionSb.setFormat("Calibri", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionPsych.setFormat("Calibri", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				versionFnf.setFormat("Calibri", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				secretText1.setFormat("Calibri", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		versionSb.scrollFactor.set();
		versionPsych.scrollFactor.set();
		versionFnf.scrollFactor.set();
		secretText1.scrollFactor.set();
		add(versionSb);
		add(versionPsych);
		add(versionFnf);
		add(secretText1);

		if (ClientPrefs.data.cacheOnGPU) Paths.clearUnusedMemory();

		changeItem();

   	 	#if mobile
    	addVirtualPad(UP_DOWN, A_B_C);
   		#end

		super.create();
	}

	override function closeSubState() {
		changeItem(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	var selectedSomething:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if (!selectedSomething)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.mouse.visible = false;
				selectedSomething = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(() -> new TitleState());
			}

			if (controls.ACCEPT)
			{
				switchToState();
			}

			#if (desktop || android)
			else if (controls.justPressed('debug_1') #if android || MusicBeatState.virtualPad.buttonC.justPressed #end)
			{
				FlxG.mouse.visible = false;
				selectedSomething = true;
				FlxG.switchState(() -> new MasterEditorMenu());
			}
			#end

			if (FlxG.keys.justPressed.S #if android || FlxG.android.justReleased.BACK #end) 
			{
				FlxG.mouse.visible = false;
				FlxG.sound.play(Paths.sound('cancelMenu'), 1);
				persistentUpdate = false;
				#if android
				removeVirtualPad();
				#end
				openSubState(new NoSecretScreen1Substate());
			}

			if (ClientPrefs.data.objects) {
				if (FlxG.mouse.justPressed) backgroundColorClickChanger();
				#if !android FlxG.mouse.visible = true; #end
			} else {
				FlxG.mouse.visible = false;
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	var zoomTween:FlxTween;
	var lastBeatHit:Int = -1;
	override public function beatHit()
	{
		super.beatHit();

		if(lastBeatHit == curBeat)
		{
			return;
		}

		if(curBeat % 4 == 2)
		{
			FlxG.camera.zoom = 1.15;

			if(zoomTween != null) zoomTween.cancel();
			if (ClientPrefs.data.camZooms) {
				switch (ClientPrefs.data.gameStyle) {
					case 'SB Engine' | 'Psych Engine' | 'TGT Engine' | 'Kade Engine':
						zoomTween = FlxTween.tween(FlxG.camera, {zoom: 1}, 1, {ease: FlxEase.sineInOut, onComplete: function(twn:FlxTween)
						{
							zoomTween = null;
						}
					});
				
					case 'Cheeky':
						zoomTween = FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD, onComplete: function(twn:FlxTween)
							{
								zoomTween = null;
							}
					});
				}
			}

		}
		lastBeatHit = curBeat;
	}

	function changeItem(huh:Int = 0, bool:Bool = true)
	{
		if (finishedFunnyMove) {
			currentlySelected += huh;

			if (currentlySelected >= menuItems.length)
				currentlySelected = 0;
			if (currentlySelected < 0)
				currentlySelected = menuItems.length - 1;
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == currentlySelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}

	function switchToState() {
		selectedSomething = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));

			if (ClientPrefs.data.flashing)
				FlxFlicker.flicker(background, 1.1, 0.15, false);

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (currentlySelected == spr.ID)
				{
					FlxTween.tween(spr, {y : 700}, 1.5, {ease: FlxEase.sineInOut,});	
					FlxTween.tween(mainSide, {x:  1500}, 2.2, {ease: FlxEase.sineInOut, type: ONESHOT, startDelay: 0});
					FlxTween.tween(zerobf, {x:  -700}, 2.2, {ease: FlxEase.sineInOut, type: ONESHOT, startDelay: 0});
					FlxTween.tween(zerogf, {x:  -700}, 2.2, {ease: FlxEase.sineInOut, type: ONESHOT, startDelay: 0});
				}
				if (currentlySelected != spr.ID)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.4, {ease: FlxEase.sineInOut,});
					FlxTween.tween(mainSide, {alpha: 0}, 0.4, {ease: FlxEase.sineInOut,});
					FlxTween.tween(spr, {x : -500}, 0.55, {ease: FlxEase.sineInOut, onComplete: function(twn:FlxTween)
					{
						spr.kill();
					}
				});					
			} else {
				FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					var daChoice:String = optionSelect[currentlySelected];

				switch (daChoice) {
					case 'story_mode':
						FlxG.mouse.visible = false;
						FlxG.switchState(() -> new StoryMenuState());
					case 'freeplay':
						FlxG.mouse.visible = false;
						FlxG.switchState(() -> new FreeplayState());
					case 'credits':
						FlxG.mouse.visible = false;
						FlxG.switchState(() -> new CreditsState());
					case 'options':
						FlxG.mouse.visible = false;
						FlxG.switchState(() -> new options.OptionsState());
						OptionsState.onPlayState = false;
						if (PlayState.SONG != null)
						{
							PlayState.SONG.arrowSkin = null;
							PlayState.SONG.splashSkin = null;
						}
					}
				});
			}
		});
	}
	
	function backgroundColorClickChanger()
	{
		if(clickCount > 5)
			clickCount = 0;
			
		switch(clickCount)
		{
			case 0:
				colorTag = FlxColor.BROWN;
			case 1:
				colorTag = FlxColor.ORANGE;
			case 2:
				colorTag = FlxColor.GREEN;
			case 3:
				colorTag = FlxColor.BLUE;
			case 4:
				colorTag = FlxColor.BROWN;
			case 5:
				colorTag = FlxColor.CYAN;
		}

		FlxTween.color(menuBackground, 1.3, colorTag, 0xFFea71fd, {ease: FlxEase.sineInOut});
		clickCount++;	
	}
}
