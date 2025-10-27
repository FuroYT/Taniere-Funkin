var movementMultiplier:Float = 0;
var angleMultiplier:Float = 0;

var speed:Float = 0;
var time:Float = 0;

function update(elapsed:Float)
    time += elapsed * speed;  

function onCameraMove(event) {
    if (event.strumLine == null || event.strumLine?.characters[0] == null) {
        resetCameraIdle();
        return;
    }
        
    if (StringTools.contains(event.strumLine.characters[0].animation.name, "sing")) {
        resetCameraIdle();
        return;
    }

    if (movementMultiplier > 0) {
        event.position.x += Math.sin(time*(30/movementMultiplier))*movementMultiplier;
        event.position.y += (Math.sin((time*(30/movementMultiplier))*2)/2)*(movementMultiplier*.6);
    }

    if (angleMultiplier > 0)
        camGame.angle = lerp(camGame.angle, (-Math.sin(time)*.5)*angleMultiplier, 0.1);
}

function onEvent(event) {
    if (event.event.name != "Camera Idle Movement")
        return;

    speed  = event.event.params[0];
    movementMultiplier  = event.event.params[1];
    angleMultiplier     = event.event.params[2];
}

function resetCameraIdle() {
    camGame.angle = lerp(camGame.angle, 0, 0.1);
    time = 0;
}