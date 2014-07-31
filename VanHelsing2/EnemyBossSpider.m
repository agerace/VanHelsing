//  enemyVampire.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemyBossSpider.h"
#import "EnemySpiderBaby.h"

@implementation EnemyBossSpider

//Set hp, speed, damage and enemy sprite name.
-(void)setSpiderAtributes
{
    //TESTING should do the testing when the game is almost finished and reevaluate this values
    //Setting HP, Speed and Damage.

    //Reset time between hits timer.
    timeBetweenHits = 0;
    //Set the delay between hits of this kind of enemy.
    enemyTimeBetweenHits = 1.2;
    
    
    enemyHealthPoints = ( arc4random()%60 )+1500;
    enemySpeed = (arc4random()%10)+ 10;        
    enemyDamage = 150;    
    
    spiderEnemyName = @"enemyBossSpider";
    
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:((arc4random()%8)+5)/10],
                    [CCCallFunc actionWithTarget:self selector:@selector(spawnSpider)],
                     nil]];
}
-(void)receiveShootWithDamage:(float)bulletDamage
{
    
    enemyHealthPoints -= bulletDamage;
    if(enemyHealthPoints <= 0 && !isDead )
    {
        isDead = YES;
        [self killEnemy];
        //Send xp to character.
        [theGame.character receiveExperience:kEnemyBossSpider];
    }
}
-(void)spawnSpider
{
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:((arc4random()%8)+(8*theGame.enemyManager.bonusEnemiesVelocity))/8],
                     [CCCallFunc actionWithTarget:self selector:@selector(spawnSpider)],
                     nil]];
    if (theGame.enemyManager.bonusEnemiesFreeze != 0 )
    {
        EnemySpiderBaby * enemy = [[EnemySpiderBaby alloc] initWithGame:theGame andPosition:enemySprite.position];
        [theGame.enemyManager.enemiesArray addObject:enemy];
    }
}


@end