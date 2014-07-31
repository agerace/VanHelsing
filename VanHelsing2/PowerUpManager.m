//
//  PowerUpsManager.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 30/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PowerUpManager.h"
#import "PowerUpMain.h"
#import "WeaponBulletManager.h"


@implementation PowerUpManager

@synthesize theGame, powerUpArray, powerUpsActive, arrIndicators;

-(id)initWithTheGame:(GameScene *)_theGame
{
    if (self = [super init])
    {
        theGame = _theGame;
        [theGame addChild:self];
        powerUpsActive = 0;
        powerUpArray = [[NSMutableArray alloc]initWithCapacity:0];
        arrIndicators = [[NSMutableArray alloc]initWithObjects:
                         [NSNull null],
[NSNull null],
                         [NSNull null],
                         [NSNull null],
                         [NSNull null],
                         [NSNull null],
                         nil];
        [self createPowerUpIndicators];
        [self schedule:@selector(timer) interval:0.1];
    }
    return self;
}
-(void)createWeaponDropAtPosition:(CGPoint)_dropPosition
{
    int weaponVariable = (arc4random()%(kWeaponTotal-3))+3;
    
    PowerUpMain *powerUp = [[PowerUpMain alloc] initWithTheGame:theGame andPosition:_dropPosition andWeapon:weaponVariable];

    [powerUpArray addObject:powerUp];    
}
-(void)createPowerUpFromDropAtPosition:(CGPoint)_dropPosition
{
    int randomVariable = (arc4random()%13)+1;

    PowerUpMain *powerUp = [[PowerUpMain alloc]initWithTheGame:theGame andPosition:_dropPosition andType:randomVariable];    
    
    [powerUpArray addObject:powerUp];
    
}

//ARRAY PARA VER EN QUE POSICION ESTA CADA INDICADOR DE POWER UP Y PODER HACER QUE APAREZCA ARRIBA DE OTROS, O ABAJO, SEGÚN
//LOS QUE ESTÉN Y LOS QUE DEJEN DE ESTAR. 
-(void)startPowerUp:(kPowerUpType)_type withInfo:(NSMutableDictionary *)_info
{
    switch (_type) {
        case kPowerUpWeapon:
        {
            if (!activePowerUpWeapon)
            {
                for (int i = 0 ; i < [arrIndicators count] ; i ++)
                {
                    if ([[arrIndicators objectAtIndex:i] isKindOfClass:[NSNull class]])
                    {
                        [arrIndicators replaceObjectAtIndex:i withObject:indicatorWeapon];
                        break;
                    }
                }
            }
            theGame.weaponManager.bonusWeaponPowerUp = 2;
            theGame.weaponManager.bulletLeftInLoader = theGame.weaponManager.bulletQuantityPerLoader;
            activePowerUpWeapon = YES;
            timePowerUpWeapon += 50;
            [indicatorWeapon setTotalTime:50];
        }
            break;
        case kPowerUpSpeedUp:
        {
            if (!activePowerUpSpeedUp)
            {
                for (int i = 0 ; i < [arrIndicators count] ; i ++)
                {
                    if ([[arrIndicators objectAtIndex:i] isKindOfClass:[NSNull class]])
                    {
                        [arrIndicators replaceObjectAtIndex:i withObject:indicatorSpeedUp];
                        break;
                    }
                }
            }
            theGame.character.bonusCharacterSpeed = 2;
            activePowerUpSpeedUp = YES;
            timePowerUpSpeedUp += 50;
            [indicatorSpeedUp setTotalTime:50];
        }
            break;
        case kPowerUpPerforerBullets:
        {
            if (!activePowerUpPerforerBullets)
            {
                for (int i = 0 ; i < [arrIndicators count] ; i ++)
                {
                    if ([[arrIndicators objectAtIndex:i] isKindOfClass:[NSNull class]])
                    {
                        [arrIndicators replaceObjectAtIndex:i withObject:indicatorPerforerBullets];
                        break;
                    }
                }
            }
            theGame.weaponManager.bonusBulletCanPerfore = YES;
            activePowerUpPerforerBullets = YES;
            timePowerUpPerforerBullets += 50;
            [indicatorPerforerBullets setTotalTime:50];
        }
            break;
        case kPowerUpSlowMotion:
        {
            if (!activePowerUpSlowMotion)
            {
                for (int i = 0 ; i < [arrIndicators count] ; i ++)
                {
                    if ([[arrIndicators objectAtIndex:i] isKindOfClass:[NSNull class]])
                    {
                        [arrIndicators replaceObjectAtIndex:i withObject:indicatorSlowMotion];
                        break;
                    }
                }
            }
            theGame.enemyManager.bonusEnemiesVelocity = 0.5;
            activePowerUpSlowMotion = YES;
            timePowerUpSlowMotion += 50;
            [indicatorSlowMotion setTotalTime:50];
        }
            break;
        case kPowerUpFreezeEnemies:
        {
            if (!activePowerUpFreezeEnemies)
            {
                for (int i = 0 ; i < [arrIndicators count] ; i ++)
                {
                    if ([[arrIndicators objectAtIndex:i] isKindOfClass:[NSNull class]])
                    {
                        [arrIndicators replaceObjectAtIndex:i withObject:indicatorFreezeEnemies];
                        break;
                    }
                }
            }
            //1 = no freeze. 0 = freeze.
            theGame.enemyManager.bonusEnemiesFreeze = 0;            
            activePowerUpFreezeEnemies = YES;
            timePowerUpFreezeEnemies += 50;
            [indicatorFreezeEnemies setTotalTime:50];
        }
            break;
        case kPowerUpDoubleExperience:
        {
            if (!activePowerUpDoubleExperience)
            {
                for (int i = 0 ; i < [arrIndicators count] ; i ++)
                {
                    if ([[arrIndicators objectAtIndex:i] isKindOfClass:[NSNull class]])
                    {
                        [arrIndicators replaceObjectAtIndex:i withObject:indicatorDoubleExperience];
                        break;
                    }
                }
            }
            activePowerUpDoubleExperience = YES;
            timePowerUpDoubleExperience += 50;
            [indicatorDoubleExperience setTotalTime:50];
        }
            break;
        case kPowerUpShield:
        {
            if (!activePowerUpShield)
            {
                for (int i = 0 ; i < [arrIndicators count] ; i ++)
                {
                    if ([[arrIndicators objectAtIndex:i] isKindOfClass:[NSNull class]])
                    {
                        [arrIndicators replaceObjectAtIndex:i withObject:indicatorShield];
                        break;
                    }
                }
            }
            theGame.character.bonusCharacterShield = 0;
            activePowerUpShield = YES;
            timePowerUpShield += 50;
            [indicatorShield setTotalTime:50];
        }
            break;
            
        default:
            break;
    }
}

