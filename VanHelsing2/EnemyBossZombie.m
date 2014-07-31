//  enemyVampire.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemyBossZombie.h"
#import "EnemyZombieBaby.h"

@implementation EnemyBossZombie

//Set hp, speed, damage and enemy sprite name.
-(void)setZombieAtributes
{
    //TESTING should do the testing when the game is almost finish and reevaluate this values
    //Setting HP, Speed and Damage.
    
    //Reset time between hits timer.
    timeBetweenHits = 0;
    //Set the delay between hits of this kind of enemy.
    enemyTimeBetweenHits = 2.5;
    
    enemyHealthPoints = ( arc4random()%60 )+1000;
    enemySpeed = (arc4random()%20)+ 10;        
    enemyDamage = 150;    
    
    zombieEnemyName = @"enemyBossZombie";
    
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:((arc4random()%8)+5)/10],
                    [CCCallFunc actionWithTarget:self selector:@selector(spawnZombie)],
                     nil]];
}

-(void)receiveShootWithDamage:(float)bulletDamage
{
    
    enemyHealthPoints -= bulletDamage;
    if(enemyHealthPoints <= 0 && !isDead)
    {
        isDead = YES;
        [self killEnemy];
        //Send xp to character.
        [theGame.character receiveExperience:kEnemyBossZombie];
    }
}

-(void)spawnZombie
{
    [self runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:((arc4random()%8)+(8*theGame.enemyManager.bonusEnemiesVelocity))/6],
                     [CCCallFunc actionWithTarget:self selector:@selector(spawnZombie)],
                     nil]];
    if (theGame.enemyManager.bonusEnemiesFreeze != 0 )
    {
        EnemyZombieBaby * enemy = [[EnemyZombieBaby alloc] initWithGame:theGame andPosition:enemySprite.position];
        [theGame.enemyManager.enemiesArray addObject:enemy];
    }
}


@end