import flixel.addons.display.FlxBackdrop;
var tweenBf:FlxTween;
var tweenDad:FlxTween;
function create() {
    bg = new FlxBackdrop(Paths.image("stages/park/bg"), FlxAxes.X);
    insert(members.indexOf(gf)+1,bg);
    bg.antialiasing = true;
    bg.velocity.x = 200;
}

function beatHit(curBeat:Int) {
    if(tweenBf != null) tweenBf.cancel();
    if(tweenDad != null) tweenDad.cancel();
    tweenBf = FlxTween.tween(bf, {y:bf.y+20}, 1, {type:FlxTween.BACKWARD, ease:FlxEase.expoOut});
    tweenDad = FlxTween.tween(dad, {y:dad.y+20}, 1, {type:FlxTween.BACKWARD, ease:FlxEase.expoOut});
}