//  enemyVampire.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemySpider.h"

@implementation EnemySpider

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
        //Set the move state to move forward at first.
        moveState = kSpiderMoveRotateAndForward;

        
        //Set spider atributes.
        [self setSpiderAtributes];

        
        //Create sprite, set the rotation and add it to the game scene.
        enemySprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",spiderEnemyName]];
        [enemySprite setPosition:_position];
        //Set the angle to move, and also set it to the actual angle since this enemy will start moving forward to the caracter's position when enemy is created.
        moveToAngle = [self angleToCharacter];
        actualAngle = moveToAngle;
        [enemySprite setRotation:moveToAngle];
        [theGame addChild:enemySprite z:200+[theGame.enemyManager.enemiesArray count]];
        [self changeMoveState];
        [self scheduleUpdate];
    }
    return self;    
}
//Set hp, speed, damage and enemy sprite name.
-(void)setSpiderAtributes
{    
    //TESTING should do the testing when the game is almost finish and reevaluate this values
    //Setting HP, Speed and Damage.

    //Reset time between hits timer.
    timeBetweenHits = 0;
    //Set the delay between hits of this kind of enemy.
    enemyTimeBetweenHits = 1;
    
    enemyHealthPoints = ( arc4random()%20 + 40);
    enemySpeed = (arc4random()%60)+100;        
    enemyDamage = 20;
    
    spiderEnemyName = @"enemySpider";
    
}
//UPDATE
-(void)update:(ccTime)dt
{
    //Call move method.
    [self moveEnemy];
    //Call the hit character method.
    [self checkHitCharacter];    
}
//GET ANGLE TO CHARACTER SPRITE.
-(int)angleToCharacter
{
    //Get the position of this enemy sprite.
    CGPoint point2 = theGame.character.characterSpriteTorso.position;
    //Get the position of the character.
    CGPoint point1 = enemySprite.position;
    //Get the distance between both points.
    CGPoint resPoint = ccp(point2.x-point1.x,point2.y-point1.y);
    //Get the rotation so this enemy will always look in character direction.
    float rot = atan2(-resPoint.y,resPoint.x);
    //Convert angle from radians to degrees.
    float angle = CC_RADIANS_TO_DEGREES(rot);
    
    if ( arc4random()%10 > 5)
        angle = angle + (arc4random()%15);
    else
        angle = angle - (arc4random()%15);
    
    return angle;
}

-(void)changeMoveState
{
    switch (moveState) {
        case kSpiderMoveStayQuiet:
        {
            moveToAngle = [self angleToCharacter];
            moveFromAngle = actualAngle;
            moveState = kSpiderMoveRotateAndForward;            
        }
            break;
        case kSpiderMoveRotateAndForward:
        {
            float waitTime = (float) (arc4random()%40);
            [self runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:(waitTime/10)],
                             [CCCallFunc actionWithTarget:self selector:@selector(changeMoveState)],
                             nil]];    
            if ( arc4random()%10 > 5)
                actualAngle = actualAngle + (arc4random()%25);
            else
                actualAngle = actualAngle - (arc4random()%25);
            moveState = kSpiderMoveForward;
        }
            break;
        case kSpiderMoveForward:
        {   
            moveState = kSpiderMoveStayQuiet;            
            float waitTime = arc4random()%40;
            [self runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:(waitTime/10)],
                             [CCCallFunc actionWithTarget:self selector:@selector(changeMoveState)],
                             nil]];
            
        }
            break;
        default:
            break;
    }
    
}

//MOVE THE ENEMY.
-(void)moveEnemy
{
    if (moveState == kSpiderMoveStayQuiet)
        return;
    if(moveState == kSpiderMoveRotateAndForward)
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
        
        if (realActualAngle >= ( realMoveToAngle -2) && realActualAngle <= ( realMoveToAngle +2) )
        {
            [self changeMoveState];
        }else if ( realMoveToAngle > realMoveFromAngle )
        {
            if ( (realMoveToAngle-realMoveFromAngle) > (realMoveFromAngle +(360-realMoveToAngle)))
                realActualAngle -= 3;
            else
                realActualAngle += 3;
        }else
        {
            if ( (realMoveFromAngle-realMoveToAngle) > (realMoveToAngle +(360-realMoveFromAngle)))
                realActualAngle += 3;
            else
                realActualAngle -= 3;        
        }     
        
        if (realActualAngle >180)
            realActualAngle -=360;
        realActualAngle = realActualAngle * (-1);
        actualAngle = realActualAngle;
    }
    
    if(theGame.enemyManager.bonusEnemiesFreeze == 1)
        [enemySprite setRotation:actualAngle];

    
        //Calculate the real speed. At 60 frames per second, we want our enemy move his own speed in one second, so we divide this speed over 60 ( 60 frames per second ).
        float speed = (enemySpeed/60) * (theGame.enemyManager.bonusEnemiesVelocity) * (theGame.enemyManager.bonusEnemiesFreeze) ; // Move 50 pixels in 60 frames (1 second)
        //Get the distance in Y and X our enemy should move.
        float vx = cos(actualAngle*(-1) * M_PI / 180) * speed;
        float vy = sin(actualAngle*(-1) * M_PI / 180) * speed;
        CGPoint direction = ccp(vx,vy);
        //Move the sprite. The ccpAdd just add the 2nd ccp to the 1st ccp, so we don't have to do the pos.x + direction.x , pos.y + direction.y thing.
        [enemySprite setPosition:ccpAdd(enemySprite.position, direction)];    

}

-(void)receiveShootWithDamage:(float)bulletDamage
{
    
    enemyHealthPoints -= bulletDamage;
    if(enemyHealthPoints <= 0 && !isDead)
    {
        isDead = YES;
        [self killEnemy];
        //Send xp to character.
        [theGame.character receiveExperience:kEnemyXpSpider];
    }
}
-(void)killEnemy
{
    [self pauseSchedulerAndActions];
    [enemySprite stopAllActions];
    //DEVELOPEMENT By now we just change the sprite without animation. We should use a 5 or 6 frame animation instead of just changing the frame for the dead enemy frame.
    CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@Dead.png",spiderEnemyName]];
    [enemySprite setDisplayFrame:frame];
    [enemySprite runAction:[CCSequence actions:
                     [CCRotateBy actionWithDuration:0.15 angle:50 ],
                     [CCScaleTo actionWithDuration:0.15 scale:0.5],
                     [CCCallFunc actionWithTarget:self selector:@selector(removeEnemy)],
                     nil]];
//    [self removeEnemy];

}


@end