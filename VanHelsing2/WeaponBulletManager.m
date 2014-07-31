//
//  WeaponBulletManager.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 22/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//VARIABLES
////Time between bullets.
//float timeCadency;
////Time taked to reload.
//float timeReload;
////Bullets per loader.
//int bulletQuantityPerLoader;
////Damage per bullet.
//float bulletDamage;
////Velocity of Bullet.
//float bulletVelocity;
////Quantity of bullets per round.
//int bulletPerRound;

//WEAPONS
//kWeaponPistol,
//kWeaponSubMachineGun,
//kWeaponShotgun,
//kWeaponAutomaticRifle,
//kWeaponJackHamer,
//kWeaponGaussGun,
//kWeaponMiniGun,
//kWeaponGaussShotgun,

#import "WeaponBulletManager.h"
#import "CDAudioManager.h"

@implementation WeaponBulletManager
@synthesize theGame, isShooting, bulletsArray;
@synthesize timeCadency, timeToReload, bulletQuantityPerLoader, bulletDamage, bulletVelocity, bulletPerRound, bulletAngleVariation, bulletCanPerfore;
//Bonus variables synthesize.
@synthesize bonusTimeCadency, bonusTimeToReload, bonusBulletQuantityPerLoader, bulletLeftInLoader, bonusBulletDamage, bonusBulletVelocity, bonusBulletCanPerfore, bonusWeaponPowerUp, currentWeapon;

-(id)initWithTheGame:(GameScene *)_theGame andWeapon:(kCurrentWeapon)_weapon
{
    if (self = [super init])
    {
        //Assign the game.
        theGame = _theGame;
        //Add this node to the game scene.
        [theGame addChild:self];
        //Set that we aren't shooting or reloading.
        isShooting = NO;
        isReloading = NO;
        //Set the current main weapon.
        mainWeapon = _weapon;
        currentWeapon = _weapon;
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:currentWeapon]  forKey:@"NSCharacterCurrentWeapon"];
        //Set the settings for this weapon.
        [self setWeaponSettings];
        //Set the bonuses to disable values
        [self disableAllBonuses];
        //Initiate the bullets array.
        bulletsArray = [[NSMutableArray alloc] initWithCapacity:0];        
        //Schedule the update.
        [self scheduleUpdate];
    }
    
    return self;
}
-(void)activateWeaponPowerUp
{
    if (isShooting) {
        [self unschedule:@selector(shoot)];   
        [self shoot];        
        [self schedule:@selector(shoot) interval:timeCadency/theGame.weaponManager.bonusWeaponPowerUp];        
    }
}
-(void)deActivateWeaponPowerUp
{
    if (isShooting) {
        [self unschedule:@selector(shoot)];   
        [self schedule:@selector(shoot) interval:timeCadency/theGame.weaponManager.bonusWeaponPowerUp];        
    }    
}

-(void)update:(ccTime)dt
{
    //If we are reloading and still the time reloading is less then the time the current gun takes to reload.
    if (isReloading && timeReloading < timeToReload)
    {
//        NSLog( @"RELOADING : %.2f .",timeReloading);
        //Add time to the time timeReloading.
        timeReloading += 0.1;
        if(currentWeapon != mainWeapon)
        {
            [self setMainWeapon];
            timeReloading = timeToReload;
        }
        
    //If we are reloading and the time to reload is done.
    }else if (isReloading)
    {
        
//        NSLog( @"RELOAD DONE.");  
        //Reload the bullets left in loader.
        bulletLeftInLoader = bulletQuantityPerLoader * bonusBulletQuantityPerLoader;
        //Reset the timeReloading variable for the next gun reload.
        timeReloading = 0;
        //Set we aren't reloading.
        isReloading = NO;
    }
    //Save the aiming stick velocity
    CGPoint vel = theGame.JSAiming.velocity;
    //If user is not touching the aiming stick (sticks is in the center, so the X and Y variable are Zero (0).    
    if ( vel.x == 0 && vel.y == 0 )
    {
        //If user is shooting
        
        if (isShooting)
        {
//            NSLog( @"STOP SHOOTING .");            
            
            //Stop shooting by unscheduling the shoot method.            
            [self unschedule:@selector(shoot)];
            //Set user is not shooting.
            isShooting = NO;
        }
        return;
    //If user is touching the aiming stick ( if X or Y of (ccp)velocity aren't Zero (0). 
    }else
    {
        //If weapon is not reloading.
        if(!isReloading)
        {
            //If weapon weren't shooting.
            if (!isShooting)
            {
//                            NSLog( @"START SHOOTING .");  
                //Shoot the first time, since the schedule will wait the interval time, 
                [self shoot];                
                //Start shooting by scheduling the shoot method with an interval that is the cadency of the current weapon.
                [self schedule:@selector(shoot) interval:timeCadency/theGame.weaponManager.bonusWeaponPowerUp];
                //Set user is shooting.
                isShooting = YES;
            }
            
        }
        return;
    }
}

