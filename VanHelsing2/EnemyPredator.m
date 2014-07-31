//  enemyVampire.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemyPredator.h"

@implementation EnemyPredator

-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position
{
    if ( self = [super init])
    {
        //Enemy is not dead.
        isDead = NO;
        //Reset time between hits timer.
        timeBetweenHits = 0;
        //Set the delay between hits of this kind of enemy.
        enemyTimeBetweenHits = 1.2;
        
        //Assign the game scene.
        theGame = _theGame;
        //Add this node to the game.
        [theGame addChild:self];
        //Set the move state to move forward at first.
        moveState = kPredatorMoveForward;

        //Set the enemy type.
        enemyType = kEnemyPredator;
        //Set the margin to move.
        marginToMove = (arc4random()%26)+25;
        
        //TESTING should do the testing when the game is almost finish and reevaluate this values
        //Setting HP, Speed and Damage. 
        enemyHealthPoints = ( arc4random()%20 + 40);
        enemySpeed = (arc4random()%60)+60;
        enemyDamage = 20;
        
        //Create sprite, set the rotation and add it to the game scene.
        enemySprite = [CCSprite spriteWithSpriteFrameName:@"enemyPredator.png"];
        [enemySprite setPosition:_position];
        //Set the angle to move, and also set it to the actual angle since this enemy will start moving forward to the caracter's position when enemy is created.
        moveToAngle = [self angleToCharacter];
        actualAngle = moveToAngle;
        [enemySprite setRotation:moveToAngle];
        [theGame addChild:enemySprite z:200+[theGame.enemyManager.enemiesArray count]];
        //Set the enemy alpha to 0.
        [enemySprite setOpacity:75];
        
        [self runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:(float)(((arc4random()%40)+1)/10)],
                         [CCCallFunc actionWithTarget:self selector:@selector(setInitialPosition)],
                         nil]];
//        [self setInitialPosition];        
//        [enemySprite runAction:[CCSequence actions:
//                                [CCDelayTime actionWithDuration:0.2],
//                                [CCFadeIn actionWithDuration:1.2],
//                                nil]];
        

    }
    return self;    
}
-(void)setInitialPosition
{
    
         CGPoint initPosition;    
     if ( enemySprite.position.y > theGame.screenSize.height )
     {
         initPosition = CGPointMake(((arc4random()%(int)(theGame.screenSize.width - (marginToMove * 2)))+marginToMove),
                                    theGame.screenSize.height - marginToMove);
     }else if ( enemySprite.position.y < 0 )
     {
         initPosition = CGPointMake(((arc4random()%(int)(theGame.screenSize.width - (marginToMove * 2)))+marginToMove),
                                     marginToMove);         
     }else if ( enemySprite.position.x > theGame.screenSize.width )
     {
         initPosition = CGPointMake(theGame.screenSize.width - marginToMove ,
                                    ((arc4random()%(int)(theGame.screenSize.height - (marginToMove * 2)))+marginToMove));         
     }else if ( enemySprite.position.x < 0 )
     {
         initPosition = CGPointMake(marginToMove ,
                                    ((arc4random()%(int)(theGame.screenSize.height - (marginToMove * 2)))+marginToMove));                  
     }
    
//    [enemySprite setPosition:initPosition];
    [self changeMoveState];
    [self scheduleUpdate];    
}
//UPDATE
-(void)update:(ccTime)dt
{
    //Call move method.
    [self moveEnemy];
    //Call the hit character method.
    [self predatorCheckHitCharacter];
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
        case kPredatorMoveForward:
        {
            moveState = kPredatorTurnVisible;
            [self schedule:@selector(turnVisible) interval:0.1];      
            
        }
            break;
        case kPredatorTurnVisible:
        {     

            moveState = kPredatorFireAtWill;
            [self runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:(float)(((arc4random()%20)+21)/10)],
                            [CCCallFunc actionWithTarget:self selector:@selector(changeMoveState)],
                             nil] ];
            [self schedule:@selector(fireAtWill) interval:(float)((arc4random()%4)+1)/4];

        }
            break;
        case kPredatorFireAtWill:
        {   
            moveState = kPredatorTurnInvisible;
            [self unschedule:@selector(fireAtWill)];
            [self schedule:@selector(turnInvisible) interval:0.1];            
            
        }
            break;
        case kPredatorTurnInvisible:
        {
            moveState = kPredatorMoveForward;
            [self runAction:[CCSequence actions:
                             [CCDelayTime actionWithDuration:(float)(((arc4random()%20)+21)/10)],
                             [CCCallFunc actionWithTarget:self selector:@selector(changeMoveState)],
                             nil] ];            
    
        }
            break;
        default:
            break;
    }
    
}
-(void)turnInvisible
{
    if(enemySprite.opacity <= 75)
    {
        [self unschedule:@selector(turnInvisible)];
        [self changeMoveState];
        
    }else
        [enemySprite setOpacity:(enemySprite.opacity - 15)];
}
-(void)turnVisible
{
    if(enemySprite.opacity >= 255)
    {
        [self unschedule:@selector(turnVisible)];
        [self changeMoveState];
        
    }else
        [enemySprite setOpacity:(enemySprite.opacity + 15)];
}
-(void)fireAtWill
{
    BulletMainClass * bullet = [[BulletMainClass alloc] initWithTheGame:theGame andAngle:actualAngle andType:kBulletEnemyPlasma andEnemy:self ];
    [theGame.weaponManager.bulletsArray addObject:bullet];
}
-(void)rotateAction
{
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
    if (arc4random()%10 > 5)
        actualAngle = (( CC_RADIANS_TO_DEGREES(rot) ) *(-1))+arc4random()%10;
    else    
        actualAngle = (( CC_RADIANS_TO_DEGREES(rot) ) *(-1))-arc4random()%10;
}
-(void)moveAction
{
        if ( moveState)
        {

            //Calculate the real speed. At 60 frames per second, we want our enemy move his own speed in one second, so we divide this speed over 60 ( 60 frames per second ).
            float speed = (enemySpeed/60) * (theGame.enemyManager.bonusEnemiesVelocity) * (theGame.enemyManager.bonusEnemiesFreeze) ; // Move 50 pixels in 60 frames (1 second)
            //Get the distance in Y and X our enemy should move.
            float vx = cos(actualAngle * M_PI / 180) * speed;
            float vy = sin(actualAngle * M_PI / 180) * speed;
            CGPoint direction = ccp(vx,vy);
            //Move the sprite. The ccpAdd just add the 2nd ccp to the 1st ccp, so we don't have to do the pos.x + direction.x , pos.y + direction.y thing.
            [enemySprite setPosition:ccpAdd(enemySprite.position, direction)];                
        }
}

