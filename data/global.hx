import sys.io.Process;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.assets.ModsFolder;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
using StringTools;

var devOverlay;
var devOverlayBg;
function initDevOverlay()
{
    if (devOverlayBg == null)
    {
        devOverlayBg = new Bitmap(new BitmapData(1, 1, true, 0xFF000000));
		devOverlayBg.alpha = 0.7;
        devOverlayBg.x = 10;
        window.stage.addChild(devOverlayBg);
    }
    if (devOverlay == null) {
        devOverlay = new TextField();
        devOverlay.x = 18;

        devOverlay.selectable = false;
        devOverlay.mouseEnabled = false;
        devOverlay.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font("vcr.ttf")), 24, 0xFFFFFF);
        devOverlay.autoSize = TextFieldAutoSize.LEFT;
        devOverlay.multiline = false;
        devOverlay.text = "";
        window.stage.addChild(devOverlay);
    }
}

function update(elapsed:Float) {
    if (devOverlay != null) devOverlay.y = window.height - (devOverlay.height + 14);
    if (devOverlayBg != null) devOverlayBg.y = window.height - (devOverlayBg.height + 10);

    if (FlxG.keys.justPressed.F7) {
		FlxG.bitmap.clearCache();
		FlxG.bitmap._cache.clear();
		Paths.tempFramesCache.clear();
		FlxG.resetState();
	}
}

static function updateDevOverlay() {
    var debugText = [
        "Tanière Funkin' Dev Build",
        gitCommitHash + " (" + gitBranch + ")",
        gitCommitAuthor + ": " + gitCommitMessage,
    ];
    if (devOverlay != null)
        devOverlay.text = debugText.join("\n");

    devOverlayBg.scaleX = devOverlay.width + devOverlay.x;
    devOverlayBg.scaleY = devOverlay.height + 8;
}

function destroy()
{
    for (stageObj in [devOverlayBg, devOverlay])
        if (stageObj != null)
            window.stage.removeChild(stageObj);
}
function new()
{
    initDevOverlay();
    updateDevOverlay();
}

function doGitCommand(args)
{
    var lesVraiArgs = ['-C', ModsFolder.modsPath + ModsFolder.currentModFolder];
    for (i in args)
        lesVraiArgs.push(i);

    var process = new Process('git', lesVraiArgs);
    if (process.exitCode() != 0)
    {
      var message = process.stderr.readAll().toString();
      trace('[WARN] Could not determine current git commit; is this a proper Git repository?');
      trace(message);
      return null;
    }

    var stdout = process.stdout.readLine();

    process.close();

    return stdout;
}

static var gitCommitHash(get, default):String;
function get_gitCommitHash():String {
    var commitHash:String = doGitCommand(['rev-parse', '--short', 'HEAD']);
    return commitHash;
}
static var gitCommitMessage(get, default):String;
function get_gitCommitMessage():String {
    var all:String = doGitCommand(['log', '-1', '--pretty=%B']) ?? "";
    if (all != "") {
        while(StringTools.endsWith(all, "\r\n")) all = all.substr(0, all.length - 2);
        while(StringTools.endsWith(all, "\n")) all = all.substr(0, all.length - 1);
        while(StringTools.endsWith(all, "\r")) all = all.substr(0, all.length - 1);
    }
    return all;
}
static var gitCommitAuthor(get, default):String;
function get_gitCommitAuthor():String {
    var author:String = doGitCommand(['log', '-1', '--pretty=%an']);
    return author;
}
static var gitCommitModified(get, default):Bool;
function get_gitCommitModified():String {
    var exit:String = doGitCommand(['status', '--porcelain']) ?? "";
    return exit != "";
}
static var gitBranch(get, default):String;
function get_gitBranch():String {
    var curBranch:String = doGitCommand(["rev-parse", "--abbrev-ref", "HEAD"]) ?? "";
    return curBranch;
}

function postStateSwitch() {
	updateDevOverlay();
}