-(void)disableAllBonuses
{
    //Restart all the bonuses.
    bonusBulletCanPerfore = NO;
    bonusBulletDamage = 1;
    bonusBulletQuantityPerLoader = 1;
    bonusBulletVelocity = 1;
    bonusTimeCadency = 1;
    bonusTimeToReload = 1;
    bonusWeaponPowerUp = 1;
}

-(void)setCurrentWeapon:(kCurrentWeapon)_weapon
{
    
    //Set the current weapon.
    currentWeapon = _weapon;
    //Then call the method that especifies all variables for each weapon.
    [self setWeaponSettings];
    if(isShooting)
    {
        [self unschedule:@selector(shoot)];
        //Shoot the first time, since the schedule will wait the interval time, 
        [self shoot];                
        //Start shooting by scheduling the shoot method with an interval that is the cadency of the current weapon.
        [self schedule:@selector(shoot) interval:timeCadency/theGame.weaponManager.bonusWeaponPowerUp];            
    }    
}
-(void)setMainWeapon
{
    //Set the current weapon to the mainWeapon.
    [self setCurrentWeapon:mainWeapon];
    if(isShooting)
    {
        [self unschedule:@selector(shoot)];
        //Shoot the first time, since the schedule will wait the interval time, 
        [self shoot];                
        //Start shooting by scheduling the shoot method with an interval that is the cadency of the current weapon.
        [self schedule:@selector(shoot) interval:timeCadency/theGame.weaponManager.bonusWeaponPowerUp];            
    }
}
-(void)setWeaponSettings
{
    //Check which weapon is selected.
    switch (currentWeapon) {
        case kWeaponPistol:
        {
            //Time betwen shoots.
            timeCadency = 0.55;
            //Time taken to reload.
            timeToReload = 1.2;
            //Bullets per loader.
            bulletQuantityPerLoader = 12;
            //Bullets damage.
            bulletDamage = 12 ;
            //Bullets velocity.
            bulletVelocity = 16;
            //Bullets per shoot. (Shotguns have 5,pistol 1, double canon shotgun 10, etc).
            bulletPerRound = 1;
            //Angle variation. Blowback of gun.
            bulletAngleVariation = 2;
            //Bullets traspases enemies?.
            bulletCanPerfore = NO;
        }
            break;
        case kWeaponSubMachineGun:
        {
            timeCadency = 0.15;
            timeToReload = 3;
            bulletQuantityPerLoader = 30;
            bulletDamage = 8;
            bulletVelocity = 20;
            bulletPerRound = 1;
            bulletAngleVariation = 3;
            bulletCanPerfore = NO;
        }
            break;            
        case kWeaponShotgun:
        {
            timeCadency = 1;
            timeToReload = 2;
            bulletQuantityPerLoader = 6  ;
            bulletDamage = 7;
            bulletVelocity = 25;
            bulletPerRound = 5;
            bulletAngleVariation = 2.5;
            bulletCanPerfore = NO;
        }
            break;     
        case kWeaponAutomaticRifle:
        {
            timeCadency = 0.25;
            timeToReload = 1.8;
            bulletQuantityPerLoader = 35;
            bulletDamage = 7;
            bulletVelocity = 15;
            bulletPerRound = 1;
            bulletAngleVariation = 4;            
            bulletCanPerfore = NO;
        }
            break;  
        case kWeaponJackHamer:
        {
            timeCadency = 0.2;
            timeToReload = 15;
            bulletQuantityPerLoader = 14;
            bulletDamage = 6.5;
            bulletVelocity = 14;
            bulletPerRound = 5;
            bulletAngleVariation = 3;
            bulletCanPerfore = NO;
        }
            break;  
        case kWeaponGaussGun:
        {
            timeCadency = 1;
            timeToReload = 1.5;
            bulletQuantityPerLoader = 5;
            bulletDamage = 9;
            bulletVelocity = 25;
            bulletPerRound = 1;
            bulletAngleVariation = 0;            
            bulletCanPerfore = YES;
        }
            break;  
        case kWeaponMiniGun:
        {
            
            timeCadency = 0.05;
            timeToReload = 20;
            bulletQuantityPerLoader = 100;
            bulletDamage = 8;
            bulletVelocity = 25;
            bulletPerRound = 1;
            bulletAngleVariation = 4;            
            bulletCanPerfore = NO;
        }
            break;  
        case kWeaponGaussShotgun:
        {
            timeCadency = 1;
            timeToReload = 3.5;
            bulletQuantityPerLoader = 5;
            bulletDamage = 9;
            bulletVelocity = 55;
            bulletPerRound = 5;
            bulletAngleVariation = 2;            
            bulletCanPerfore = YES;
        }
            break;
        case kWeaponPlasmaRifle:
        {
            timeCadency = 0.4;
            timeToReload = 8;
            bulletQuantityPerLoader = 15;
            bulletDamage = 20;
            bulletVelocity = 12;
            bulletPerRound = 1;
            bulletAngleVariation = 4;
            bulletCanPerfore = NO;
        }
            break;
        case kWeaponPlasmaShotgun:
        {
            timeCadency = 0.8;
            timeToReload = 14;
            bulletQuantityPerLoader = 8;
            bulletDamage = 13;
            bulletVelocity = 16;
            bulletPerRound = 10;
            bulletAngleVariation = 2;
            bulletCanPerfore = NO;
        }
            break;
        case kWeaponIonRifle:
        {
            timeCadency = 0.25;
            timeToReload = 6;
            bulletQuantityPerLoader = 10;
            bulletDamage = 13;
            bulletVelocity = 12;
            bulletPerRound = 1;
            bulletAngleVariation = 4;
            bulletCanPerfore = NO;
        }
            break;
        case kWeaponIonShotgun:
        {
            timeCadency = 0.6;
            timeToReload = 10;
            bulletQuantityPerLoader = 8;
            bulletDamage = 9;
            bulletVelocity = 20;
            bulletPerRound = 5;
            bulletAngleVariation = 2;
            bulletCanPerfore = NO;
        }
            break;
        case kWeaponMisilLauncher:
        {
            timeCadency = 2;
            timeToReload = 15;
            bulletQuantityPerLoader = 5;
            bulletDamage = 80;
            bulletVelocity = 25;
            bulletPerRound = 1;
            bulletAngleVariation = 4;
            bulletCanPerfore = NO;
        }
            break;
        case kWeaponGranadeLauncher:
        {
            timeCadency = 1.5;
            timeToReload = 4;
            bulletQuantityPerLoader = 3;
            bulletDamage = 50;
            bulletVelocity = 12;
            bulletPerRound = 1;
            bulletAngleVariation = 10;
            bulletCanPerfore = NO;
        }
            break;
        case kWeaponMineLauncher:
        {
            timeCadency = 3;
            timeToReload = 6;
            bulletQuantityPerLoader = 6;
            bulletDamage = 40;
            bulletVelocity = 12;
            bulletPerRound = 1;
            bulletAngleVariation = 4;
            bulletCanPerfore = NO;
        }
            break;
        case kWeaponFlameThrower:
        {
            timeCadency = 0.05;
            timeToReload = 6;
            bulletQuantityPerLoader = 50;
            bulletDamage = 10;
            bulletVelocity = 12;
            bulletPerRound = 1;
            bulletAngleVariation = 1;
            bulletCanPerfore = NO;
        }
            break;
        default:
            break;
    }

    //Set the bullets weapon have in loader.
    bulletLeftInLoader = bulletQuantityPerLoader;
}

