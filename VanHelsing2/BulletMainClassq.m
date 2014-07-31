/*
 //
//  WeaponMainClass.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 12/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BulletMainClass.h"


@implementation BulletMainClass

@synthesize theGame,weaponManager;

#pragma mark CHARACTER BULLETS

-(id)initWithTheGame:(GameScene*)_theGame andAngle:(int)_angle
{
    if ( self = [super init])
    {
        //Bullet fired by character
        bulletShootByCharacter = YES;        
        //Save the angle.
        angle  = _angle;
        //Assign the game.
        theGame = _theGame;
        //Assign the weapon manager
        weaponManager = theGame.weaponManager;
        //Add this node to the game scene.
        [theGame addChild:self];     
        //Save the screen rect.
        CGSize screenSize = [CCDirector sharedDirector].winSize; 
        screenRect = CGRectMake(0, 0, screenSize.width, screenSize.height) ;
        //Create the bullet sprite and add it to the game scene.
        bulletSprite = [CCSprite spriteWithSpriteFrameName:@"bulletLarge.png"];
        [bulletSprite setPosition:theGame.character.characterSpriteTorso.position];
        [theGame addChild:bulletSprite];
        //Set the bullet angle and velocity
        [self setBulletRotationAndVelocity];
        //Start the update.
        [self scheduleUpdate];
    }
    return self;
}
-(void)setBulletRotationAndVelocity
{
    //Check either: the ball can perfore or perfore power up is active.
    if (weaponManager.bulletCanPerfore || weaponManager.bonusBulletCanPerfore)
        bulletCanPerfore = YES;
    
    //Get the damage with bonuses.
    bulletDamage = weaponManager.bulletDamage * weaponManager.bonusBulletDamage * weaponManager.bonusWeaponPowerUp;
    //Get the velocity with bonuses.
    bulletVelocity = weaponManager.bulletVelocity * weaponManager.bonusBulletVelocity * weaponManager.bonusWeaponPowerUp;
    //Set the rotation.
    [bulletSprite setRotation:(angle*-1)]; 
    
    //Set the velocity in ccp format.
    float velX = (sin(CC_DEGREES_TO_RADIANS(angle))*bulletVelocity);
    float velY = (cos(CC_DEGREES_TO_RADIANS(angle))*bulletVelocity); 
    finalVelocity = CGPointMake(velY, velX);    
}

#pragma mark ENEMY BULLETS

-(id)initWithTheGame:(GameScene *)_theGame Angle:(int)_angle AndEnemyType:(MainEnemyClass *)_enemy
{
    if ( self = [super init])
    {
        ownerEnemy = _enemy;
        //Character didn't fire this bullet.
        bulletShootByCharacter = NO;
        //Save the angle.
        angle  = _angle;
        //Assign the game.
        theGame = _theGame;
        //Assign the weapon manager
        weaponManager = theGame.weaponManager;
        //Add this node to the game scene.
        [theGame addChild:self];     
        //Save the screen rect.
        CGSize screenSize = [CCDirector sharedDirector].winSize; 
        screenRect = CGRectMake(0, 0, screenSize.width, screenSize.height) ;
        //Set the bullet angle and velocity
        [self setBulletSettingsForEnemy:_enemy];
        //Start the update.
        [self scheduleUpdate];        
    }
    return self;
}

-(void)setBulletSettingsForEnemy:(MainEnemyClass *)_enemy
{
    switch (_enemy.enemyType) {
        case kEnemyPredator:
        {
            
            
            //Create the bullet sprite and add it to the game scene.
            bulletSprite = [CCSprite spriteWithSpriteFrameName:@"bulletPredator.png"];
            [bulletSprite setPosition:_enemy.enemySprite.position];
            [theGame addChild:bulletSprite];
            
            //Bullet can't perfore.
            bulletCanPerfore = NO;
            //Get the damage with bonuses.
            bulletDamage = 8;
            //Get the velocity with bonuses.
            bulletVelocity = 10;
            //Set the rotation.
            [bulletSprite setRotation:(angle*-1)]; 
            
            //Set the velocity in ccp format.
            float velX = (sin(CC_DEGREES_TO_RADIANS(angle))*bulletVelocity);
            float velY = (cos(CC_DEGREES_TO_RADIANS(angle))*bulletVelocity); 
            finalVelocity = CGPointMake(velY, velX);             
        }
            break;
            
        default:
            break;
    }
}

#pragma mark GENERIC METHODS

-(void)update:(ccTime)dt
{

}
-(void)updateNormal
{
    //Check if the bullet is inside the screen.
    if (CGRectIntersectsRect(bulletSprite.boundingBox, screenRect)) {
        
        //Get the bullet next position, adding the velocity to the position, and then setting it.
        CGPoint pos = ccp (bulletSprite.position.x + finalVelocity.x,
                           bulletSprite.position.y + finalVelocity.y );
        [bulletSprite setPosition:pos];
        
        if (!bulletShootByCharacter) {
            if (CGRectIntersectsRect(bulletSprite.boundingBox, [theGame.character.characterSpriteTorso boundingBox]))
            {
                [theGame.character receiveDamage:bulletDamage];
                [self removeBullet];
                return;
            }
        }
        
        //Bucle to check if bullet hit an enemy.
        for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
        {
            //Check if bullet bounds intersects enemy bounds.
            if (CGRectIntersectsRect(bulletSprite.boundingBox, enemy.enemySprite.boundingBox))
            {
                //If enemy hited is the owner of bullet do nothing
                if(enemy == ownerEnemy)
                {
                    //If bullet can perfore then just kill the enemy, so the bullet will follow his way.
                }else
                {
                    [enemy bleedEnemyFromAngle:angle];
                    //Kill enemy.
                    [enemy receiveShootWithDamage:bulletDamage];
                    if (!bulletCanPerfore)
                        //Remove bullet.
                        [self removeBullet];
                }
                return;
            }
        }
        //If bullet is out of screen then remove it.
    }else
    {
        //Call the remove method
        [self removeBullet];
    }
    
}
-(void)removeBullet
{
    //Pause the schedule and all actions so when we remove the node it won't crash because of the schedules or actions.
    [self pauseSchedulerAndActions]; 
    //Remove this node from the game.
    [theGame removeChild:self cleanup:YES];
    //Remove the bullet sprite from the game.
    [theGame removeChild:bulletSprite cleanup:YES];
    //Remove this node from the bullets array.
    [theGame.weaponManager.bulletsArray removeObject:self];
}
@end
*/