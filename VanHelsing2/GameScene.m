//
//  HelloWorldLayer.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 10/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "GameScene.h"
#import "CDAudioManager.h"
#import "MenuLevelSelectionNotSlide.h"


// HelloWorldLayer implementation
@implementation GameScene
@synthesize weaponManager, character, JSMovement , JSAiming, screenSize, enemyManager, enemiesSpritesArray, powerUpManager, bloodSpritesNode;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id) init1
{
    if (self = [super init])
    {
        yPos = 100;
        xPos = 100;
        aAngle = 45;
    }
    return self;
}
-(void) draw1
{
    
    [super draw];
    //the color of the line
//    glColor4f(1.0, 0.0, 0.0, 1.0);
    ccDrawColor4F(1.0, 0.0, 0.0, 1.0);
    
    //the width of the line
    glLineWidth(1.0f);
    CGPoint point[1024*768];
    point[0] = ccp(100.0 , 100.0);
    point[1] = ccp(400.0 , 400.0);
    ccDrawPoints(point, 2);
//    ccDraw
    ccDrawCircle(ccp(512,384), 50.0, CC_DEGREES_TO_RADIANS(aAngle) , 20, NO);
    ccDrawCircle(ccp(xPos,yPos), 10, -aAngle, 500, NO);
//    ccDrawCircle(ccp(xPos,yPos), 50.0, aAngle, 500, NO);
    xPos -=4;
    yPos +=4;
    aAngle += 2;
//    ccDrawCircle(ccp(512,384), 50.0, 47.0, 100, YES);
//    ccDrawCircle(ccp(512,384), 50.0, 48.0, 100, YES);
//    ccDrawCircle(ccp(512,384), 50.0, 49.0, 100, YES);
//    ccDrawCircle(ccp(512,384), 50.0, 50.0, 100, YES);
//    ccDrawCircle(ccp(512,384), 50.0, 51.0, 100, YES);
//    ccDrawCircle(ccp(512,384), 50.0, 52.0, 100, YES);
   
    //draw point at 100, 100
//    ccDrawPoint(CGPointMake(512, 384));
    
    //draw line from the first point to the second one
    ccDrawLine(ccp(300.0, 300.0), ccp(xPos,yPos));
    
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        //DEVELPEMENT do the sprite sheet load. This should be improved .
        [self doSpritesCache];
        [self loadSound];
        [self setIsTouchEnabled:YES];
        
        bloodSpritesNode = [CCNode node];       
        [self addChild:bloodSpritesNode z:200];
        
        //Save the screen size.
        screenSize = [[CCDirector sharedDirector]winSize];
        
        NSString * bgName = [NSString stringWithFormat:@"background%d.png",
                             [[NSUserDefaults standardUserDefaults] integerForKey:@"level"]];
        
        CCSprite *bg = [CCSprite spriteWithFile:bgName];
        [bg setPosition:ccp(screenSize.width /2 , screenSize.height / 2)];
        [self addChild:bg];
        
        //Alloc the enemy manager. It spawn the enemies.
        enemyManager = [[EnemyManager alloc]initWithTheGame:self];
        //Alloc the weapon manager. It shoots, changes the weapon and save the weapon and bullets bonuses.
        weaponManager = [[WeaponBulletManager alloc]initWithTheGame:self andWeapon:[[NSUserDefaults standardUserDefaults] integerForKey:@"NSCurrentWeapon" ]];
        //Alloc the power up manager. It create, activate, deactivate, and trigger the power ups.
        powerUpManager = [[PowerUpManager alloc]initWithTheGame:self];

        
        //Alloc the character.
        character = [[CharacterClass alloc]initWithGame:self 
                                            andPosition:ccp (screenSize.width/2 , screenSize.height/2 )];
        //Add the move stick and aim stick.
        [self addJoystick];
	}
	return self;
}
-(void)loadSound
{
    //load requests array for main sounds.
    NSMutableArray *loadRequests = [NSMutableArray arrayWithCapacity:6];
    
    //Add buffer load request to sounds array.
    //Reload sound.
    NSString * soundName1 = [NSString stringWithFormat:@"1.wav"];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:1001 filePath:soundName1] autorelease]];
    //Shoot sound.    
    NSString * soundName2 = [NSString stringWithFormat:@"2.wav"];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:1002 filePath:soundName2] autorelease]];
    //Load sounds in the background.
    [[CDAudioManager sharedManager].soundEngine loadBuffersAsynchronously:loadRequests];
}
-(void)doSpritesCache
{
    cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [cache addSpriteFramesWithFile:@"spriteSheet.plist"];
}

