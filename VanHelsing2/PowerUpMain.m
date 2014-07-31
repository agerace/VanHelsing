//
//  PowerUpMain.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 30/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PowerUpMain.h"
#import "BulletMainClass.h"

#import "PowerUpNukeBomb.h"

@implementation PowerUpMain

@synthesize theGame;

-(id)initWithTheGame:(GameScene *)_theGame andPosition:(CGPoint)_position andWeapon:(kCurrentWeapon)_type
{
    if (self = [super init])
    {   
        theGame = _theGame;
        weaponType = _type;
        position = _position;
        
        [theGame addChild:self];

        if (_type >8 )
            _type = 8;
        
        powerUpSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Weapon%d.png",_type]];
        [powerUpSprite setPosition:position];
        [theGame addChild:powerUpSprite z:300];
        [self schedule:@selector(erasePowerUp) interval:10];
        [self scheduleUpdate];
    }
    return self;
}

-(id)initWithTheGame:(GameScene *)_theGame andPosition:(CGPoint)_position andType:(kPowerUpType)_type
{
    if (self = [super init])
    {
        theGame = _theGame;  
        powerUpType = _type;
//        //Dev to thest the nuke bomb.
//        powerUpType = kPowerUpNukeBomb;
        position = _position;
        
        [theGame addChild:self];
        
        powerUpSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"powerUp%d.png",_type]];
        [powerUpSprite setPosition:position];
        [theGame addChild:powerUpSprite  z:300];
        [self schedule:@selector(erasePowerUp) interval:10];
        [self scheduleUpdate];
    }
    return self;
}
-(void)erasePowerUp
{
    [powerUpSprite runAction:[CCSequence actions:
                              [CCScaleTo actionWithDuration:0.5 scale:0.5],
                              [CCScaleTo actionWithDuration:0.5 scale:1],
                              [CCScaleTo actionWithDuration:0.5 scale:0.5],                              
                              [CCScaleTo actionWithDuration:0.5 scale:1],                              
                              [CCSpawn actions:
                               [CCScaleTo actionWithDuration:0.5 scale:0.1],
                               [CCFadeOut actionWithDuration:0.5], 
                               nil],
                              [CCCallFunc actionWithTarget:self selector:@selector(removePowerUp)],
                              nil]];
}
-(void)removePowerUp
{
    [self unscheduleAllSelectors];
    [self unscheduleUpdate];
    [theGame removeChild:powerUpSprite cleanup:YES];
    [theGame removeChild:self cleanup:YES];
    [theGame.powerUpManager.powerUpArray removeObject:self];
}
-(void)update:(ccTime)dt
{
    if (CGRectIntersectsRect([theGame.character.characterSpriteTorso boundingBox], [powerUpSprite boundingBox]))
        {
            [self unscheduleUpdate];
            [self activatePowerUp];
            [theGame.powerUpManager.powerUpArray removeObject:self];
            [theGame removeChild:powerUpSprite cleanup:YES];
            [theGame removeChild:self cleanup:YES];
        }
}

-(void)activatePowerUp
{
    if (weaponType)
    {
        [theGame.weaponManager setCurrentWeapon:weaponType]; 
    }else
    {
        
//        //DEV
//        powerUpType = kPowerUpNukeBomb;
        
        switch (powerUpType) {
            case kPowerUp1000ExperiencePoints:
            {
                
            }
                break;
            case kPowerUp2000ExperiencePoints:
            {
                
            }
                break;
            case kPowerUp500ExperiencePoints:
            {
                
            }
                break;
            case kPowerUpFireBulletsBomb:
            {
                for (int i = 0 ; i < 360 ; i += 23)
                {
                    BulletMainClass * bullet = [[BulletMainClass alloc]initWithTheGame:theGame andAngle:i andType:kBulletNormal  andEnemy:nil];
                    [theGame.weaponManager.bulletsArray addObject:bullet]; 
                }
                
            }
                break;
            case kPowerUpHeal:
            {
                if(theGame.character.characterCurrentHealthPoints < theGame.character.characterHealthPoints)
                {
                    theGame.character.characterCurrentHealthPoints += 25;
                    if( theGame.character.characterCurrentHealthPoints > theGame.character.characterHealthPoints)
                        theGame.character.characterCurrentHealthPoints = theGame.character.characterHealthPoints;
                }
                
            }
                break;
            case kPowerUpNukeBomb:
            {
                [self powerUpNukeBomb];
            }
                break;
            default:
            {
                [theGame.powerUpManager startPowerUp:powerUpType withInfo:nil];            
            }
                break;
        }            
    }

    
//    [theGame.powerUpManager startPowerUp:powerUpType withInfo:nil];    
    
}

-(void)powerUpNukeBomb
{
    
    PowerUpNukeBomb * bomb = [[PowerUpNukeBomb alloc]initWithTheGame:theGame];
    
    for (int i = 0 ; i < 360 ; i += (arc4random()%40+20))
    {
        BulletMainClass * bullet = [[BulletMainClass alloc] initWithTheGame:theGame andAngle:i andType:kBulletNormal  andEnemy:nil];
        [theGame.weaponManager.bulletsArray addObject:bullet];
    }
    
    [self nukeBlow];

}
-(void)nukeBlow
{
    //Radius in pixels;    
    float maxRadius = 140;
    CGRect blowArea = CGRectMake(powerUpSprite.position.x - maxRadius, powerUpSprite.position.y - maxRadius, maxRadius * 2, maxRadius * 2);
    
    for ( MainEnemyClass * enemy in theGame.enemyManager.enemiesArray )
    {
        if ( CGRectContainsPoint(blowArea , enemy.enemySprite.position))
        {
            [enemy killEnemy];
//            [self nukeBlow];
//            break;
        }
    }
}

@end
