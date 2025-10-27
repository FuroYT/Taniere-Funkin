function onEvent(event) {
    if(event.event.name != "Remove Lyrics")
        return;

    if (lyrics == null)
        return;

    if (lyrics.length <= 0)
        return;

    for (lyric in lyrics) {        
        FlxTween.cancelTweensOf(lyric);

        if (event.event.params[0])
            destroyText(lyric);
        else
            FlxTween.tween(lyric, {alpha: 0}, 1.0, {ease: FlxEase.cubeOut, onComplete: () -> {
                destroyText(lyric);
            }});
    }

    lyrics = [];
}

function destroyText(text:FunkinText) {
    remove(text);
    text.destroy();
}