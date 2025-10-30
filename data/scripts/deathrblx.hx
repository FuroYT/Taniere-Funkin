var oof = FlxG.sound.load(Paths.sound("rblx_dead"));

function create(e) {
    e.cancel();
    FlxG.cameras.add(camera = gameoverCam = new FlxCamera(), false);
    
    add(ohno = new FlxSprite().loadGraphic(Paths.image("robloxui/ohnoes")));
    ohno.screenCenter();

    oof.play();
}

function update() {
    if (controls.BACK) FlxG.switchState(new MainMenuState());
    if (controls.ACCEPT) FlxG.switchState(new PlayState());
}