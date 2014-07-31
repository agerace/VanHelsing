//
//  WeaponBulletManager.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 22/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "BulletMainClass.h"
@class GameScene;

typedef enum kCurrentWeapon
{
    kWeaponPistol = 1,
    kWeaponSubMachineGun = 2,
    kWeaponShotgun = 3,
    kWeaponAutomaticRifle = 4,
    kWeaponJackHamer = 5,
    kWeaponGaussGun = 6,
    kWeaponMiniGun = 7,
    kWeaponGaussShotgun = 8,
    kWeaponPlasmaRifle = 9,
    kWeaponPlasmaShotgun = 10,
    kWeaponIonRifle = 11,
    kWeaponIonShotgun = 12,
    kWeaponMisilLauncher = 13,
    kWeaponGranadeLauncher = 14,
    kWeaponMineLauncher = 15 ,
    kWeaponLaserBeam = 16 ,
    kWeaponFlameThrower = 17 ,
    kWeaponTotal = 18
}kCurrentWeapon;

@interface WeaponBulletManager : CCNode {
    GameScene * theGame;
    
    kCurrentWeapon currentWeapon;
    kCurrentWeapon mainWeapon;
    
    NSMutableArray * bulletsArray;    
    
    //BONUS 
    //Bonus multiplier for cadency.
    float bonusTimeCadency;    
    //Bonus multiplier for reload time.
    float bonusTimeToReload;        
    //Bonus multiplier for bullets per loader.
    int bonusBulletQuantityPerLoader;
    //Bonus multiplier for damage per bullet.
    float bonusBulletDamage;
    //Bonus multiplier for bullet velocity.
    float bonusBulletVelocity;
    //Bonus make bullets can perfore.
    BOOL bonusBulletCanPerfore;    
    //Bonus Weapon Power Up.
    float bonusWeaponPowerUp;
    
    //
    //Time between bullets.
    float timeCadency;
    //Time taked to reload.
    float timeToReload;
    //Bullets per loader.
    int bulletQuantityPerLoader;
    //Bulles left;
    int bulletLeftInLoader;
    //Damage per bullet.
    float bulletDamage;
    //Velocity of Bullet.
    float bulletVelocity;
    //Quantity of bullets per round.
    int bulletPerRound;
    //Variation of angle beetwen bullets. Algo así como el retroceso de la bala, o la inestabilidad.
    int bulletAngleVariation;
    //Bullet can traspase enemies.
    BOOL bulletCanPerfore;
    //User shooting chek.
    BOOL isShooting;
    //Realoading weapon.
    BOOL isReloading;
    //Time reloading.
    float timeReloading;
    
}
@property (nonatomic,readwrite)float bonusTimeCadency;
@property (nonatomic,readwrite)float bonusTimeToReload;
@property (nonatomic,readwrite)int bonusBulletQuantityPerLoader;
@property (nonatomic,readwrite)float bonusBulletDamage;
@property (nonatomic,readwrite)float bonusBulletVelocity;
@property (nonatomic,readwrite)BOOL bonusBulletCanPerfore;
@property (nonatomic,readwrite)float bonusWeaponPowerUp;


@property (nonatomic,readwrite)float timeCadency;
@property (nonatomic,readwrite)float timeToReload;
@property (nonatomic,readwrite)int bulletQuantityPerLoader;
@property (nonatomic,readwrite)int bulletLeftInLoader;
@property (nonatomic,readwrite)float bulletDamage;
@property (nonatomic,readwrite)float bulletVelocity;
@property (nonatomic,readwrite)int bulletPerRound;
@property (nonatomic,readwrite)int bulletAngleVariation;
@property (nonatomic,readwrite) BOOL bulletCanPerfore;

@property ( nonatomic,readonly) kCurrentWeapon currentWeapon;

@property (nonatomic,retain)NSMutableArray * bulletsArray;

@property (nonatomic,assign) GameScene * theGame;
@property (nonatomic,readwrite)BOOL isShooting;

-(id)initWithTheGame:(GameScene *)_theGame andWeapon:(kCurrentWeapon)_weapon;

//Set the current weapon.
-(void)setCurrentWeapon:(kCurrentWeapon)_weapon;
//Set settings for current weapon.
-(void)setWeaponSettings;
//Create bullets and shot them;
-(void)shoot;
//Disable all bonuses.
-(void)disableAllBonuses;
//Back to main weapon.
-(void)setMainWeapon; 
//Activate the Power Up Weapon.
-(void)activateWeaponPowerUp;
//Deactivate the Power Up Weapon.
-(void)deActivateWeaponPowerUp;
@end
