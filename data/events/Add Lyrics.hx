import flixel.text.FlxTextBorderStyle;

public var curLyricsTweaks;

public var lyrics:Array<FunkinText> = [];

function create() {
    var defaultTweaks = {
        size: 24,
        font: Paths.font("vcr.ttf"),
        color: 0xFFFFFFFF,
        borderSize: 2,
        borderColor: 0xFF000000,
        showPrevious: true
    }

    curLyricsTweaks = defaultTweaks;
}

function onEvent(event) {
    if(event.event.name != "Add Lyrics")
        return;

    addText(event.event.params[0]);
}

function addText(lyricText:String) {
    for (lyric in lyrics) {
        if (!curLyricsTweaks.showPrevious) {
            destroyText(lyric);
            continue;
        }

        var spaceToMove = (!downscroll ? 1 : -1) * curLyricsTweaks.size;
        
        FlxTween.tween(lyric, {alpha: lyric.alpha - 0.5, y: lyric.y - spaceToMove}, 0.25, {ease: FlxEase.cubeOut, onComplete: () -> {
            if(lyric.alpha <= 0.001)
                destroyText(lyric);
        }});
    }

    var text:FunkinText = new FunkinText();
    text.setFormat(curLyricsTweaks.font, curLyricsTweaks.size, curLyricsTweaks.color);
    text.setBorderStyle(FlxTextBorderStyle.OUTLINE, curLyricsTweaks.borderColor, curLyricsTweaks.borderSize);
    text.text = lyricText;
    text.screenCenter();
    text.scrollFactor.set();
    text.camera = camHUD;
    add(text);

    lyrics.push(text);
}

function destroyText(text:FunkinText) {
    remove(text);
    lyrics.remove(text);
    text.destroy();
}