-(void)endPowerUp:(kPowerUpType)_type
{
    
}
-(void)createPowerUpIndicators
{
    indicatorDoubleExperience = [[PowerUpIndicator alloc]initWithType:kPowerUpDoubleExperience andGame:theGame];
    indicatorFreezeEnemies = [[PowerUpIndicator alloc]initWithType:kPowerUpFreezeEnemies andGame:theGame];
    indicatorPerforerBullets = [[PowerUpIndicator alloc]initWithType:kPowerUpPerforerBullets andGame:theGame];
    indicatorShield = [[PowerUpIndicator alloc]initWithType:kPowerUpShield andGame:theGame];
    indicatorSlowMotion = [[PowerUpIndicator alloc]initWithType:kPowerUpSlowMotion andGame:theGame];
    indicatorSpeedUp = [[PowerUpIndicator alloc]initWithType:kPowerUpSpeedUp andGame:theGame];
    indicatorWeapon = [[PowerUpIndicator alloc]initWithType:kPowerUpWeapon andGame:theGame];    
}
-(void)timer
{
    
    //WEAPON POWER UP.
    if(timePowerUpWeapon > 0)
    {
        timePowerUpWeapon --;
        [indicatorWeapon setLeftTime:timePowerUpWeapon];
    }else if (activePowerUpWeapon)
    {
        powerUpsActive --;
        activePowerUpWeapon = NO;
            theGame.weaponManager.bonusWeaponPowerUp = 1;
    }        
    
    //SPEED UP POWER UP
    if(timePowerUpSpeedUp > 0)
    {
        timePowerUpSpeedUp --;
        [indicatorSpeedUp setLeftTime:timePowerUpSpeedUp];
    }else if (activePowerUpSpeedUp)
    {
        powerUpsActive --;        
        activePowerUpSpeedUp = NO;
        theGame.character.bonusCharacterSpeed = 1;
    }   
    
    //PERFORER BULLETS POWER UP
    if(timePowerUpPerforerBullets > 0)
    {
        timePowerUpPerforerBullets --;
        [indicatorPerforerBullets setLeftTime:timePowerUpPerforerBullets];
    }else if (activePowerUpPerforerBullets)
    {
        powerUpsActive --;        
        activePowerUpPerforerBullets = NO;
        theGame.weaponManager.bonusBulletCanPerfore = NO;
    }   
    
    //SLOW MOTION POWER UP.
    if(timePowerUpSlowMotion > 0)
    {
        timePowerUpSlowMotion --;
        [indicatorSlowMotion setLeftTime:timePowerUpSlowMotion];
    }else if (activePowerUpSlowMotion)
    {
        powerUpsActive --;        
        activePowerUpSlowMotion = NO;
        theGame.enemyManager.bonusEnemiesVelocity = 1;
    }   
    
    //FREEZE ENEMIES POWER UP
    if(timePowerUpFreezeEnemies > 0)
    {
        timePowerUpFreezeEnemies --;
        [indicatorFreezeEnemies setLeftTime:timePowerUpFreezeEnemies];
    }else if (activePowerUpFreezeEnemies)
    {
        powerUpsActive --;        
        activePowerUpFreezeEnemies = NO;
        theGame.enemyManager.bonusEnemiesFreeze = 1;
    }   
    
    //DOUBLE EXPERIENCE POWER UP.
    if(timePowerUpDoubleExperience > 0)
    {
        timePowerUpDoubleExperience --;
        [indicatorDoubleExperience setLeftTime:timePowerUpDoubleExperience];
    }else if (activePowerUpDoubleExperience)
    {
        powerUpsActive --;        
        activePowerUpDoubleExperience = NO;
        //DEVELOPEMENT
        //See how this'll work. Character should have a bonusDoubleExperience in his class
        //and use it as a xp multiplier. When this power up is off the variable should be 1
        //and when is on variable should be 2.
        [self endPowerUp:kPowerUpDoubleExperience];
    }
    
    //DOUBLE EXPERIENCE POWER UP.
    if(timePowerUpShield > 0)
    {
        timePowerUpShield --;
        [indicatorShield setLeftTime:timePowerUpShield];
    }else if (activePowerUpShield)
    {
        powerUpsActive --;
        activePowerUpShield = NO;
        theGame.character.bonusCharacterShield = 1;
    }
}

@end
