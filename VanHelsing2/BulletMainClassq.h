/*
//
//  WeaponMainClass.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 12/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WeaponBulletManager.h"
#import "CharacterClass.h"
@class CharacterClass;
@class WeaponBulletManager;
@class MainEnemyClass;

typedef enum kBulletType1
{
    kBulletNormal = 1,
    kBulletPlasma = 2,
    kBulletExplosive = 3,
    kBulletFire = 4,
    kBulletIon = 5,
    kBulletLaserBeam = 6,
    kBulletEnemyPlasma = 7,
    kBulletEnemy = 8,
    kBulletTotal = 9
}kBulletType1;

@interface BulletMainClass : CCNode 
{
    CCSprite * bulletSprite;
    WeaponBulletManager * weaponManager;
    GameScene * theGame;
    float angle;
    CGPoint vel;
    CGPoint finalVelocity;
    CGRect screenRect;
    
    MainEnemyClass * ownerEnemy;
    
    float bulletDamage;
    float bulletVelocity;
    BOOL bulletCanPerfore;     
    
    BOOL bulletShootByCharacter;
}
@property (nonatomic,assign)WeaponBulletManager * weaponManager;
@property (nonatomic,assign)GameScene * theGame;

#pragma mark CHARACTER BULLETS
-(id)initWithTheGame:(GameScene*)_theGame  andAngle:(int)_angle;
-(void)setBulletRotationAndVelocity;
#pragma mark ENEMIES BULLETS
-(id)initWithTheGame:(GameScene *)_theGame Angle:(int)_angle AndEnemyType:(MainEnemyClass *)_enemy;
-(void)setBulletSettingsForEnemy:(MainEnemyClass * )_enemy;
-(void)removeBullet;
@end
*/