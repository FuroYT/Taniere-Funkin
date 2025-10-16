import sys.io.Process;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.assets.ModsFolder;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
using StringTools;

var devOverlay;
function initDevOverlay()
{
    if (devOverlay != null) return;
    devOverlay = new TextField();
    devOverlay.x = 10;

    devOverlay.selectable = false;
    devOverlay.mouseEnabled = false;
    devOverlay.defaultTextFormat = new TextFormat("_sans", 24, 0x9E9191);
    devOverlay.autoSize = TextFieldAutoSize.LEFT;
    devOverlay.multiline = false;
    devOverlay.text = "";
    window.stage.addChild(devOverlay);
}

function update(elapsed:Float) {
    if (devOverlay != null) devOverlay.y = window.height - 100;
}

static function updateDevOverlay() {
    if (devOverlay == null) return;
    var debugText = [
        "Tanière Funkin' Dev Build",
        "Git: " + gitCommitHash + " / " + gitCommitAuthor + ": " + gitCommitMessage,
        DiscordUtil.user == null ? null : "Discord: " + DiscordUtil.user.username + " (" + DiscordUtil.user.userId + ")",
    ];
    devOverlay.text = debugText.filter((v) -> v != null).join("\n");
}

function destroy()
{
    if (devOverlay != null) {
        window.stage.removeChild(devOverlay);
    }
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

function postStateSwitch() {
	updateDevOverlay();
}