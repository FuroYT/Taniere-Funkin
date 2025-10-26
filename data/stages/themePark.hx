import flixel.addons.display.FlxBackdrop;
var tweenBf:FlxTween;
var tweenDad:FlxTween;
function create() {
    bg = new FlxBackdrop(Paths.image("stages/park/bg"), FlxAxes.X);
    insert(members.indexOf(gf)+1,bg);
    bg.antialiasing = true;
    bg.velocity.x = 200;
    trace(dad.y+20);
}

function beatHit(curBeat:Int) {
    bf.y = 100; 
    dad.y = 100; 
}

function update(elapsed:Float) {
        bf.y = FlxMath.lerp(bf.y, 0, elapsed/2.5); 
        dad.y = FlxMath.lerp(dad.y, 0, elapsed/2.5); 
}