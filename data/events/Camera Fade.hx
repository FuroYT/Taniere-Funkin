function onEvent(event) {
    if (event.event.name != "Camera Fade")
        return;

    var isReversed:Bool     = event.event.params[0];
    var fadeColor:Int       = event.event.params[1];
    var fadeTime:Float      = (Conductor.stepCrochet / 1000) * event.event.params[2];
    var camera:FlxCamera    = (event.event.params[3] == "camHUD") ? camHUD : camGame;

    camera.fade(fadeColor, fadeTime, !isReversed);
}