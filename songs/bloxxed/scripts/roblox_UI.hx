camGameZoomMult = camHUDZoomMult = 0;

GameOverSubstate.script = 'data/scripts/deathrblx';
PauseSubState.script = 'data/scripts/pauserblx';

introLength = 2;
function onCountdown(e) e.cancel();

function postCreate() {
    for (e in [healthBarBG, iconP1, iconP2, scoreTxt, missesTxt, accuracyTxt, comboGroup, splashHandler]) e.kill();

    healthBar.screenCenter(FlxAxes.Y);
    healthBar.y += (downscroll) ? 11 : -11;
    healthBar.x = 773;
    healthBar.angle = 90;
    healthBar.scale.set(0.1725, 0.75);

    add(healTxt = new FunkinSprite().loadGraphic(Paths.image("ui/healthtxt")));
    healTxt.x = 1025;
    healTxt.screenCenter(FlxAxes.Y);
    
    add(whiteBG = new FunkinSprite().makeSolid(960, FlxG.height, 0x69FFFFFF));
    whiteBG.screenCenter();

    add(whiteTxt = new FunkinText(0, 0, FlxG.width, "bloxxed by dislamp", 22));
    whiteTxt.alignment = "center";
    whiteTxt.font = Paths.font("ComicNeue-Bold.ttf");
    whiteTxt.screenCenter(FlxAxes.Y);
    
    whiteBG.visible = whiteTxt.visible = false;
    for (a in [healTxt, whiteBG, whiteTxt]) a.camera = camHUD;

    add(blackBar1 = new FunkinSprite().makeSolid(160, FlxG.height, FlxColor.BLACK));

    add(blackBar2 = new FunkinSprite().makeSolid(160, FlxG.height, FlxColor.BLACK));
    blackBar2.x = FlxG.width - blackBar2.width;

    for (o in [blackBar1, blackBar2]) {
        o.scrollFactor.set();
        o.zoomFactor = 0;
    }

    camFollow.setPosition(strumLines.members[curCameraTarget].characters[0].getCameraPosition().x, strumLines.members[curCameraTarget].characters[0].getCameraPosition().y);
    FlxG.camera.snapToTarget();
}

function onSongStart() {
    whiteBG.visible = whiteTxt.visible = true;
    new FlxTimer().start(3, ()->{
        whiteBG.visible = whiteTxt.visible = false;
    });
}

public var camMove:Int = 5;
function postUpdate(e:Float) {
    if (curCameraTarget >= 0) {
        final char = strumLines.members[curCameraTarget]?.characters[0]?.getAnimName();
        if (char != null) switch(char.split('-')[0]) {
            case 'singLEFT': camFollow.x -= camMove;
            case 'singDOWN': camFollow.y += camMove;
            case 'singUP': camFollow.y -= camMove;
            case 'singRIGHT': camFollow.x += camMove;
        }
    }
}

function onSubstateOpen(e) if (paused) camHUD.visible = false;
function onSubstateClose(e) camHUD.visible = true;