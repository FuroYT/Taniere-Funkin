var enabled:Bool = false;
var stepsNumer:Float = 0;
var zoomG:Float = 0;
var zoomH:Float = 0;

function onEvent(event)
{
    if (event.event.name == "Camera Zoom Step")
    {
        enabled = event.event.params[0];
        stepsNumer = event.event.params[1];
        zoomG = event.event.params[2];
        zoomH = event.event.params[3];
    }
}

function stepHit()
{
    if (enabled)
    {
        if ((curStep % stepsNumer) == 0)
	{
            executeEvent({name: "Add Camera Zoom", time: 0, params: [zoomG, "camGame"]});
            executeEvent({name: "Add Camera Zoom", time: 0, params: [zoomH, "camHUD"]});
        }
       
    }
}