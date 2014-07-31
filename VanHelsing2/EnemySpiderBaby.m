//  enemyVampire.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemySpiderBaby.h"

@implementation EnemySpiderBaby

//Set hp, speed, damage and enemy sprite name.
-(void)setSpiderAtributes
{
    //TESTING should do the testing when the game is almost finish and reevaluate this values
    //Setting HP, Speed and Damage.
    
    //Reset time between hits timer.
    timeBetweenHits = 0;
    //Set the delay between hits of this kind of enemy.
    enemyTimeBetweenHits = 0.8;
    
    enemyHealthPoints = 5;
    enemySpeed = (arc4random()%20)+ 80;        
    enemyDamage = 10;    
    
    spiderEnemyName = @"enemySpiderBaby";
    
}


-(void)checkHitCharacter
{
    //Check if this enemy sprite's bounds intersects the character sprite's bounds, and the enemy isn't dead, and isn't frozen.
    if ( CGRectIntersectsRect(theGame.character.characterSpriteTorso.boundingBox, enemySprite.boundingBox)
        && !isDead
        && theGame.enemyManager.bonusEnemiesFreeze == 1)
    {
        //Call the method to kill this enemy.
        [theGame.character receiveDamage:enemyDamage];
        [self killEnemy];
        //Send xp to character.
        [theGame.character receiveExperience:kEnemyXpBabySpider];
    }
}

@end