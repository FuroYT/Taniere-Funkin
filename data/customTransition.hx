var spr;
var spikes;
function create(event)
{
    spr = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
    add(spr);
    spikes = new FlxSprite().loadGraphic(Paths.image("transition/spikes"));
    add(spikes);
    spikes.color = 0xFF000000;
    spikes.scale.scale(1, 0.8);
    spikes.updateHitbox();
    switch (event.transOut)
    {
        case true:
            spr.y = -(spr.height + spikes.height);
            FlxTween.tween(spr, {y: 0}, 0.5, {ease: FlxEase.quartOut, onComplete: finish});
        case false:
            spikes.flipY = true;
            FlxTween.tween(spr, {y: FlxG.height + spikes.height}, FlxG.random.float(1, 1.4), {ease: FlxEase.expoOut});
            new FlxTimer().start(1.4, (t) -> {
                finish();
            });
    }

    allowSkip = false;
    event.cancel();
}

function update() {
    if (transOut)
        spikes.y = spr.y + spr.height;
    else
        spikes.y = spr.y - spikes.height;
}