-(void)addJoystick
{
    js = [[[SneakyJoystickSkinnedBase alloc]init]autorelease];
    [js setBackgroundSprite:[CCSprite spriteWithFile:@"pad1.png"]];
    [js setThumbSprite:[CCSprite spriteWithFile:@"pad2.png"]];
    [js setJoystick:[[SneakyJoystick alloc]initWithRect:CGRectMake(0, 0, 100, 100)]];
    [js setPosition:ccp(-150,-150)];
    [self addChild:js];
    JSMovement = [js.joystick retain];

    js2 = [[[SneakyJoystickSkinnedBase alloc]init]autorelease];
    [js2 setBackgroundSprite:[CCSprite spriteWithFile:@"pad1.png"]];
    [js2 setThumbSprite:[CCSprite spriteWithFile:@"pad2.png"]];
    [js2 setJoystick:[[SneakyJoystick alloc]initWithRect:CGRectMake(0, 0, 100, 100)]];
    [js2 setPosition:ccp(screenSize.width + 150,-150)];

    [self addChild:js2];
    JSAiming = [js2.joystick retain];
    
}
//SET TOUCHES ENABLES ON ENTER
-(void)onEnter
{
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:NO];
//	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
	[super onEnter];
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Character is already dead.
    if (character.isDead)
        return NO;
    //If user is using two touches, can't touch anymore.
    if (leftTouch && rightTouch)
        return NO;
    
    //Save touch location
    CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];

    //If location is in midleft of screen, and there isn't a left touch.
    if (location.x < screenSize.width/2 && !leftTouch)
    {
        //Move the move stick to the touch position. That makes it appear in screen.
        [js setPosition:location];
        //Save the touch.
        leftTouch = touch;   
    //If location is in midright of screen, and there isn't a right touch.        
    }else if (location.x >= screenSize.width/2 && !rightTouch) 
    {
        //Move the aim stick to the touch position. That makes it appear in screen.
        [js2 setPosition:location];
        //Save the touch.        
        rightTouch = touch;        
    }
    
    return YES;
}
//CHECK THE TOUCH, set the positión of the stick, and then apply the touch to the stick.
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    
}
//Make the sticks dissapear.
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{

    //If the touch ended is the left touch.
    if (touch == leftTouch)
    {
        //Hide the move stick.
        [js setPosition:ccp(-150,-150)];   
        //Erase the left touch.
        leftTouch = nil;
    //If the touch ended is the right touch.
    }else
    {
        //Hide the aim stick.
        [js2 setPosition:ccp(-150,-150)];       
        //Erase the right touch.
        rightTouch = nil;        
    }
}
//Restart level
-(void)restartLevel
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLevelSelectionNotSlide scene] withColor:ccBLACK]];
//    [[CCDirector sharedDirector]replaceScene:[GameScene scene]];
}
//End game.
-(void)gameOver
{
    [self runAction:[CCSequence  actions:
                     [CCDelayTime actionWithDuration:2],
                     [CCCallFunc actionWithTarget:self selector:@selector(restartLevel)],
                     nil]];
    
        [[AppController get] saveFile];    
}
-(void)update:(ccTime)dt
{   
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
