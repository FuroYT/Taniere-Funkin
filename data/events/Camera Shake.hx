function onEvent(event) {
    if (event.event.name != "Camera Shake")
        return;
    var shakeForce:Float    = event.event.params[0];
    var shakeTime:Float     = (Conductor.stepCrochet / 1000) * event.event.params[1];
    var camera:FlxCamera    = (event.event.params[3] == "camHUD") ? camHUD : camGame;

    camera.shake(shakeForce, shakeTime); 
}