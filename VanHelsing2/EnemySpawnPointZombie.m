//  enemyVampire.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemySpawnPointZombie.h"
#import "EnemyZombie.h"

@implementation EnemySpawnPointZombie

-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position
{
    if ( self = [super init])
    {
        isDead = NO;
        
        theGame = _theGame;
        
        [theGame addChild:self];
             
        enemyHealthPoints = ( arc4random()%20 )+ 500;        
        
        //Create sprite and add it to the game scene.
        enemySprite = [CCSprite spriteWithSpriteFrameName:@"SPZombie.png"];
        [enemySprite setPosition:_position];
        [theGame addChild:enemySprite z:200+[theGame.enemyManager.enemiesArray count]];
        
        [self runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:((arc4random()%8)+20)/10],
                         [CCCallFunc actionWithTarget:self selector:@selector(spawnZombie)],
                         nil]];        
    }
    return self;    
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
-(void)killEnemy
{
    //Send xp to character.
    [theGame.character receiveExperience:kEnemySpawnPointZombie];
    
    //DEVELOPEMENT By now we just change the sprite without animation. We should use a 5 or 6 frame animation instead of just changing the frame for the dead enemy frame.
    CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"SPZombieDead.png"]];
    [enemySprite setDisplayFrame:frame];
}
-(void)update:(ccTime)dt
{
//    [self checkHitCharacter]; 
}

-(void)spawnZombie
{
    EnemyZombie * enemy = [[EnemyZombie alloc] initWithGame:theGame andPosition:enemySprite.position];
    [theGame.enemyManager.enemiesArray addObject:enemy];    
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:((arc4random()%10)+10)/5],
                     [CCCallFunc actionWithTarget:self selector:@selector(spawnZombie)],
                     nil]];    
}


@end