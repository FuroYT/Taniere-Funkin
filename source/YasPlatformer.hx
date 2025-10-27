import flixel.FlxObject;
import flixel.util.FlxDirectionFlags;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxCollision;

class YasPlatformer extends FunkinSprite
{
    private var hitbox:FlxSprite;
    private var debugText:FlxText;

    public var collideWith:Array<FlxBasic> = [];
    public var debugMode:Bool = false;
    override public function new() {
        super(0, 0, Paths.image("yasMode/Retro_Yas"));
        immovable = false;
        moves = true;

        scale.set(0.5, 0.5);
        updateHitbox();

        addAnim("idle", "idle", 24, true);
        addAnim("walk", "walk", 24, true);
        addAnim("jump", "jump", 24, false);
        addAnim("crouch", "crouch", 24, false);
        addAnim("slide", "slide", 24, false);
        addAnim("god", "GOD", 0, false);

        playAnim("idle");

        hitbox = new FlxSprite().makeSolid(1, 1, 0xFFFF0000);
        debugText = new FunkinText(0, 0, 0, "", 18);

        velocity.y = 1;
    }

    public var konamiCode:Array<FlxKey> = [FlxKey.UP, FlxKey.UP, FlxKey.DOWN, FlxKey.DOWN, FlxKey.LEFT, FlxKey.RIGHT, FlxKey.LEFT, FlxKey.RIGHT, FlxKey.ESCAPE, FlxKey.SPACE];
    public var konamiCodeIndex:Int = -1;
    public var konamiTimeLeft:Float = 0;

    public var isGod:Bool = false;
    public var onGround:Bool = false;
    public var lastVelocity:FlxPoint = FlxPoint.get();
    var sliding:Bool = false;
    var maxSpeed:Float = 500; // pixels per second
    var minSlideSpeed = maxSpeed * 0.8; // pixels/sec, adjust to taste
    var accel:Float = 600;    // how fast it accelerates
    var friction:Float = 1500; // slows down when no input
    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (konamiCodeIndex != -1) {
            konamiTimeLeft -= elapsed;
            if (konamiTimeLeft <= 0) {
                konamiTimeLeft = 0;
                konamiCodeIndex = -1;
            }
        }

        if (isGod)
        {
            updateAnim();
            return;
        }

        hitbox.x = x - frameOffset.x / 2;
        hitbox.y = y - frameOffset.y / 2;
        hitbox.scale.set(frameWidth * scale.x, frameHeight * scale.y);
        hitbox.updateHitbox();

        for (obj in collideWith)
        {
            obj.immovable = true;
            obj.updateHitbox();
            if (obj.angle != 0)
                collideWithSlope(this, obj);
            else
                FlxG.collide(this, obj);
        }

        onGround = (touching & FlxDirectionFlags.FLOOR) != 0;
        if (onGround)
            velocity.y = 0.001;
        else
            velocity.y += 5 * Math.exp(elapsed * 3);
        
        var nextKonamiKey = konamiCode[konamiCodeIndex + 1];
        if (FlxG.keys.anyJustPressed([nextKonamiKey]))
        {
            konamiCodeIndex ++;
            konamiTimeLeft = 2;
            if (konamiCodeIndex == konamiCode.length - 1)
            {
                isGod = true;
                return;
            }
        }

        var left = FlxG.keys.pressed.LEFT;
        var right = FlxG.keys.pressed.RIGHT;
        var up = FlxG.keys.pressed.UP;
        var down = FlxG.keys.pressed.DOWN;
        var jump = FlxG.keys.pressed.SPACE;

        if (jump && onGround)
            velocity.y = -600;

        // If both are pressed, don’t accelerate
        if ((left && right) || (!left && !right) || sliding) {
            // Apply friction proportional to current speed
            var frictionFactor = Math.abs(velocity.x) / maxSpeed; // 0 → 1
            var dynamicFriction = friction * elapsed * (0.5 + frictionFactor); 
            // 0.5 ensures even slow speeds still get some friction

            if (velocity.x > 0) {
                velocity.x -= dynamicFriction;
                if (velocity.x < 0) velocity.x = 0;
            } else if (velocity.x < 0) {
                velocity.x += dynamicFriction;
                if (velocity.x > 0) velocity.x = 0;
            }
        }
        else if (right)
            velocity.x += accel * elapsed;
        else if (left)
            velocity.x -= accel * elapsed;
        
