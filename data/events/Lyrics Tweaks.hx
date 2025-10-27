import haxe.io.Path;

function onEvent(event) {
    if(event.event.name != "Lyrics Tweaks")
        return;

    curLyricsTweaks = {
        size:           event.event.params[0],
        font:           getFont(event.event.params[1]),
        color:          event.event.params[2],
        borderSize:     event.event.params[3],
        borderColor:    event.event.params[4],
        showPrevious:   event.event.params[5]
    };
}

function getFont(font:String) {
    var exts:Array<String> = [".ttf", ".otf"];

    if (Path.extension(font) == "otf")
        exts = [".otf", ".ttf"];

    for (ext in exts) {
        var noExt:String = Path.withoutExtension(font);
        var intendedPath:String = Paths.font(noExt + ext);

        if (Assets.exists(intendedPath))
            return intendedPath;
    }
    
    return Paths.font("vcr.ttf");
}