-(void)predatorCheckHitCharacter
{
    if ( timeBetweenHits > 0 )
        return;
    //Check if this enemy sprite's bounds intersects the character sprite's bounds
    if ( CGRectIntersectsRect(theGame.character.characterSpriteTorso.boundingBox, enemySprite.boundingBox))
    {
        //Call the method to kill this enemy.
        [enemySprite runAction:[CCFadeIn actionWithDuration:0.2]];
        [self checkHitCharacter];
    }
}

//MOVE THE ENEMY.
-(void)moveEnemy
{
    [self rotateAction];
    if (moveState == kPredatorTurnVisible || moveState == kPredatorTurnInvisible)
        return;
    
    if(moveState == kPredatorMoveForward)
        [self moveAction];
}

-(void)receiveShootWithDamage:(float)bulletDamage
{
    
    enemyHealthPoints -= bulletDamage;
    if(enemyHealthPoints <= 0 && !isDead)
    {
        isDead = YES;
        [self killEnemy];
        [enemySprite runAction:[CCSequence actions:
                                [CCFadeIn actionWithDuration:0.3],
                                [CCFadeOut actionWithDuration:0.1],
                                [CCFadeIn actionWithDuration:0.1],
                                [CCFadeOut actionWithDuration:0.1],
                                [CCFadeOut actionWithDuration:0.8],
                                nil]];
        [self unscheduleAllSelectors];
        //Send xp to character.
        [theGame.character receiveExperience:kEnemyXpPredator];
    }
}
-(void)killEnemy
{

    //DEVELOPEMENT By now we just change the sprite without animation. We should use a 5 or 6 frame animation instead of just changing the frame for the dead enemy frame.
    CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemyPredatorDead.png"];
    [enemySprite setDisplayFrame:frame];
    
    [enemySprite runAction:[CCSequence actions:
                            [CCRotateBy actionWithDuration:0.5 angle:50 ],
                            [CCScaleTo actionWithDuration:0.5 scale:0.5],
                            [CCCallFunc actionWithTarget:self selector:@selector(removeEnemy)],
                            nil]];

}


@end