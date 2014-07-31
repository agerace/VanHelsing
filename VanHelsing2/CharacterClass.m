//
//  characterClass.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//        1556374301

#import "CharacterClass.h"


@implementation CharacterClass

@synthesize  theGame, characterHealthPoints, characterCurrentHealthPoints, characterSpeed, characterSpriteTorso;
@synthesize characterXp, characterMoney, characterLevel;
@synthesize bonusCharacterShield, bonusCharacterSpeed, bonusCharacterXp, isDead;

-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position
{
    if ( self = [super init])
    {
        //Assign the game.
        theGame = _theGame;
        //Add this node to the game.
        [theGame addChild:self];
        
        characterProfile = [[NSUserDefaults standardUserDefaults] integerForKey:@"NSCharacterProfile"];
        
        characterMoney = [[[[AppController get].tempArray objectAtIndex:characterProfile]objectForKey:@"characterMoney"] intValue];
        characterXp = [[[[AppController get].tempArray objectAtIndex:characterProfile]objectForKey:@"characterXp"] floatValue];
        characterLevel = [[[[AppController get].tempArray objectAtIndex:characterProfile]objectForKey:@"characterLevel"] floatValue];
        xpToNextLevel = characterLevel * (777*characterLevel);
    
        bonusCharacterXp = 1;
        
        //Set character alive.
        isDead = NO;
        
        //Setting HP and Speed.
        //DEVELOPEMENT. See if we can have more variables to make the game complex and better. And see how can we change this values (more flexibles) to modify them when user get a power up.
        characterHealthPoints = 1000;
        characterCurrentHealthPoints = characterHealthPoints;
        characterSpeed = 150;  
        bonusCharacterSpeed = 1;
        bonusCharacterShield = 1;
        
        //Create character torso sprite and add it to the game scene.
        characterSpriteTorso = [CCSprite spriteWithSpriteFrameName:@"characterTorso.png"];
        [characterSpriteTorso setPosition:_position];
        [theGame addChild:characterSpriteTorso z:301];
        
        //Create character legs sprite and add it to the game scene.
        characterSpriteLegs = [CCSprite spriteWithSpriteFrameName:@"characterLegs1.png"];
        [characterSpriteLegs setPosition:_position];
        [theGame addChild:characterSpriteLegs z:300];
        
        [self legsAnimation];
        
        //Create aim point sprite and add it to the game scene.
        aimPointSprite = [CCSprite spriteWithSpriteFrameName:@"aimPoint.png"];
        [aimPointSprite setPosition:characterSpriteLegs.position];
        [theGame addChild:aimPointSprite z:302];
        
        //Start update.
        [self scheduleUpdate];
        
        
        //HP BAR        [hpBackBar setPosition:ccp(theGame.character.characterSpriteTorso.position.x , theGame.character.characterSpriteTorso.position.y - 50)];        hpBackBar = [CCSprite spriteWithSpriteFrameName:@"barHpBack.png"];
        hpBackBar = [CCSprite spriteWithSpriteFrameName:@"barHpBack.png"];
        [hpBackBar setAnchorPoint:ccp(0,0.5)];
        [hpBackBar setPosition:ccp(theGame.screenSize.width - 70 , theGame.screenSize.height - 30)];
//         (theGame.screenSize.width - 200 , theGame.screenSize.height - 100)];
        [theGame addChild:hpBackBar z:310];

        hpFrontBar = [CCSprite spriteWithSpriteFrameName:@"barHpFront.png"];
        [hpFrontBar setAnchorPoint:ccp(0,0.5)];
        [hpFrontBar setPosition:hpBackBar.position];
        [theGame addChild:hpFrontBar z:311];
        
//        //DEV HP LABEL
//        hpLabel = [CCLabelTTF labelWithString:@"" fontName:@"arial" fontSize:20];
//        [hpLabel setPosition:ccp(100,100)];
//        [hpLabel setColor:ccYELLOW];
//        [theGame addChild:hpLabel];
        
        //DEV HP LABEL
        xpLabel = [CCLabelTTF labelWithString:@"" fontName:@"arial" fontSize:20];
        [xpLabel setPosition:ccp(100,150)];
        [xpLabel setColor:ccORANGE];
        [theGame addChild:xpLabel];

        //DEV MONEY LABEL
        moneyLabel = [CCLabelTTF labelWithString:@"" fontName:@"arial" fontSize:20];
        [moneyLabel setPosition:ccp(100,50)];
        [moneyLabel setColor:ccBLUE];
        [theGame addChild:moneyLabel];
        
    }
    return self;
}

