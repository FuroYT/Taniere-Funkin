import funkin.game.Character;

var charactersCache:Map<String, Character> = [];

function create() {
    for (event in PlayState.SONG.events) {
        if (event.name != "Change Character" || charactersCache.exists(event.params[2]))
            continue;

        var strumLine:StrumLine     = strumLines.members[event.params[0]];
        var prvCharacter:Character  = strumLine.characters[event.params[1]];
        var newCharacter:Character  = new Character(prvCharacter.x, prvCharacter.y, event.params[2], stage.isCharFlipped(event.params[2], prvCharacter.isPlayer));
        
        stage.applyCharStuff(newCharacter, strumLine.data.position == null ? (switch(strumLine.data.type) {
		    case 0: "dad";
			case 1: "boyfriend";
			case 2: "girlfriend";
		}) : strumLine.data.position, 0);

        newCharacter.active = newCharacter.visible = false;

        if (newCharacter.animateAtlas == null && newCharacter.atlasPath == null)
            newCharacter.drawComplex(FlxG.camera);

        var newIconPath:String = "icons/" + newCharacter.getIcon() + "/icon";
        var oldIconPath:String = "icons/" + newCharacter.getIcon();

        var iconPath:String = Assets.exists(Paths.image(oldIconPath)) ? oldIconPath : newIconPath;
        
        graphicCache.cache(Paths.image(iconPath));

        charactersCache.set(event.params[2], newCharacter);
    }
}

function onEvent(event) {
    if (event.event.name != "Change Character")
        return;

    var strumlineIndex:Int      = event.event.params[0];
    var characterIndex:Int      = event.event.params[1];
    var characterName:String    = event.event.params[2];

    var prvCharacter:Character   = strumLines.members[strumlineIndex].characters[characterIndex];
    var newCharacter:Character   = charactersCache.get(characterName);

    if (prvCharacter.curCharacter == newCharacter.curCharacter)
        return;

    insert(members.indexOf(prvCharacter), newCharacter);
    newCharacter.active = newCharacter.visible = true;
    remove(prvCharacter);

    newCharacter.setPosition(prvCharacter.x, prvCharacter.y);

    strumLines.members[strumlineIndex].characters[characterIndex] = newCharacter;
    
    updateHealthBarColors();
}

function updateHealthBarColors() {
    iconP1.setIcon(boyfriend != null ? boyfriend.getIcon() : "face");
    iconP2.setIcon(dad != null ? dad.getIcon() : "face");

    var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
    var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors

    healthBar.createFilledBar(leftColor, rightColor);

    set_maxHealth(maxHealth);
}