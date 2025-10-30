import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.options.TreeMenu;
import funkin.options.OptionsMenu;
import funkin.backend.MusicBeatState;

var btnGrp:FlxTypedSpriteGroup;

function create(e) {
    e.cancel();

    FlxG.cameras.add(camera = pauseCam = new FlxCamera(), false).bgColor = FlxColor.TRANSPARENT;

    add(whiteBG = new FunkinSprite().makeSolid(960, FlxG.height, 0x69FFFFFF));
    whiteBG.screenCenter();

    add(btnGrp = new FlxTypedGroup());

    var spacing = 25;
    var itemHeight = 22;
    var totalHeight = (menuItems.length - 1) * spacing + itemHeight;
    var startY = (FlxG.height / 2) - (totalHeight / 2);

    for (i in 0...menuItems.length) {
        var txt = new FunkinText(0, startY + (i * spacing), FlxG.width, menuItems[i], 22);
        txt.alignment = "center";
        txt.font = Paths.font("ComicNeue-Bold.ttf");
        txt.updateHitbox();
        btnGrp.add(txt);
    }

    changeSelection();
}


function update(e) {
    if (pauseMusic.playing) pauseMusic.destroy();
    if (controls.UP_P || controls.DOWN_P) changeSelection(controls.UP_P ? -1 : 1);
    if (controls.ACCEPT) selectOption();
    if (controls.BACK) close();
}

function changeSelection(change:Int = 0) {
    curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length-1);
    for (i in 0...btnGrp.members.length) btnGrp.members[i].text = (i == curSelected) ? "> " + menuItems[i] + " <" : menuItems[i];
}