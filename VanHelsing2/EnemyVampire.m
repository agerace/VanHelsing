//  enemyVampire.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemyVampire.h"

@implementation EnemyVampire

-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position
{
    if ( self = [super init])
    {
        //Reset time between hits timer.
        timeBetweenHits = 0;
        //Set the delay between hits of this kind of enemy.
        enemyTimeBetweenHits = 0.5;
        
        theGame = _theGame;
        
        [theGame addChild:self];
        
        //Setting HP and Speed.
        enemyHealthPoints = ( arc4random()%60 + 30);
        enemySpeed = 55;        
        
        //Create sprite and add it to the game scene.
        enemySprite = [CCSprite spriteWithSpriteFrameName:@"enemyVampire.png"];
        [enemySprite setPosition:_position];
        [theGame addChild:enemySprite];
        [self scheduleUpdate];
    }
    return self;    
}
-(void)update:(ccTime)dt
{
    //Call move method.
    [self moveEnemy];
    //Call the hit character method.
    [self checkHitCharacter];    
}
-(void)receiveShootWithDamage:(float)bulletDamage
{
    enemyHealthPoints -= bulletDamage;
    if(enemyHealthPoints <= 0)
    {
        [self killEnemy];
        //Send xp to character.
        [theGame.character receiveExperience:kEnemyXpVampire];
    }
}
-(void)killEnemy
{
    //Do bonus and weapon.
    [self dropAtKill];

    //Pause the schedules and actions so we can remove this node without crashing.
    [self pauseSchedulerAndActions];
    //DEVELOPEMENT By now we just change the sprite without animation. We should use a 5 or 6 frame animation instead of just changing the frame for the dead enemy frame.
    CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemyVampireDead.png"];
    [enemySprite setDisplayFrame:frame];
    //Add the sprite to the enemies sprites array.
    [theGame.enemyManager.enemiesDeadArray addObject:enemySprite];    
    
    //Remove this node from the game.
    [theGame removeChild:self cleanup:YES];  
    //Remove this node from the enmies array.
    [theGame.enemyManager.enemiesArray removeObject:self]; 
}


@end