//  enemyVampire.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemyZombie.h"

@implementation EnemyZombie

-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position
{
    if ( self = [super init])
    {
        
        //Enemy is not dead.
        isDead = NO;
        //Assign the game scene.
        theGame = _theGame;
        //Add this node to the game.
        [theGame addChild:self];
        
        
        bonusZombieRageSpeed = 1;
        isInMovementArea = NO;
        isAvoidingEnemy = NO;
        moveState = kZombieMoveForward;
        

        //Set zombie atributes.
        [self setZombieAtributes];
        
        //Create sprite, set the rotation and add it to the game scene.
        enemySprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",zombieEnemyName]];
        [enemySprite setPosition:_position];
        //Set the angle to move, and also set it to the actual angle since this enemy will start moving forward to the caracter's position when enemy is created.
        moveToAngle = [self angleToCharacter];
        actualAngle = moveToAngle;
        [enemySprite setRotation:moveToAngle];
        [theGame addChild:enemySprite z:200+[theGame.enemyManager.enemiesArray count]];
        [self scheduleUpdate];      
        
    }
    return self;    
}
//Set hp, speed, damage and enemy sprite name.
-(void)setZombieAtributes
{
    //TESTING should do the testing when the game is almost finish and reevaluate this values
    //Setting HP, Speed and Damage.
    
    //Reset time between hits timer.
    timeBetweenHits = 0;
    //Set the delay between hits of this kind of enemy.
    enemyTimeBetweenHits = 2;
    
    enemyHealthPoints = ( arc4random()%20 )+ 100;
    enemySpeed = (arc4random()%20)+ 10;
    enemyDamage = 50;
    
    zombieEnemyName = @"enemyZombie";
}
-(void)update:(ccTime)dt
{
    //Call move method.
    [self moveEnemy];
    //Call the hit character method.
    [self checkHitCharacter];
//    //Call the hit enemy method.
//    if (!isAvoidingEnemy)
//        [self checkHitEnemy];
}
-(void)receiveShootWithDamage:(float)bulletDamage
{
    enemyHealthPoints -= bulletDamage;
    if(enemyHealthPoints <= 0 && !isDead)
    {
        isDead = YES;
        [self killEnemy];
    }
}
-(void)checkHitEnemy
{
    for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
    {
        if ( enemy != self )
        {
            if ( CGRectIntersectsRect(enemy.enemySprite.boundingBox, self.enemySprite.boundingBox))
            {
                [self changeDirectionToAvoidEnemy];
                if ( arc4random()%10 > 8 )
                    bonusZombieRageSpeed = 2.5;
                break;
            }
        }
        
        
    }
}
-(void)changeDirectionToAvoidEnemy
{
    isAvoidingEnemy = YES;    
    moveFromAngle = actualAngle;
    moveToAngle = [self angleToRandom];
    moveState = kZombieMoveForwardAndRotate;
}
-(void)changeMoveState
{
//    [self unschedule:@selector(changeActualAngle)];   
    moveFromAngle = actualAngle;
    moveToAngle = [self angleToCharacter];
    moveState = kZombieMoveForwardAndRotate;
}
-(int)angleToRandom
{
    //Get angle to a random point on the screen.
    //Get angle to character.
    CGPoint point2 = theGame.character.characterSpriteTorso.position;
//    //Get a random point in the screen.
//    CGPoint point2 = CGPointMake (arc4random()%(int)(theGame.screenSize.width) ,arc4random()%(int)(theGame.screenSize.height));
    
    //Get the position of this enemy sprite.
    CGPoint point1 = enemySprite.position;
    //Get the distance between both points.
    CGPoint resPoint = ccp(point2.x-point1.x,point2.y-point1.y);
    //Get the rotation so this enemy will always look in character direction.
    float rot = atan2(-resPoint.y,resPoint.x);
    //Convert angle from radians to degrees.
    int angle = CC_RADIANS_TO_DEGREES(rot);
    
    if ( arc4random()%10 > 5)
        angle = angle + (arc4random()%50) +25;
    else
        angle = angle - (arc4random()%50) - 25;
    
    return angle;
}
-(int)angleToCharacter
{
    //Get angle to character.
    CGPoint point2 = theGame.character.characterSpriteTorso.position;
    
    //Get the position of this enemy sprite.    
    CGPoint point1 = enemySprite.position;
    //Get the distance between both points.
    CGPoint resPoint = ccp(point2.x-point1.x,point2.y-point1.y);
    //Get the rotation so this enemy will always look in character direction.
    float rot = atan2(-resPoint.y,resPoint.x);
    //Convert angle from radians to degrees.
    int angle = CC_RADIANS_TO_DEGREES(rot);
    
    if ( arc4random()%10 > 5)
        angle = angle + (arc4random()%10) +5;
    else
        angle = angle - (arc4random()%10) - 5;
    
//    if ( arc4random()%10 > 5)
//        angle = angle + (arc4random()%25) +10;
//    else
//        angle = angle - (arc4random()%25) - 10;
    
    return angle;
}

