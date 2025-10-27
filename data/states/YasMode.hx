import YasPlatformer;
import openfl.Lib;

// HAXE AND NDLL CODE BY LUNAR CREDIT IF USE!!
import funkin.backend.utils.NdllUtil;

var enable_window_transperency:Void->Void = NdllUtil.getFunction("transparent", "win32_enable_window_transparent", 0);
var disable_window_transperency:Void->Void = NdllUtil.getFunction("transparent", "win32_disable_window_transparent", 0);

function setWindowTransparent(transparent:Bool) {
	if (transparent) {
		enable_window_transperency();
		FlxG.cameras.cameraAdded.add(transparentFlxCamera);

		for (camera in FlxG.cameras.list) transparentFlxCamera(camera);
		Lib.application.window.stage.color = null;
	} else {
		disable_window_transperency();
		FlxG.cameras.cameraAdded.remove(transparentFlxCamera);
	}
}

function transparentFlxCamera(camera:FlxCamera) {
	if (camera != null) camera.bgColor = 0x00000000;
}

var yas:YasPlatformer;
function create() {
    yas = new YasPlatformer();
    FlxG.sound.music.resume();
    var bg = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF8B4444);
    add(bg);

    for (i in 0...100)
    {
        var mult = 1 - (i / 100);
        var floor = new FlxSprite(0, 700 - (5 * i)).makeGraphic(FlxG.width * mult, 5, 0xFFFFFFFF);
        //add(floor);
        //floor.angle = mult * 360;
        //yas.collideWith.push(floor);
    }
    var floor = new FlxSprite(0, 700).makeGraphic(FlxG.width, 5, 0xFFFFFFFF);
    add(floor);
    yas.collideWith.push(floor);
    var floor = new FlxSprite().makeGraphic(FlxG.width * 0.8, 5, 0xFFFFFFFF);
    add(floor);
    floor.screenCenter();
    floor.onDraw = (spr) -> {
        spr.angle = (spr.angle + FlxG.elapsed * 10) % 360;
        spr.draw();
    }
    yas.collideWith.push(floor);

    add(yas);
    yas.debugMode = true;

    window.onMove.add(onWindowMove);
    onWindowMove(window.x, window.y);
}

var shakeItensity = 0;
var windowPosX;
var windowPosY;
function onWindowMove(x, y) {
	windowPosX = x;
	windowPosY = y;
}

var checkGod = false;
function update(elapsed:Float)
{
    if (shakeItensity > 0)
	{
		window.x = windowPosX + FlxG.random.float(-shakeItensity, shakeItensity) * 2.5;
		window.y = windowPosY + FlxG.random.float(-shakeItensity, shakeItensity) * 2.5;
	}
    if (yas.isGod && !checkGod)
    {
        checkGod = true;
        FlxG.sound.music.pause();
        new FlxTimer().start(0.6, () -> {
            FlxTween.num(30, 0, 1, {ease: FlxEase.quadInOut}, function(v)
			{
				shakeItensity = v;
			});
            FlxG.sound.play(Paths.sound("vanish"));
            window.borderless = true;
            setWindowTransparent(true);
            for (spr in members)
            {
                if (spr != yas)
                    FlxTween.tween(spr, {alpha: 0}, 0.5);
            }
            FlxTween.cancelTweensOf(yas);
        });
    }   
}

function destroy() {
    window.x = windowPosX; window.y = windowPosY;
    window.onMove.remove(onWindowMove);
    window.borderless = false;
    setWindowTransparent(false);
}