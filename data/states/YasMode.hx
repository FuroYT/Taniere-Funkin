import YasPlatformer;

var yas:YasPlatformer;
function create() {
    var bg = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF8B4444);
    add(bg);

    var floor = new FlxSprite(0, 600).makeGraphic(FlxG.width, 50, 0xFFFFFFFF);
    add(floor);

    yas = new YasPlatformer();
    add(yas);
    yas.debugMode = true;

    yas.collideWith.push(floor);
}