-(void)lookForBorders
{
    int margin = 50;
    CGRect movementArea = CGRectMake( margin, margin, theGame.screenSize.width - (margin*2), theGame.screenSize.height - (margin*2));
    
    if (!(CGRectContainsPoint(movementArea, enemySprite.position)) && isInMovementArea)
    {
        [self unschedule:@selector(changeMoveState)];        
        moveToAngle = [self angleToCharacter];
        isInMovementArea = NO;
        moveState = kZombieMoveForwardAndRotate;
    }
    else if ((CGRectContainsPoint(movementArea, enemySprite.position)) && !isInMovementArea)
    {
        [self schedule:@selector(changeMoveState) interval:(((arc4random()%50)+40)/10)]; 
        isInMovementArea = YES;
    }
}
-(void)changeActualAngle
{
//    if (arc4random()%10 > 5)
//        actualAngle = actualAngle + ((arc4random()%15)+5);
//    else
//        actualAngle = actualAngle - ((arc4random()%15)+5);
    if (arc4random()%10 > 5)
        actualAngle = actualAngle + ((arc4random()%5)+2);
    else
        actualAngle = actualAngle - ((arc4random()%5)+2);
}
-(void)walkAction
{
    
    //Calculate the real speed. At 60 frames per second, we want our enemy move his own speed in one second, so we divide this speed over 60 ( 60 frames per second ).
    float speed = (enemySpeed/60) * (theGame.enemyManager.bonusEnemiesVelocity) * (theGame.enemyManager.bonusEnemiesFreeze) * bonusZombieRageSpeed ; // Move 50 pixels in 60 frames (1 second)
    //Get the distance in Y and X our enemy should move.
    float vx = cos(actualAngle*(-1) * M_PI / 180) * speed;
    float vy = sin(actualAngle*(-1) * M_PI / 180) * speed;
    CGPoint direction = ccp(vx,vy);
    //Move the sprite. The ccpAdd just add the 2nd ccp to the 1st ccp, so we don't have to do the pos.x + direction.x , pos.y + direction.y thing.
    [enemySprite setPosition:ccpAdd(enemySprite.position, direction)];        
}
-(void)rotateAction
{
    
    int realActualAngle = actualAngle * (-1);
    int realMoveToAngle = moveToAngle * (-1);
    int realMoveFromAngle = moveFromAngle * (-1);
    
    if (realActualAngle <0)
        realActualAngle +=360;
    
    if (realMoveToAngle <0)
        realMoveToAngle +=360;
    
    if (realMoveFromAngle <0)
        realMoveFromAngle +=360;
    
    if (realActualAngle >= ( realMoveToAngle -3) && realActualAngle <= ( realMoveToAngle +3) )
    {
        moveState = kZombieMoveForward;
        isAvoidingEnemy = NO;
        if(arc4random()%100 > 85)
            bonusZombieRageSpeed = 2;
        else
            bonusZombieRageSpeed = 1;
    }else if ( realMoveToAngle > realMoveFromAngle )
    {
        if ( (realMoveToAngle-realMoveFromAngle) > (realMoveFromAngle +(360-realMoveToAngle)))
            realActualAngle -= 4;
        else
            realActualAngle += 4;
    }else
    {
        if ( (realMoveFromAngle-realMoveToAngle) > (realMoveToAngle +(360-realMoveFromAngle)))
            realActualAngle += 4;
        else
            realActualAngle -= 4;        
    }     
    
    if (realActualAngle >180)
        realActualAngle -=360;
    realActualAngle = realActualAngle * (-1);
    actualAngle = realActualAngle;    
}
-(void)moveEnemy
{
    [self lookForBorders];
    if(moveState == kZombieMoveForwardAndRotate)
    {
        [self rotateAction];
        [self walkAction];
    }else if (moveState == kZombieMoveForward)
    {
        [self walkAction];
    }else if (moveState == kZombieMoveRotate)
    {
        [self rotateAction];
    }
    
    if(theGame.enemyManager.bonusEnemiesFreeze == 1)
        [enemySprite setRotation:actualAngle];
}

-(void)killEnemy
{
    //DEVELOPEMENT By now we just change the sprite without animation. We should use a 5 or 6 frame animation instead of just changing the frame for the dead enemy frame.
    CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@Dead.png",zombieEnemyName]];
    [enemySprite setDisplayFrame:frame];
    [enemySprite runAction:[CCSequence actions:
                            [CCRotateBy actionWithDuration:0.5 angle:50 ],
                            [CCScaleTo actionWithDuration:0.5 scale:0.5],
                            [CCCallFunc actionWithTarget:self selector:@selector(removeEnemy)],
                            nil]];
}

@end