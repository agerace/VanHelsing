//
//  PowerUpsManager.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 30/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "PowerUpIndicator.h"
@class PowerUpIndicator;

typedef enum kPowerUpType
{
    kPowerUpWeapon = 1,
    kPowerUpSpeedUp = 2,
    kPowerUpShield = 3,
    kPowerUpPerforerBullets = 4,
    kPowerUpSlowMotion = 5,
    kPowerUpFreezeEnemies = 6,
    kPowerUpFireBulletsBomb = 7,
    kPowerUpNukeBomb = 8,
    kPowerUpDoubleExperience = 9,
    kPowerUpHeal = 10,
    kPowerUp500ExperiencePoints = 11,    
    kPowerUp1000ExperiencePoints = 12,
    kPowerUp2000ExperiencePoints = 13
}kPowerUpType;

@interface PowerUpManager : CCNode {
    GameScene * theGame;
    NSMutableArray * powerUpArray;
    
    int timePowerUpWeapon;
    int timePowerUpSpeedUp;
    int timePowerUpShield;
    int timePowerUpPerforerBullets;
    int timePowerUpSlowMotion;
    int timePowerUpFreezeEnemies;
    int timePowerUpDoubleExperience;
    
    BOOL activePowerUpWeapon;
    BOOL activePowerUpSpeedUp;    
    BOOL activePowerUpShield;
    BOOL activePowerUpPerforerBullets;
    BOOL activePowerUpSlowMotion;
    BOOL activePowerUpFreezeEnemies;
    BOOL activePowerUpDoubleExperience;
    
    int powerUpsActive;
    
    //Power up indicators
    PowerUpIndicator * indicatorWeapon;
    PowerUpIndicator * indicatorSpeedUp;
    PowerUpIndicator * indicatorShield;
    PowerUpIndicator * indicatorPerforerBullets;
    PowerUpIndicator * indicatorSlowMotion;
    PowerUpIndicator * indicatorFreezeEnemies;
    PowerUpIndicator * indicatorDoubleExperience;
    
    NSMutableArray * arrIndicators;
    
}
@property (nonatomic,assign)GameScene * theGame;
@property (nonatomic,retain) NSMutableArray * powerUpArray;
@property (nonatomic,readwrite)int powerUpsActive;
@property (nonatomic,retain) NSMutableArray * arrIndicators;

-(id)initWithTheGame:(GameScene *)_theGame;
//When character got a power up.
-(void)startPowerUp:(kPowerUpType)_type withInfo:(NSMutableDictionary *)_info;
//When power up ends.
-(void)endPowerUp:(kPowerUpType)_type;
//Create power ups when enemy drop it.
-(void)createPowerUpFromDropAtPosition:(CGPoint)_dropPosition;
//Create weapon drop.
-(void)createWeaponDropAtPosition:(CGPoint)_dropPosition;
//Create the power up active indicators.
-(void)createPowerUpIndicators;
@end