        if (onGround) {
            // start sliding if moving fast enough and either no input or switching directions
            if (!sliding) {
                if ((!left && !right && Math.abs(velocity.x) >= minSlideSpeed) ||
                    (right && velocity.x < -minSlideSpeed) ||
                    (left && velocity.x > minSlideSpeed)) {
                    sliding = true;
                }
            }

            // stop sliding when speed is too low
            if (sliding && Math.abs(velocity.x) < 50) // adjust stop threshold
                sliding = false;
        }


        // Clamp velocity
        if (velocity.x > maxSpeed) velocity.x = maxSpeed;
        if (velocity.x < -maxSpeed) velocity.x = -maxSpeed;

        updateAnim();
        lastVelocity.set(velocity.x, lastVelocity.y);

        if (debugMode) {
           debugText.text = [
                "x: " + debugRound(x),
                "y: " + debugRound(y),
                "Vel: (" + debugRound(velocity.x) + ";" + debugRound(velocity.y) + ")",
                "OnGround? / CanJump?: " + onGround,
                "Sliding?: " + sliding,
                "Touching: " + touching,
                "Konami: " + konamiCodeIndex + " (" + debugRound(konamiTimeLeft) + ")",
            ].join("\n");
            debugText.x = x;
            debugText.y = y- debugText.height;
        }
    }

    public function updateAnim()
    {
        var animName = "idle";
        if (isGod)
            animName = "god";
        else if (!onGround || velocity.y < 0)
            animName = "jump";
        else if (sliding)
            animName = "slide";
        else if (Math.abs(velocity.x) > 0)
        {
            animName = "walk";
            flipX = velocity.x < 0;
        }
        else
            animName = "idle";

        if (getAnimName() != animName)
            playAnim(animName);
    }

    /**
     * Universal slope collision that supports all angles and origins.
     * Works with any rotation — no need to hardcode left/right slopes.
     */
    function collideWithSlope(player:FlxSprite, slope:FlxSprite)
    {
        // Bottom-center of player
        var px = player.x + player.width / 2;
        var py = player.y + player.height;

        // Convert player to slope-local coordinates
        var radians = slope.angle * Math.PI / 180;
        var sin = Math.sin(radians);
        var cos = Math.cos(radians);

        // Transform to local space relative to slope.origin
        var localX = (px - (slope.x + slope.origin.x)) * cos + (py - (slope.y + slope.origin.y)) * sin + slope.origin.x;
        var localY = -(px - (slope.x + slope.origin.x)) * sin + (py - (slope.y + slope.origin.y)) * cos + slope.origin.y;

        // --- HARD LIMIT: if outside slope’s horizontal bounds, ignore completely ---
        // Add ±1px tolerance so floating-point rounding doesn’t kill edge cases
        if (localX < -1 || localX > slope.width + 1)
            return;

        // Compute local surface height
        var slopeRatio = slope.height / slope.width;
        var surfaceLocalY = slope.height - (localX * slopeRatio);

        // Back to world space
        var surfaceWorldY = slope.y + slope.origin.y
            + (localX - slope.origin.x) * sin
            + (surfaceLocalY - slope.origin.y) * cos;

        var dy = py - surfaceWorldY;
        var falling = player.velocity.y >= 0;
        var tolerance = 0;

        // --- Collision condition ---
        if (falling && dy > 0 && dy < slope.height && localY <= slope.height + tolerance)
        {
            player.y -= dy;
            player.touching = FlxDirectionFlags.FLOOR;
            player.velocity.y = 0;
            onGround = true;
        }
    }

    override public function playAnim(AnimName:String, ?Force:Null<Bool>, Context:PlayAnimContext = NONE, Reversed:Bool = false, Frame:Int = 0):Void
    {
        super.playAnim(AnimName, Force, Context, Reversed, Frame);
        frameOffset.set(0, -20);
        switch (AnimName)
        {
            case "god":
                frameOffset.set();
            case "walk":
                frameOffset.y -= 10;
            case "slide":
                frameOffset.x = 20 * (flipX ? -1 : 1);
        }
    }

    private function debugRound(n)
        return Math.floor(n * 10) / 10;

    override public function draw()
    {
        if (debugMode)
            hitbox.draw();
        super.draw();
        if (debugMode)
            debugText.draw();
    }
}