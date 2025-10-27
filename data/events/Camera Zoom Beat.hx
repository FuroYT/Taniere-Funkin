var enabled:Bool;
var beatsNumer:Int;
var zoomG:Float;
var zoomH:Float;
function onEvent(event)
{
    if (event.event.name == "Camera Zoom Beat")
    {
        enabled = event.event.params[0];
        beatsNumer = event.event.params[1];
        zoomG = event.event.params[2];
        zoomH = event.event.params[3];
    }
}
function beatHit(curBeat)
{
    if (enabled)
    {
        if (curBeat % beatsNumer == 0)
	{
            executeEvent({name: "Add Camera Zoom", time: 0, params: [zoomG, "camGame"]});
            executeEvent({name: "Add Camera Zoom", time: 0, params: [zoomH, "camHUD"]});
        }
       
    }
}