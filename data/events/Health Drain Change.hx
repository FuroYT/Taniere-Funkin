var healthDrain:Float = 0;
var canDie:Bool = false;

function onDadHit() {
    health = Math.max(health - healthDrain, canDie ? 0 : 0.1);
}

function onEvent(event) {
    if (event.event.name != "Health Drain Change")
        return;

    healthDrain = event.event.params[0];
    canDie = event.event.params[1];
}