-(void)shoot
{
//    NSLog( @"SHOOT. Bullets left : %d.",bulletLeftInLoader);    
    //Values from the Aiming Stick
    CGPoint initialVel = theGame.JSAiming.velocity;
    //With this values we can know the angle of the shoot.
    int angle = CC_RADIANS_TO_DEGREES(atan2(initialVel.y, initialVel.x));   

    //If weapon have angle variation.
    if ( bulletAngleVariation != 0){
        // 50-50 chances of blowback is positive.
        if (arc4random()%10 < 5)
        {
            //Random number taking care about the blowback variable.            
            angle = angle + (arc4random()%bulletAngleVariation);
            //Or negative.
        }else
        {
            angle = angle - (arc4random()%bulletAngleVariation);                
        }    
        
    }
    
    //If weapon loader is empty.
    if (bulletLeftInLoader == 0)
    {
//        NSLog( @"START RELOAD.");
        if (!isReloading)
            [[CDAudioManager sharedManager].soundEngine playSound:1001 sourceGroupId:2 pitch:1 pan:1 gain:1 loop:NO];
        //Start the reload.
        isReloading = YES;

    
    //If weapon loader have bullets.
    }else
    {
        //Make shoot blowback on character.
        [theGame.character shootMovement:angle];
//        NSLog( @"SHOOT. Bullets left : %d.",bulletLeftInLoader);
        //If bullets per shoot is 1.
        if ( bulletPerRound == 1 )
        {  

            //Create one bullet only. The BulletMainClass is in charge of add the bullet sprite to the game,  set the velocity and angle of the sprite, and also move it and check if the bullet hit an enemy or go out of screen.            
            BulletMainClass * bullet = [[BulletMainClass alloc]initWithTheGame:theGame andAngle:angle andType:nil andEnemy:nil];
            //Add the bullet object to the bullets array just in case we have to make something with her.
            [bulletsArray addObject:bullet];        

        //If bullets per shoot is more than 1.
        }else
        {
            //Create all the bullets with this for bucle.
            for ( int i = 0 ; i < bulletPerRound ; i++ )
            {
                //Change the angle of each bullet so they will go in different angles.
                //DEVELOPEMENT May we should to this sorta of random angle ( like +- 2 or 3 degrees ) besides this modification.
                if (arc4random()%10 < 5)
                    angle += (i+bulletAngleVariation) *( (arc4random()%bulletAngleVariation)+1);
                else
                    angle -= (i+bulletAngleVariation) * ( (arc4random()%bulletAngleVariation)+1);                
                
                //Create Bullet.
                BulletMainClass * bullet = [[BulletMainClass alloc]initWithTheGame:theGame andAngle:angle andType:nil andEnemy:nil ];
                //Add bullet to bullets array.
                [bulletsArray addObject:bullet];
                
            }
        }
    [[CDAudioManager sharedManager].soundEngine playSound:1002 sourceGroupId:2 pitch:1 pan:1 gain:1 loop:NO];
//    [[CDAudioManager sharedManager].soundEngine playSound:1001 sourceGroupId:1 pitch:1 pan:1 gain:1 loop:NO];
        //Decrease in one the bullets left in loader.
        bulletLeftInLoader --;
    }
    
}

@end
