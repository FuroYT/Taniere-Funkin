import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;
import funkin.menus.StoryMenuState;
import funkin.options.OptionsMenu;
import funkin.backend.utils.CoolUtil.CoolSfx;
import funkin.backend.MusicBeatState;

var sideBar;
var menuItems = ["Story Mode", "Freeplay", "Credits", "Options"];
var posData = [];
static var TaniereMenu_curSelected = 0;
var selectedBar;
var bgFlash;

function create() {
    MusicBeatState.skipTransIn = true;
	var bg = new FlxSprite().loadGraphic(Paths.image("menus/menuEditors"));
	add(bg);
	bg.scale.set(1.3, 1.3);
	bg.updateHitbox();
	bg.screenCenter();
	bg.x += 180;
	bg.scrollFactor.set(0.3, 0.3);

	bgFlash = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFFFFFFFF);
	bgFlash.alpha = 0.001;
	add(bgFlash);
	bgFlash.scrollFactor.set();

	sideBar = new FlxSprite(-60).makeSolid(FlxG.width + 120, FlxG.height * 1.5, 0xFF000000);
	sideBar.angle = -9.3;
	sideBar.antialiasing = true;
	sideBar.screenCenter(FlxAxes.Y);
	sideBar.scrollFactor.set(0.5, 0.5);
	FlxTween.tween(sideBar, {x: -FlxG.width + 110}, 1.5, {ease: FlxEase.expoOut, startDelay: 0.1});

	var skewShader = new CustomShader("skew");
	skewShader.data.vertexXOffset.value = [0, 0, 20, 20];
	skewShader.data.vertexYOffset.value = [0, -20, 0, -20];

	selectedBar = new FlxSprite().makeGraphic(FlxG.width * 2, 140, 0xFF000000);
	selectedBar.shader = skewShader;
	selectedBar.x = -FlxG.width * 2;
	add(selectedBar);

	for (i => itemName in menuItems) {
		var songName = new FlxText(0, 0, FlxG.width, itemName);
		songName.setFormat(Paths.font("WonderBold.ttf"), 98, FlxColor.WHITE, "left", "outline", FlxColor.BLACK);
		songName.antialiasing = true;
		// positionSprite(songName, sideBar, 120, i, menuItems.length, 15);
		add(songName);
		songName.shader = skewShader;
		posData[i] = [songName, 15];
	}
	add(sideBar);

	updateDevOverlay();

	changeSelection(0);
}

var canSelect = true;

function update(elapsed:Float) {
	for (i => data in posData) {
		var spr = data[0];
		var curAddition = data[1];

		var wantedAddition = i == TaniereMenu_curSelected ? 15 : -30;
		var newAlpha = i == TaniereMenu_curSelected ? 1 : 0.3;

		var lerpVal = 0.2;
		var newAddition = lerp(curAddition, wantedAddition, lerpVal);
		spr.alpha = lerp(spr.alpha, newAlpha, lerpVal);

		positionSprite(spr, sideBar, 120, i, menuItems.length, newAddition);
		posData[i][1] = newAddition;
	}

	if (!canSelect)
		return;
	var upP = controls.UP_P;
	var downP = controls.DOWN_P;
	var scroll = FlxG.mouse.wheel;

	if (upP || downP || scroll != 0) // like this we wont break mods that expect a 0 change event when calling sometimes  - Nex
		changeSelection((upP ? -1 : 0) + (downP ? 1 : 0) - scroll);

	if (controls.DEV_ACCESS) {
		persistentUpdate = false;
		persistentDraw = true;
		openSubState(new EditorPicker());
	}

	if (controls.BACK) {
		FlxG.switchState(new TitleState());
		CoolUtil.playMenuSFX(CoolSfx.CANCEL);
	}

	if (controls.ACCEPT) {
		canSelect = false;
		posData[TaniereMenu_curSelected][1] = 125;
		CoolUtil.playMenuSFX(CoolSfx.CONFIRM);
		var spr = posData[TaniereMenu_curSelected][0];
		selectedBar.y = spr.y + ((selectedBar.height - spr.height) / 2) - 5;
		FlxTween.tween(selectedBar, {x: 0, y: selectedBar.y - 10}, 1, {ease: FlxEase.expoOut, startDelay: 0.3});
		FlxTween.tween(FlxG.camera, {"scroll.x": FlxG.width}, 2, {ease: FlxEase.expoInOut});
		FlxTween.tween(selectedBar, {"scale.y": 15}, 2, {ease: FlxEase.expoInOut, startDelay: 0.3});

		bgFlash.alpha = 0.3;
		FlxG.camera.zoom = 1.1;
		FlxTween.tween(bgFlash, {alpha: 0}, 2, {ease: FlxEase.expoOut});
		FlxTween.tween(FlxG.camera, {zoom: 1}, 2, {ease: FlxEase.expoOut});
		// FlxTween.tween(bgFlash, {alpha: 0.01}, 2, {ease: FlxEase.expoInOut});

		var targetState = switch (menuItems[TaniereMenu_curSelected]) {
			case "Story Mode":
				new StoryMenuState();
			case "Freeplay":
				new FreeplayState();
			case "Credits":
				new CreditsMain();
			case "Options":
				new OptionsMenu();
			default:
				new MainMenuState();
		};

		new FlxTimer().start(2.5, () -> {
    		MusicBeatState.skipTransOut = true;
			FlxG.switchState(targetState);
		});
	}

	#if MOD_SUPPORT
	if (controls.SWITCHMOD) {
		openSubState(new ModSwitchMenu());
		persistentUpdate = false;
		persistentDraw = true;
	}
	#end
}

function changeSelection(change) {
	change = change ?? 0;
	TaniereMenu_curSelected = FlxMath.wrap(TaniereMenu_curSelected + change, 0, menuItems.length - 1);
	if (change != 0)
		CoolUtil.playMenuSFX(CoolSfx.SCROLL);
}

function positionSprite(spr:FlxSprite, anchor:FlxSprite, spacing:Float, index:Int, length:Int, spaceX:Int) {
	var rad = anchor.angle * Math.PI / 180;

	var xStep = Math.tan(-rad) * spacing;

	var rightEdgeX = -60 + Math.cos(rad) * 300;

	var totalHeight = length * spacing;
	var baseY = (FlxG.height / 2) - (totalHeight / 2);
	spr.y = baseY + (index * spacing);
	spr.x = rightEdgeX + index * xStep + spaceX;
}
