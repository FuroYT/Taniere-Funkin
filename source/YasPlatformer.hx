import flixel.FlxObject;
import flixel.util.FlxDirectionFlags;

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

        playAnim("idle");

        hitbox = new FlxSprite().makeSolid(1, 1, 0xFFFF0000);
        debugText = new FunkinText(0, 0, 0, "", 18);

        velocity.y = 1;
    }

    public var onGround:Bool = false;
    public var lastVelocity:FlxPoint = FlxPoint.get();
    var sliding:Bool = false;
    var maxSpeed:Float = 500; // pixels per second
    var minSlideSpeed = maxSpeed * 0.8; // pixels/sec, adjust to taste
    var accel:Float = 600;    // how fast it accelerates
    var friction:Float = 1500; // slows down when no input
    override public function update(elapsed:Float) {
        super.update(elapsed);
        hitbox.x = x;
        hitbox.y = y;
        hitbox.scale.set(frameWidth * scale.x, frameHeight * scale.y);
        hitbox.updateHitbox();

        for (obj in collideWith)
        {
            obj.immovable = true;
            FlxG.collide(this, obj);
        }

        onGround = (touching & FlxDirectionFlags.FLOOR) != 0;
        if (onGround)
            velocity.y = 0.001;
        else
            velocity.y += 5 * Math.exp(elapsed * 3);

        //if (FlxG.keys)

        if (FlxG.keys.pressed.SPACE && onGround)
            velocity.y = -600;

        var left = FlxG.keys.pressed.LEFT;
        var right = FlxG.keys.pressed.RIGHT;

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
            ].join("\n");
            debugText.x = x;
            debugText.y = y- debugText.height;
        }
    }

    public function updateAnim()
    {
        var animName = "idle";
        if (!onGround || velocity.y < 0)
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