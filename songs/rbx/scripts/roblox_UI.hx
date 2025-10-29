camGameZoomMult = camHUDZoomMult = 0;

//PauseSubState.script = 'data/scripts/bloxpause';

function onCountdown(e) e.cancel();

function postCreate() {
    for (e in [healthBarBG, iconP1, iconP2, scoreTxt, missesTxt, accuracyTxt, comboGroup, splashHandler]) e.kill();
    
    //downscroll = false;

    healthBar.screenCenter(FlxAxes.Y);
    healthBar.y += (downscroll) ? 11 : -11;
    healthBar.x = 773;
    healthBar.angle = 90;
    healthBar.scale.set(0.1725, 0.75);

    add(healTxt = new FunkinSprite().loadGraphic(Paths.image("ui/healthtxt")));
    healTxt.x = 1025;
    healTxt.screenCenter(FlxAxes.Y);
    
    add(whiteBG = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, 0x69FFFFFF));

    add(whiteTxt = new FunkinText(0, 0, FlxG.width, "rbx by dislamp", 22));
    whiteTxt.alignment = "center";
    whiteTxt.font = Paths.font("ComicNeue-Bold.ttf");
    whiteTxt.screenCenter(FlxAxes.Y);
    
    whiteBG.visible = whiteTxt.visible = false;

    add(blackBar1 = new FunkinSprite().makeSolid(160, FlxG.height, FlxColor.BLACK));

    add(blackBar2 = new FunkinSprite().makeSolid(160, FlxG.height, FlxColor.BLACK));
    blackBar2.x = FlxG.width - blackBar2.width;

    for (a in [healTxt, whiteBG, whiteTxt, blackBar1, blackBar2]) a.camera = camHUD;

    camFollow.setPosition(strumLines.members[curCameraTarget].characters[0].getCameraPosition().x, strumLines.members[curCameraTarget].characters[0].getCameraPosition().y);
    FlxG.camera.snapToTarget();
}

function onSongStart() {
    whiteBG.visible = whiteTxt.visible = true;
    new FlxTimer().start(3, ()->{
        whiteBG.visible = whiteTxt.visible = false;
    });
}