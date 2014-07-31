//
//  BulletMainClass.h
//  VanHelsing2
//
//  Created by César Andrés Gerace on 11/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "WeaponBulletManager.h"
#import "CharacterClass.h"
@class CharacterClass;
@class WeaponBulletManager;
@class MainEnemyClass;

typedef enum kBulletType
{
    //Character bullets.
    kBulletNormal = 1,
    kBulletGauss = 2,
    kBulletPlasma = 3,
    kBulletIon = 4,
    kBulletMisil = 5,
    kBulletGranade = 6,
    kBulletMine = 7,
    kBulletFlame = 8,
    kBulletLaser = 9,

    //Enemies bullets.
    kBulletEnemyPlasma = 10,
    kBulletEnemy = 11,
    kBulletTotal = 12
}kBulletType;

@interface BulletMainClass : CCNode
{
    CCSprite * bulletSprite;
    
    CCSprite * bulletAuxSprite;
    
    WeaponBulletManager * weaponManager;
    GameScene * theGame;
    float angle;
    CGPoint vel;
    CGPoint finalVelocity;
    CGRect screenRect;
    
    kBulletType bulletType;
    
    MainEnemyClass * ownerEnemy;
    
    float bulletDamage;
    float bulletVelocity;
    BOOL bulletCanPerfore;
    
    BOOL bulletShootByCharacter;
    
    CGPoint initPos;
    CGPoint endPos;
    float bulletOpacity;
}
@property (nonatomic,assign)WeaponBulletManager * weaponManager;
@property (nonatomic,assign)GameScene * theGame;

-(id)initWithTheGame:(GameScene*)_theGame andAngle:(int)_angle andType:(kBulletType)_type andEnemy:(MainEnemyClass *)_enemy;
-(void)setBulletRotationAndVelocity;
-(void)removeBullet;
@end
