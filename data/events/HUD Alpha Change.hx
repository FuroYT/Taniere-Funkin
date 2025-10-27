function onEvent(event) {
    if (event.event.name != "HUD Alpha Change")
        return;

    var alphaHUD:Float      = event.event.params[0];
    var notesTween:Bool     = event.event.params[1];

    var isTween:Bool        = event.event.params[2];
    var tweenTime:Float     = (Conductor.stepCrochet / 1000) * event.event.params[3];
    var tweenEase:FlxEase   = CoolUtil.flxeaseFromString(event.event.params[4], event.event.params[5]);

    var objects:Array<FlxBasic> = [];

    for (e in hudGroup) 
        objects.push(e);

    if (notesTween) {
        for (strum in playerStrums.members)
            if (strum != null)
                objects.push(strum);

        for (strum in cpuStrums.members)
            if (strum != null)
               objects.push(strum);

        for (strumLine in strumLines)
            for (note in strumLine.notes)
                objects.push(note);
    }

    for (object in objects) {
        FlxTween.cancelTweensOf(object);

        if (isTween)
            FlxTween.tween(object, {alpha: alphaHUD}, tweenTime, {ease: tweenEase});
        else
            object.alpha = alphaHUD;
    }
}