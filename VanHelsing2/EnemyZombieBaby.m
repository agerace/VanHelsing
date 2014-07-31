//  enemyVampire.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemyZombieBaby.h"

@implementation EnemyZombieBaby

//Set hp, speed, damage and enemy sprite name.
-(void)setZombieAtributes
{
    //TESTING should do the testing when the game is almost finish and reevaluate this values
    //Setting HP, Speed and Damage. 
    enemyHealthPoints = 5;
    enemySpeed = (arc4random()%20)+ 80;        
    enemyDamage = 20;
    
    //Reset time between hits timer.
    timeBetweenHits = 0;
    //Set the delay between hits of this kind of enemy.
    enemyTimeBetweenHits = 1.6;
    
    zombieEnemyName = @"enemyZombieBaby";
    
}


-(void)checkHitCharacter
{
    //Check if this enemy sprite's bounds intersects the character sprite's bounds
    if ( CGRectIntersectsRect(theGame.character.characterSpriteTorso.boundingBox, enemySprite.boundingBox) && !isDead)
    {
        //Call the method to kill this enemy.
        [theGame.character receiveDamage:enemyDamage];
        [self killEnemy];
        //Send xp to character.
        [theGame.character receiveExperience:kEnemyXpBabyZombie];
    }
}

@end