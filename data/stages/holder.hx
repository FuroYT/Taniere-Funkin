public var lol = true;

function onCameraMove() {
    if (curCameraTarget == 0) {
        if (!lol) {
            lol = true;
            defaultCamZoom = 0.45;


            FlxTween.tween(dad, {x: dad.x + 150.5}, 1, {ease: FlxEase.sineOut});
            FlxTween.tween(boyfriend, {x: boyfriend.x + 150.5}, 1, {ease: FlxEase.sineOut});

            FlxTween.num(floor.skew.x, 16.5, 1, { type: FlxTween.ONESHOT, ease: FlxEase.sineOut }, function(value:Float) {
                floor.skew.x = value;
            });

        }
    }
    if (curCameraTarget == 1) {
        if (lol) {
            lol = false;
            defaultCamZoom = 0.5;


            FlxTween.tween(dad, {x: dad.x - 152.5}, 1, {ease: FlxEase.sineOut});
            FlxTween.tween(boyfriend, {x: boyfriend.x - 150.5}, 1, {ease: FlxEase.sineOut});

            FlxTween.num(floor.skew.x, -16.5, 1, { type: FlxTween.ONESHOT, ease: FlxEase.sineOut}, function(value:Float) {
                floor.skew.x = value;
            });
        }
    }
}

function postCreate(){

    floor = new FunkinSprite(0, 0).loadGraphic(Paths.image('stages/sol'));
    floor.origin.y = 0;
    floor.y = 900;
    floor.x = -520;
    floor.scale.set(1.8, 1.8);
    floor.skew.x = 7.5;
    insert(members.indexOf(dad), floor);
}   