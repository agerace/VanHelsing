//
//  mainEnemyClass.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 10/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainEnemyClass.h"

@implementation MainEnemyClass : CCNode
@synthesize theGame, enemyHealthPoints, enemySpeed, enemyDamage, enemySprite, enemyType;

//-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position andInfo:(NSMutableDictionary * )_enemyInfo
//{
//    if ( self = [super init] )
//    {
//        //Assign the game.
//        theGame = _theGame;
//        //Add this node to the game.
//        [theGame addChild:self];
//
//        //Setting HP and Speed.
//        //DEVELOPEMENT. We should do this more "maleable" so we can make different enemies, since the inheritance is not working. If we can make the inheritance works it'll be great, if not, we should to this like we do it in the Weapon Manager.
//        enemyHealthPoints = [[_enemyInfo valueForKey:@"enemyHealtPoints"] intValue] ;
//        enemySpeed = [[_enemyInfo valueForKey:@"enemyVelocity"] intValue];
//
//        //Create sprite and add it to the game scene.
//        enemySprite = [CCSprite spriteWithSpriteFrameName:@"enemyVampire.png"];
//        [enemySprite setPosition:_position];
//        [theGame addChild:enemySprite];
//        //Start update.
//        [self scheduleUpdate];
//    }
//    return self;
//}
-(void)receiveShootWithDamage:(float)bulletDamage
{
    //    NSLog(@"Damage: %.2f , HP : %.2f",bulletDamage,enemyHealthPoints);
    //
    //    enemyHealthPoints -= bulletDamage;
    //    if(enemyHealthPoints <= 0)
    //        [self killEnemy];
}
//-(void)update:(ccTime)dt
//{
//    //Call move method.
//    [self moveEnemy];
//    //Call the hit character method.
//    [self checkHitCharacter];
//}
-(void)killEnemy
{
    
}
-(void)bleedEnemyFromAngle:(float)_angle
{
    return;
    CCSprite * bloodSprite = [CCSprite spriteWithSpriteFrameName:@"blood.png"];
    [bloodSprite setRotation:(arc4random()%90)];
    float xScale = (arc4random()%7+3);
    float yScale = (arc4random()%7+3);
    [bloodSprite setScaleX:xScale / 10];
    [bloodSprite setScaleY:yScale / 10];
    [bloodSprite setPosition:enemySprite.position];
    [theGame.bloodSpritesNode addChild:bloodSprite z:200];
    
}
-(void)removeEnemy
{
    [self dropAtKill];
    //Add the sprite to the enemies sprites array.
    [theGame.enemyManager.enemiesDeadArray addObject:enemySprite];
    
    [enemySprite setZOrder:[theGame.enemyManager.enemiesDeadArray count]];
    
    //Remove this node from the game.
    [theGame removeChild:self cleanup:YES];
    //Remove this node from the enmies array.
    [theGame.enemyManager.enemiesArray removeObject:self];
    //Pause the schedules and actions so we can remove this node without crashing.
    [self pauseSchedulerAndActions];
}
-(void)checkHitCharacter
{
    if ( timeBetweenHits > 0 )
        return;
    //Check if this enemy sprite's bounds intersects the character sprite's bounds
    if ( CGRectIntersectsRect(theGame.character.characterSpriteTorso.boundingBox, enemySprite.boundingBox))
    {
        //Call the method to kill this enemy.
        [theGame.character receiveDamage:enemyDamage];
        timeBetweenHits = enemyTimeBetweenHits;
        [self unschedule:@selector(hitTimer)];        
        [self schedule:@selector(hitTimer) interval:0.1];
    }
}
-(void)hitTimer
{
    if ( timeBetweenHits <= 0)
        [self unschedule:@selector(hitTimer)];
    else
        timeBetweenHits -= 0.1;
}
-(void)dropAtKill
{
//    if ( 1==1)
//    {
//        //
//        //TEST
//        //
//        [theGame.powerUpManager createPowerUpFromDropAtPosition:enemySprite.position];
//    }
//    
//    return;
    
    if ((arc4random()%55) ==10)
    {
        [theGame.powerUpManager createWeaponDropAtPosition:enemySprite.position];
    }else if ((arc4random()%15) == 5)
    {
        [theGame.powerUpManager createPowerUpFromDropAtPosition:enemySprite.position];
    }
/*
    if ( 1==1)
    {
        //
        //TEST
        //
            [theGame.powerUpManager createPowerUpFromDropAtPosition:enemySprite.position];        
    }else{
        //    if ((arc4random()%30) >= 5)
        //Drop bonuses
        if ((arc4random()%100) ==10)
        {
            [theGame.powerUpManager createWeaponDropAtPosition:enemySprite.position];
        }else if ((arc4random()%30) == 5)
        {
            [theGame.powerUpManager createPowerUpFromDropAtPosition:enemySprite.position];
        }
    }
*/
    
    
    //Check if the dead enemies sprites are more than 200
    int maxDeadEnemyQty = 200;
    if ( [theGame.enemyManager.enemiesDeadArray count] > maxDeadEnemyQty )
    {
        //Then remove the older sprite.
        [theGame removeChild:[theGame.enemyManager.enemiesDeadArray objectAtIndex:0] cleanup:YES];
        //And remove it from the enemies sprites array.
        [theGame.enemyManager.enemiesDeadArray removeObjectAtIndex:0];
    }
}

-(void)moveEnemy
{
    return;
    //Get the position of this enemy sprite.
    CGPoint point2 = theGame.character.characterSpriteTorso.position;
    //Get the position of the character.
    CGPoint point1 = enemySprite.position;
    //Get the distance between both points.
    CGPoint resPoint = ccp(point2.x-point1.x,point2.y-point1.y);
    //Get the rotation so this enemy will always look in character direction.
    //DEVELOPEMENT This is just a beta behaive. Different enemies should have different behavies and move different from each others. This is working funny by now.
    float rot = atan2(-resPoint.y,resPoint.x);
    //Set the sprite rotation.
    if(theGame.enemyManager.bonusEnemiesFreeze == 1)
        [enemySprite setRotation:( CC_RADIANS_TO_DEGREES(rot) )];
    
    //Again, I'm using the *-1 but I haven't really clear why, but it work fine with it.
    float angle = ( CC_RADIANS_TO_DEGREES(rot) ) *-1;
    //Calculate the real speed. At 60 frames per second, we want our enemy move his own speed in one second, so we divide this speed over 60 ( 60 frames per second ).
    float speed = (enemySpeed/60) * (theGame.enemyManager.bonusEnemiesVelocity) * (theGame.enemyManager.bonusEnemiesFreeze) ; // Move 50 pixels in 60 frames (1 second)
    //Get the distance in Y and X our enemy should move.
    float vx = cos(angle * M_PI / 180) * speed;
    float vy = sin(angle * M_PI / 180) * speed;
    CGPoint direction = ccp(vx,vy);
    //Move the sprite. The ccpAdd just add the 2nd ccp to the 1st ccp, so we don't have to do the pos.x + direction.x , pos.y + direction.y thing.
    [enemySprite setPosition:ccpAdd(enemySprite.position, direction)];
}
@end
