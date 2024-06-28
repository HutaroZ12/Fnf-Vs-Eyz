package states.stages;

class ZeroWeek1 extends BaseStage
{
    var layer1:FlxSprite;
	var layer2:FlxSprite;
	var layer3:FlxSprite;
	var layer4:FlxSprite;
	var layer5:FlxSprite;
	var healthEdge:FlxSprite;
	var blackBars:FlxSprite;
	
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
        
        blackBars = new BGSprite('menuExtend/PlayState/blackBars', 0, 0);
        blackBars.scrollFactor.set(1, 1);
        blackBars.scale.x = 1;
        blackBars.scale.y = 1;
        blackBars.camera = camHUD;
        add(blackBars);

	healthEdge = new BGSprite('healthEdge', 0, 0);
        healthEdge.scrollFactor.set(1, 1);
        healthEdge.scale.x = 1;
        healthEdge.scale.y = 1;
        healthEdge.camera = camHUD;
        add(healthEdge);
	}	
}
