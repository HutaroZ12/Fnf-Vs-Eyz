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
        
        layer5 = new BGSprite('menuExtend/PlayState/blackBars', -500, -300);
        blackBars.scrollFactor.set(1, 1);
        blackBars.scale.x = 1;
        blackBars.scale.y = 1;
        blackBars.camera = camHUD;
        add(blackBars);
	}
	
	override function eventPushed(event:objects.Note.EventNote)
	{
		switch(event.event)
		{
			case "Dadbattle Spotlight":
				dadbattleBlack = new BGSprite(null, -800, -400, 0, 0);
				dadbattleBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				dadbattleBlack.alpha = 0.25;
				dadbattleBlack.visible = false;
				add(dadbattleBlack);

				dadbattleLight = new BGSprite('spotlight', 400, -400);
				dadbattleLight.alpha = 0.375;
				dadbattleLight.blend = ADD;
				dadbattleLight.visible = false;
				add(dadbattleLight);

				dadbattleFog = new DadBattleFog();
				dadbattleFog.visible = false;
				add(dadbattleFog);
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "Dadbattle Spotlight":
				if(flValue1 == null) flValue1 = 0;
				var val:Int = Math.round(flValue1);

				switch(val)
				{
					case 1, 2, 3: //enable and target dad
						if(val == 1) //enable
						{
							dadbattleBlack.visible = true;
							dadbattleLight.visible = true;
							dadbattleFog.visible = true;
							defaultCamZoom += 0.12;
						}

						var who:Character = dad;
						if(val > 2) who = boyfriend;
						//2 only targets dad
						dadbattleLight.alpha = 0;
						new FlxTimer().start(0.12, function(tmr:FlxTimer) {
							dadbattleLight.alpha = 0.375;
						});
						dadbattleLight.setPosition(who.getGraphicMidpoint().x - dadbattleLight.width / 2, who.y + who.height - dadbattleLight.height + 50);
						FlxTween.tween(dadbattleFog, {alpha: 0.7}, 1.5, {ease: FlxEase.quadInOut});

					default:
						dadbattleBlack.visible = false;
						dadbattleLight.visible = false;
						defaultCamZoom -= 0.12;
						FlxTween.tween(dadbattleFog, {alpha: 0}, 0.7, {onComplete: function(twn:FlxTween) dadbattleFog.visible = false});
				}
		}
	}
}
