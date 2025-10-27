var movStrength:Float = 0.0;

function onCameraMove(event){
    var dadX = 0;
    var dadY = 0;
    switch(dad.getAnimName()) {
        case "singLEFT"|"singLEFT-alt":     dadX = -movStrength; dadY = 0;
        case "singDOWN"|"singDOWN-alt":     dadY = movStrength; dadX = 0;
        case "singUP"|"singUP-alt":         dadY = -movStrength; dadX = 0;
        case "singRIGHT"|"singRIGHT-alt":   dadX = movStrength; dadY = 0;
        case "idle" | "idle-alt":           dadX = dadY = 0;
    }

    var bfX = 0;
    var bfY = 0;
    switch(boyfriend.getAnimName()) {
        case "singLEFT"|"singLEFT-alt":     bfX = -movStrength; bfY = 0;
        case "singDOWN"|"singDOWN-alt":     bfY = movStrength; bfX = 0;
        case "singUP"|"singUP-alt":         bfY = -movStrength; bfX = 0;
        case "singRIGHT"|"singRIGHT-alt":   bfX = movStrength; bfY = 0;
        case "idle" | "idle-alt":           bfCameraX = bfY = 0;
    }

    var isDad:Bool = (curCameraTarget == 0);

    event.position.x += isDad ? dadX : bfX;
    event.position.y += isDad ? dadY : bfY;
}

function onEvent(event) {
    if (event.event.name != "Camera Sing Movement")
        return;

    movStrength = event.event.params[0];
}