-(void)legsAnimation
{
      
}
-(void)shootMovement:(int)_angle
{
    return;
    [characterSpriteTorso runAction:[CCSequence actions:
                                     [CCMoveBy actionWithDuration:0.1 position:ccp(5,5)],
                                     [CCMoveBy actionWithDuration:0.1 position:ccp(-5,-5)],
                                     nil]];
}
-(void)update:(ccTime)dt
{
    //Call the move character method.
    [self moveCharacter:dt];
    
    [self moveAimPoint];
    
    //TEST DEV HP LABEL UPDATE
    [self setHpBarScale];
//    [hpLabel setString:[NSString stringWithFormat:@"%.2f / %.2f",characterCurrentHealthPoints,characterHealthPoints]];
    //TEST DEV XP LABEL UPDATE
    [xpLabel setString:[NSString stringWithFormat:@"XP : %.2f  -- LVL : %d",characterXp,characterLevel]];
    //TEST DEV MONEY LABEL UPDATE
    [moneyLabel setString:[NSString stringWithFormat:@"MONEY : %d",characterMoney]];
}
-(void)setHpBarScale
{
//    float hpBarScale =  (float) pkmnCurrentHealthPoints   / (float) pkmnHealthPoints;
//    [pkmnHpSprite setScaleX:hpBarScale];
    float hpPer = (float )characterCurrentHealthPoints / (float) characterHealthPoints;
    [hpFrontBar setScaleX:hpPer];
    
}
-(void)moveAimPoint
{
    //Values from the Aiming Stick
    CGPoint initialVel = theGame.JSAiming.velocity;
    
    //Check if user is not touching the aim stick
    if (initialVel.x == 0 && initialVel.y == 0)
    {
        [aimPointSprite setPosition:ccp(-100,-100)];
        return;
    }
    //With this values we can know the angle of the shoot.
    int angle = CC_RADIANS_TO_DEGREES(atan2(initialVel.y, initialVel.x));   
    
    
    //Set the velocity in ccp format.
    float velX = (sin(CC_DEGREES_TO_RADIANS(angle))*80);
    float velY = (cos(CC_DEGREES_TO_RADIANS(angle))*80); 
    CGPoint newPosition = CGPointMake(velY, velX);  
    
    [aimPointSprite setPosition:ccpAdd(characterSpriteTorso.position, newPosition)];
    
    [self setCharacterTorsoRotation:initialVel];
    
}
-(void)setCharacterLegsRotation:(CGPoint)vel
{
    //If user is not touching the moving stick
    if ( vel.x == 0 && vel.y)
        //Then left the sprite with actual rotation.
        [characterSpriteLegs setRotation:characterSpriteLegs.rotation];
    //If user is touching the moving stick.
    else
    {
        //Calculate the angle.
        float a = CC_RADIANS_TO_DEGREES(atan2(vel.y, vel.x));// (vel.y/vel.x);
        //Apply the rotation. I can't remember why I'm using the *-1, but it's working fine with it.
        [characterSpriteLegs setRotation:(a*-1)];  
        //        NSLog(@"X: %.2f  Y: %.2f  ATAN : %.2f",vel.x,vel.y,a);
    }    
}
-(void)setCharacterTorsoRotation:(CGPoint)vel
{
    //If user is not touching the moving stick
    if ( vel.x == 0 && vel.y)
        //Then left the sprite with actual rotation.
        [characterSpriteTorso setRotation:characterSpriteTorso.rotation];
    //If user is touching the moving stick.
    else
    {
        //Calculate the angle.
        float a = CC_RADIANS_TO_DEGREES(atan2(vel.y, vel.x));// (vel.y/vel.x);
        //Apply the rotation. I can't remember why I'm using the *-1, but it's working fine with it.
        [characterSpriteTorso setRotation:(a*-1)];  
//        NSLog(@"X: %.2f  Y: %.2f  ATAN : %.2f",vel.x,vel.y,a);
    }
}
-(void)moveCharacter:(ccTime)dt
{
    float finalVelocity = characterSpeed * bonusCharacterSpeed;    
    
    //Vel from the moving stick.
    CGPoint vel = ccpMult(theGame.JSMovement.velocity, finalVelocity);
    
    if (vel.x == 0 && vel.y == 0)
    {
//        [characterSpriteLegs pauseSchedulerAndActions];
        return;
    }    
    
    
    
    //Calculate the sprite new position.
    CGPoint pos = ccp (characterSpriteTorso.position.x + vel.x * dt, 
                       characterSpriteTorso.position.y + vel.y * dt );
    
    //Call the method to set the sprite rotation.
    [self setCharacterLegsRotation:vel];
    
    //Restriction the te movement. The sprite cant move out of the screen.
    if ((pos.x >= theGame.screenSize.width - characterSpriteTorso.contentSize.width/2) 
        || (pos.x <= characterSpriteTorso.contentSize.width/2))
    {
        if((pos.y <= theGame.screenSize.height - characterSpriteTorso.contentSize.height/2) 
           && (pos.y >= characterSpriteTorso.contentSize.height/2))
            [characterSpriteTorso setPosition:ccp (characterSpriteTorso.position.x , pos.y )];
    }else if ((pos.y >= theGame.screenSize.height - characterSpriteTorso.contentSize.height/2) 
              || (pos.y <= characterSpriteTorso.contentSize.height/2))
    {
        if ((pos.x <= theGame.screenSize.width - characterSpriteTorso.contentSize.width/2) 
            && (pos.x >= characterSpriteTorso.contentSize.width/2))        
            [characterSpriteTorso setPosition:ccp (pos.x , characterSpriteTorso.position.y )];
    }else 
        [characterSpriteTorso setPosition:pos];  
    
    [characterSpriteLegs setPosition:pos];
}

-(void)receiveDamage:(float)enemyDamage
{
    if (characterCurrentHealthPoints <= 0 && !isDead)
    {
        isDead = YES;
        [self unscheduleUpdate];
        [characterSpriteLegs stopAllActions];
        [theGame removeChild:characterSpriteLegs cleanup:YES];
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"characterDead.png"];
        [characterSpriteTorso setDisplayFrame:frame];
        
        [theGame gameOver];
        
    }else 
        characterCurrentHealthPoints -= enemyDamage * theGame.enemyManager.bonusEnemiesFreeze * bonusCharacterShield   ;
}
-(void)onExit
{
}
-(void)receiveExperience:(float)_experience
{
    characterXp += _experience * bonusCharacterXp;
    
    characterMoney += _experience * 0.87;
    
    if (characterXp >= xpToNextLevel)
    {
        characterLevel ++;
        xpToNextLevel = characterLevel * (133*characterLevel);        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:characterXp] forKey:@"NSCharacterXp"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:characterLevel] forKey:@"NSCharacterLevel"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:characterMoney] forKey:@"NSCharacterMoney"];
}

@end