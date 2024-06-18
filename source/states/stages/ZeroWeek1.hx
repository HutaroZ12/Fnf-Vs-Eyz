package states.stages;

import states.stages.objects.*;

class Template extends BaseStage
{
	override function create()
	{
		layer1 = new BGSprite('Stages/zero week 1/layer1', -500, -300);
        layer1.scrollFactor.set(1, 1);
        layer1.scale.x = 1.1;
        layer1.scale.y = 1.1;
        add(layer1);

		layer2 = new BGSprite('Stages/zero week 1/layer2', -500, -300);
        layer2.scrollFactor.set(1, 1);
        layer2.scale.x = 1.1;
        layer2.scale.y = 1.1;
        add(layer2);
        
        layer3 = new BGSprite('Stages/zero week 1/layer3', -500, -300);
        layer3.scrollFactor.set(1, 1);
        layer3.scale.x = 1.1;
        layer3.scale.y = 1.1;
        add(layer3);
        
        layer4 = new BGSprite('Stages/zero week 1/layer4', -500, -300);
        layer4.scrollFactor.set(0.99, 0.99);
        layer4.scale.x = 1;
        layer4.scale.y = 1;
        add(layer4);
        
        layer5 = new BGSprite('Stages/zero week 1/layer5', -500, -300);
        layer5.scrollFactor.set(0.98, 0.98);
        layer5.scale.x = 1.1;
        layer5.scale.y = 1.1;
        add(layer5);
        
        blackBars = new BGSprite('menuExtend/PlayState/blackBars', -500, -300);
        blackBars.scrollFactor.set(1, 1);
        blackBars.scale.x = 1;
        blackBars.scale.y = 1;
        blackBars.camera = camHUD;
        add(blackBars);
	}
	
	override function createPost()
	{
		// Use this function to layer things above characters!
	}

	override function update(elapsed:Float)
	{
		// Code here
	}


	// Substates for pausing/resuming tweens and timers
	override function closeSubState()
	{
		if(paused)
		{
			//timer.active = true;
			//tween.active = true;
		}
	}

	override function openSubState(SubState:flixel.FlxSubState)
	{
		if(paused)
		{
			//timer.active = false;
			//tween.active = false;
		}
	}

	// For events
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "My Event":
		}
	}
	override function eventPushed(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events that doesn't need different assets based on its values
		switch(event.event)
		{
			case "My Event":
				//precacheImage('myImage') //preloads images/myImage.png
				//precacheSound('mySound') //preloads sounds/mySound.ogg
				//precacheMusic('myMusic') //preloads music/myMusic.ogg
		}
	}
	override function eventPushedUnique(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events where its values affect what assets should be preloaded
		switch(event.event)
		{
			case "My Event":
				switch(event.value1)
				{
					// If value 1 is "blah blah", it will preload these assets:
					case 'blah blah':
						//precacheImage('myImageOne') //preloads images/myImageOne.png
						//precacheSound('mySoundOne') //preloads sounds/mySoundOne.ogg
						//precacheMusic('myMusicOne') //preloads music/myMusicOne.ogg

					// If value 1 is "coolswag", it will preload these assets:
					case 'coolswag':
						//precacheImage('myImageTwo') //preloads images/myImageTwo.png
						//precacheSound('mySoundTwo') //preloads sounds/mySoundTwo.ogg
						//precacheMusic('myMusicTwo') //preloads music/myMusicTwo.ogg
					
					// If value 1 is not "blah blah" or "coolswag", it will preload these assets:
					default:
						//precacheImage('myImageThree') //preloads images/myImageThree.png
						//precacheSound('mySoundThree') //preloads sounds/mySoundThree.ogg
						//precacheMusic('myMusicThree') //preloads music/myMusicThree.ogg
				}
		}
	}
}
