function gravityEasing(t) {
    // The second comment is going to translate for those who don't speak french

    // J'aime bien expoIn donc je le prends comme base d'acceleration
    // I like expoIn so I'm going to use it as an acceleration base
    var expoInValue = FlxEase.expoIn(t);
    
    // Après la on va faire un easing qui ressemble à la gravité de la terre pour que ca rende assez naturel
    // After that we're going to make an easing that looks like earth's gravity so it looks natural
    var gravityValue = t * t * (3 - 2 * t);  // Tema l'easing de fou // That easing is crazy
    
    // Ease de transition entre expoIn et la gravité
    // Transition easing between expoIn and gravity
    var smoothTransition = t * t * (3 - 2 * t);  

    //On applique toute la merde ensemble
    //We apply all the shit together
    return expoInValue * (1 - smoothTransition) + gravityValue * smoothTransition;
}

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
            FlxTween.tween(spr, {y: - (FlxG.height * FlxG.random.float(0.4, 0.6))}, FlxG.random.float(0.5, 0.9), {ease: FlxEase.circOut});
            new FlxTimer().start(0.9, (t) -> {
                FlxTween.tween(spr, {y: 0}, 0.4, {ease: gravityEasing});
                new FlxTimer().start(0.6, (t) -> {
                    finish();
                });
            });
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