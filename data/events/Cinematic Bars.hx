var barTop:FunkinSprite;
var barFloor:FunkinSprite;

function create() {
    barTop = new FunkinSprite();
    barFloor = new FunkinSprite();

    for (b=>bar in [barTop, barFloor]) {
        bar.makeGraphic(FlxG.width, 1, 0xFF000000);
        bar.scrollFactor.set(0, 0);
        bar.zoomFactor = 0;
        bar.scale.y = 0;
    }

    barTop.origin.y = 0;

    barFloor.origin.y = barFloor.height;
    barFloor.y = FlxG.height - barFloor.height;
}

function onEvent(event) {
    if (event.event.name != "Cinematic Bars")
        return;

    var heightRatio:Float   = event.event.params[0];
    var offset:Float        = event.event.params[1];
    var eAngle:Float        = event.event.params[2];

    var isTween:Bool        = event.event.params[3];
    var tweenTime:Float     = (Conductor.stepCrochet / 1000) * event.event.params[4];
    var tweenEase:FlxEase   = CoolUtil.flxeaseFromString(event.event.params[5], event.event.params[6]);
    
    var camera:FlxCamera    = (event.event.params[7] == "camHUD") ? camHUD : camGame;

    for (bar in [barTop, barFloor]) {
        FlxTween.cancelTweensOf(bar);

        var size = (FlxG.height * (bar == barTop ? offset : 1 - offset)) * heightRatio;
        
        if (isTween)
            FlxTween.tween(bar, {"scale.y": size, angle: eAngle}, tweenTime, {ease: tweenEase});
        else {
            bar.scale.y = size;
            bar.angle = eAngle;
        }

        remove(bar);
        bar.camera = camera;
        var posIndex:Int = (camera == camHUD ? 0 : members.length-1);
        insert(posIndex, bar);
    }
}