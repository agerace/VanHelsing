//
//  BulletMainClass.m
//  VanHelsing2
//
//  Created by César Andrés Gerace on 11/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "BulletMainClass.h"


@implementation BulletMainClass
@synthesize theGame , weaponManager;
-(id)initWithTheGame:(GameScene*)_theGame andAngle:(int)_angle andType:(kBulletType)_type andEnemy:(MainEnemyClass *)_enemy
{
    if ( self = [super init])
    {
        //Save the angle.
        angle  = _angle;
        //Assign the game.
        theGame = _theGame;
        //Assign the weapon manager
        weaponManager = theGame.weaponManager;
        //Add this node to the game scene.
        [theGame addChild:self];
        
        if(!_type)
            //Set the bullet type.
            [self setBulletType];
        else
            bulletType = _type;


        
        //Save the screen rect.
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        screenRect = CGRectMake(-30, -30, screenSize.width + 60 , screenSize.height + 60) ;
        //Create the bullet sprite and add it to the game scene.
        NSString * bulletName = [NSString stringWithFormat:@"bullet%d.png",bulletType];

        bulletSprite = [CCSprite spriteWithSpriteFrameName:bulletName];
        [bulletSprite setPosition:theGame.character.characterSpriteTorso.position];
        
        //If bullet is from enemy
        if (_enemy)
        {
            ownerEnemy = _enemy;
            [bulletSprite setPosition:ownerEnemy.enemySprite.position];
        }

        
        endPos = bulletSprite.position;
        initPos = bulletSprite.position;
        bulletOpacity = 1.0;
        
        if(bulletType == kBulletFlame)
           [bulletSprite setScale:0.05];
        
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
    
    if ( bulletType == kBulletEnemy || bulletType == kBulletEnemyPlasma )
    {
        bulletDamage = 10;
        bulletVelocity = 12;
    }
    
    //Set the rotation.
    [bulletSprite setRotation:(angle*-1)];
    
    //Set the velocity in ccp format.
    finalVelocity = [self getCCPVelocityForVelocity:bulletVelocity];
}
-(void)setBulletType
{
    kCurrentWeapon currentWeapon = theGame.weaponManager.currentWeapon;
    
    if ( currentWeapon == kWeaponAutomaticRifle || currentWeapon == kWeaponSubMachineGun ||
        currentWeapon == kWeaponShotgun || currentWeapon == kWeaponJackHamer ||
        currentWeapon == kWeaponPistol || currentWeapon == kWeaponMiniGun )
        bulletType = kBulletNormal;
    else if (currentWeapon == kWeaponPlasmaRifle || currentWeapon == kWeaponPlasmaShotgun )
        bulletType = kBulletPlasma;
    else if ( currentWeapon == kWeaponGaussGun || currentWeapon == kWeaponGaussShotgun )
        bulletType = kBulletGauss;
    else if ( currentWeapon == kWeaponIonRifle || currentWeapon == kWeaponIonShotgun )
        bulletType = kBulletIon;
    else if ( currentWeapon == kWeaponMisilLauncher )
        bulletType = kBulletMisil;
    else if ( currentWeapon == kWeaponMineLauncher )
        bulletType = kBulletMine;
    else if ( currentWeapon == kWeaponFlameThrower )
    {
        bulletType = kBulletFlame;
    }
    else if ( currentWeapon == kWeaponGranadeLauncher )
        bulletType = kBulletGranade;
    else if ( currentWeapon == kWeaponLaserBeam )
        bulletType = kBulletLaser;
}
-(CGPoint)getCCPVelocityForVelocity:(float)_velocity
{
    CGPoint velocity;
    
    //Set the velocity in ccp format.
    float velX = (sin(CC_DEGREES_TO_RADIANS(angle))*_velocity);
    float velY = (cos(CC_DEGREES_TO_RADIANS(angle))*_velocity);
    velocity = CGPointMake(velY, velX);
    
    return velocity;
}
//GENERAL UPDATE
-(void)update:(ccTime)dt
{
  
    
    switch (bulletType) {
        case kBulletNormal:
            [self schedule:@selector(updateNormal) interval:dt];
            break;
        case kBulletGauss:
            [self schedule:@selector(updateGauss) interval:dt];
            break;
        case kBulletPlasma:
            [self schedule:@selector(updatePlasma) interval:dt];
            break;
        case kBulletIon:
            [self schedule:@selector(updateIon) interval:dt];            
            break;
        case kBulletMisil:
            [self schedule:@selector(updateMisil) interval:dt];            
            break;
        case kBulletGranade:
            [self schedule:@selector(updateGranade) interval:dt];            
            break;
        case kBulletMine:
            [self schedule:@selector(updateMine) interval:dt];            
            break;
        case kBulletFlame:
        {
            [self schedule:@selector(updateFlame) interval:dt];
        }
            break;
        case kBulletLaser:
            [self schedule:@selector(updateLaser) interval:dt];            
            break;
        case kBulletEnemyPlasma:
            [self schedule:@selector(updateEnemyPlasma) interval:dt];
            break;
        default:
            break;
    }
    [self unscheduleUpdate];
}
-(void) draw
{
    //ENABLE ALPHA.
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    [super draw];
    //the color of the line
    ccDrawColor4F(1.0, 1.0, 1.0, bulletOpacity);
   
    //the width of the line
    glLineWidth(bulletOpacity);
    ccDrawLine(initPos, endPos);
    
}
-(void)downopacity
{
    if( bulletOpacity <= 0)
    {
        //Remove this node from the bullets array.
        [theGame.weaponManager.bulletsArray removeObject:self];
        //Remove this node from the game.
        [theGame removeChild:self cleanup:YES];
    }

    else
        bulletOpacity -= 0.2;
    
}
-(void)updateEnemyPlasma
{
    if (!bulletSprite)
    {
        [self unschedule:@selector(updateEnemyPlasma)];
        [self removeBullet];
    }else{
        //Check if the bullet is inside the screen.
        if (CGRectIntersectsRect(bulletSprite.boundingBox, screenRect)) {
            
            //Get the bullet next position, adding the velocity to the position, and then setting it.
            CGPoint pos = ccp (bulletSprite.position.x + finalVelocity.x,
                               bulletSprite.position.y + finalVelocity.y );
            [bulletSprite setPosition:pos];
            
            //Check character hit.
            if (CGRectIntersectsRect(bulletSprite.boundingBox, [theGame.character.characterSpriteTorso boundingBox]))
            {
                [self unschedule:@selector(updateEnemyPlasma)];
                [theGame.character receiveDamage:bulletDamage];
                [self removeBullet];
                return;
            }
            
            //Bucle to check if bullet hit an enemy.
            for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
            {
                //Check if bullet bounds intersects enemy bounds.
                if (CGRectIntersectsRect(bulletSprite.boundingBox, enemy.enemySprite.boundingBox))
                {
                    //If enemy hited isn't the owner of bullet do nothing
                    if(enemy != ownerEnemy)
                    {
                        //Unschedule this update.
                        [self unschedule:@selector(updateEnemyPlasma)];
                        //Kill enemy.
                        [enemy receiveShootWithDamage:bulletDamage];
                        //Remove bullet.
                        [self removeBullet];
                    }
                    return;
                }
            }
            //If bullet is out of screen then remove it.
        }else
        {
            //Unschedule this update.
            [self unschedule:@selector(updateEnemyPlasma)];
            //Call the remove method
            [self removeBullet];
        }        
    }

}
-(void)updateNormal
{

    //Check if the bullet is inside the screen.
    if (CGRectIntersectsRect(bulletSprite.boundingBox, screenRect)) {
        
        //Get the bullet next position, adding the velocity to the position, and then setting it.
        CGPoint pos = ccp (bulletSprite.position.x + finalVelocity.x,
                           bulletSprite.position.y + finalVelocity.y );
        [bulletSprite setPosition:pos];

        endPos = bulletSprite.position;          
        
        //Bucle to check if bullet hit an enemy.
        for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
        {
            //Check if bullet bounds intersects enemy bounds.
            if (CGRectIntersectsRect(bulletSprite.boundingBox, enemy.enemySprite.boundingBox))
            {
                //Make the enemy bleed.
                [enemy bleedEnemyFromAngle:angle];
                //Send damage to the enemy.
                [enemy receiveShootWithDamage:bulletDamage];
                //If the bullet can't perfore remove it.
                if (!bulletCanPerfore)
                {
                    
                    //Remove bullet.
//                    [self schedule:@selector(removeBullet) interval:0.1];
                    [self unschedule:@selector(updateNormal)];
                    [self schedule:@selector(downopacity) interval:0.1];
                    [self removeBullet];
                    break;
                }
            }
        }
        //If bullet is out of screen then remove it.
    }else
    {
        //Remove bullet.
//        [self schedule:@selector(removeBullet) interval:0.1];
            [self schedule:@selector(downopacity) interval:0.1];
            [self removeBullet];
        [self unschedule:@selector(updateNormal)];        
    }
}
-(void)updateGauss
{
    //Check if the bullet is inside the screen.
    if (CGRectIntersectsRect(bulletSprite.boundingBox, screenRect)) {
        
        //Get the bullet next position, adding the velocity to the position, and then setting it.
        CGPoint pos = ccp (bulletSprite.position.x + finalVelocity.x,
                           bulletSprite.position.y + finalVelocity.y );
        [bulletSprite setPosition:pos];
        
        //Bucle to check if bullet hit an enemy.
        for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
        {
            //Check if bullet bounds intersects enemy bounds.
            if (CGRectIntersectsRect(bulletSprite.boundingBox, enemy.enemySprite.boundingBox))
            {
                //Make the enemy bleed.
                [enemy bleedEnemyFromAngle:angle];
                //Send damage to the enemy.
                [enemy receiveShootWithDamage:bulletDamage];
            }
        }
        //If bullet is out of screen then remove it.
    }else
    {
        //Call the remove method
        [self removeBullet];
    }
}
-(void)updatePlasma
{
    //Check if the bullet is inside the screen.
    if (CGRectIntersectsRect(bulletSprite.boundingBox, screenRect)) {
        
        //Get the bullet next position, adding the velocity to the position, and then setting it.
        CGPoint pos = ccp (bulletSprite.position.x + finalVelocity.x,
                           bulletSprite.position.y + finalVelocity.y );
        [bulletSprite setPosition:pos];
        
        //Bucle to check if bullet hit an enemy.
        for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
        {
            //Check if bullet bounds intersects enemy bounds.
            if (CGRectIntersectsRect(bulletSprite.boundingBox, enemy.enemySprite.boundingBox))
            {
                //Make the enemy bleed.
                [enemy bleedEnemyFromAngle:angle];
                //Send damage to the enemy.
                [enemy receiveShootWithDamage:bulletDamage];
                //If the bullet can't perfore remove it.
                if (!bulletCanPerfore)
                {
                    //Remove bullet.
                    [self removeBullet];
                    break;
                }
            }
        }
        //If bullet is out of screen then remove it.
    }else
    {
        //Call the remove method
        [self removeBullet];
    }
}
-(void)updateIon
{
    //Check if the bullet is inside the screen.
    if (CGRectIntersectsRect(bulletSprite.boundingBox, screenRect)) {
        
        //Get the bullet next position, adding the velocity to the position, and then setting it.
        CGPoint pos = ccp (bulletSprite.position.x + finalVelocity.x,
                           bulletSprite.position.y + finalVelocity.y );
        [bulletSprite setPosition:pos];
        
        //Bucle to check if bullet hit an enemy.
        for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
        {
            //Check if bullet bounds intersects enemy bounds.
            if (CGRectIntersectsRect(bulletSprite.boundingBox, enemy.enemySprite.boundingBox))
            {
                //Make the enemy bleed.
                [enemy bleedEnemyFromAngle:angle];
                //Send damage to the enemy.
                [enemy receiveShootWithDamage:bulletDamage];
                //If the bullet can't perfore remove it.
                [self removeBullet];
                //Area damage radius
                int areaDamageRadius = 20;
                //Rect for the secondary damage area.
                CGRect rectAreaDamage = CGRectMake(enemy.enemySprite.position.x - areaDamageRadius,
                                                   enemy.enemySprite.position.y - areaDamageRadius,
                                                   areaDamageRadius*2,
                                                   areaDamageRadius*2);
                
                //Bucle to check if an enemy is near, then damage him too.
                for (MainEnemyClass * _enemy in theGame.enemyManager.enemiesArray)
                {
                    //If the checking enemy is the hited enemy then do nothing.
                    if ( _enemy == enemy )
                        return;
                    //If not, and the enemy is in the damage area, then make damage. In this case Damage / 2
                    //DEV we may should check this damage for final version
                    else if ( CGRectIntersectsRect(rectAreaDamage, _enemy.enemySprite.boundingBox))
                    {
                        //Make the enemy bleed.
                        [_enemy bleedEnemyFromAngle:angle];
                        //Send damage to the enemy.
                        [_enemy receiveShootWithDamage:bulletDamage/2];
                        break;                        
                    }
                }
            }
        }
        //If bullet is out of screen then remove it.
    }else
    {
        //Call the remove method
        [self removeBullet];
    }
}
-(void)updateMisil
{
    //Check if the bullet is inside the screen.
    if (CGRectIntersectsRect(bulletSprite.boundingBox, screenRect)) {
        
        //Get the bullet next position, adding the velocity to the position, and then setting it.
        CGPoint pos = ccp (bulletSprite.position.x + finalVelocity.x,
                           bulletSprite.position.y + finalVelocity.y );
        [bulletSprite setPosition:pos];
        
        //Bucle to check if bullet hit an enemy.
        for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
        {
            //Check if bullet bounds intersects enemy bounds.
            if (CGRectIntersectsRect(bulletSprite.boundingBox, enemy.enemySprite.boundingBox))
            {
                //Make the enemy bleed.
                [enemy bleedEnemyFromAngle:angle];
                //Send damage to the enemy.
                [enemy receiveShootWithDamage:bulletDamage];
                
                //Do misil explosion.
                [self misilExplosion];
                
                //Area damage radius
                int areaDamageRadius = 40;
                //Rect for the secondary damage area.
                CGRect rectAreaDamage = CGRectMake(enemy.enemySprite.position.x - areaDamageRadius,
                                                   enemy.enemySprite.position.y - areaDamageRadius,
                                                   areaDamageRadius*2,
                                                   areaDamageRadius*2);
                
                //Bucle to check if an enemy is near, then damage him too.
                for (MainEnemyClass * _enemy in theGame.enemyManager.enemiesArray)
                {
                    //If the checking enemy is the hited enemy then do nothing.
                    if ( _enemy == enemy )
                        return;
                    //If not, and the enemy is in the damage area, then make damage. In this case Damage / 2
                    //DEV we may should check this damage for final version
                    else if ( CGRectIntersectsRect(rectAreaDamage, _enemy.enemySprite.boundingBox))
                    {
                        //Make the enemy bleed.
                        [_enemy bleedEnemyFromAngle:angle];
                        //Send damage to the enemy.
                        [_enemy receiveShootWithDamage:(bulletDamage/1.25)];
                    }
                }
            }
        }
        //If bullet is out of screen then remove it.
    }else
    {
        //Call the remove method
        [self removeBullet];
    }
}


-(void)misilExplosion
{
    [self unschedule:@selector(updateMisil)];    
    
    bulletAuxSprite = [CCSprite spriteWithSpriteFrameName:@"bullet8.png"];
    [bulletAuxSprite setScale:0.1];
    [bulletAuxSprite setPosition:bulletSprite.position];
    [theGame addChild:bulletAuxSprite z:350];
    
    [theGame removeChild:bulletSprite cleanup:YES];    
    
    [bulletAuxSprite runAction:[CCSequence actions:
                                [CCScaleTo actionWithDuration:0.15 scale:6.0],
                                [CCSpawn actions:
                                 [CCFadeOut actionWithDuration:0.15],
                                 [CCScaleTo actionWithDuration:0.15 scale:0.1],
                                 nil],
                                [CCCallFunc actionWithTarget:self selector:@selector(removeBullet)],
                                nil ]];
    
    
}

-(void)updateGranade
{
    //Check if the bullet is inside the screen.
    if (CGRectIntersectsRect(bulletSprite.boundingBox, screenRect)) {
        //Move the granade slower until it gets to vel 0.
        if(bulletVelocity > 0)
        {
            //Get the bullet next position, adding the velocity to the position, and then setting it.
            CGPoint pos = ccp (bulletSprite.position.x + finalVelocity.x,
                               bulletSprite.position.y + finalVelocity.y );
            [bulletSprite setPosition:pos];
            //slow the velocity.
            bulletVelocity -= 0.5 ;
            //calculate the velocity ccp for the new vel.
            finalVelocity = [self getCCPVelocityForVelocity:bulletVelocity];
            
            
            //Bucle to check if bullet hit an enemy.
            for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
            {
                //Check if bullet bounds intersects enemy bounds.
                if (CGRectIntersectsRect(bulletSprite.boundingBox, enemy.enemySprite.boundingBox))
                {
                    //Make the enemy bleed.
                    [enemy bleedEnemyFromAngle:angle];
                    //Send damage to the enemy.
                    [enemy receiveShootWithDamage:bulletDamage];
                    //If the bullet can't perfore remove it.
                    [self removeBullet];
                    //Area damage radius
                    int areaDamageRadius = 20;
                    //Rect for the secondary damage area.
                    CGRect rectAreaDamage = CGRectMake(enemy.enemySprite.position.x - areaDamageRadius,
                                                       enemy.enemySprite.position.y - areaDamageRadius,
                                                       areaDamageRadius*2,
                                                       areaDamageRadius*2);
                    
                    //Bucle to check if an enemy is near, then damage him too.
                    for (MainEnemyClass * _enemy in theGame.enemyManager.enemiesArray)
                    {
                        //If the checking enemy is the hited enemy then do nothing.
                        if ( _enemy == enemy )
                            return;
                        //If not, and the enemy is in the damage area, then make damage. In this case Damage / 2
                        //DEV we may should check this damage for final version
                        else if ( CGRectIntersectsRect(rectAreaDamage, _enemy.enemySprite.boundingBox))
                        {
                            //Make the enemy bleed.
                            [_enemy bleedEnemyFromAngle:angle];
                            //Send damage to the enemy.
                            [_enemy receiveShootWithDamage:bulletDamage/2];
                        }
                    }
                    break;
                }
            }
            
            //When the velocity reachs zero.
        }else
        {

            [self runAction:[CCSequence
            //Wait 3 seconds
                             actionOne:[CCDelayTime actionWithDuration:3]
            //Then explode the granade making area damage only.
                             two:[CCCallBlock actionWithBlock:^(void)
                                  {
                                      [self pauseSchedulerAndActions];
                                      
                                      //Area damage radius
                                      int areaDamageRadius = 20;
                                      //Rect for the secondary damage area.
                                      CGRect rectAreaDamage = CGRectMake(bulletSprite.position.x - areaDamageRadius,
                                                                         bulletSprite.position.y - areaDamageRadius,
                                                                         areaDamageRadius*2,
                                                                         areaDamageRadius*2);
                                      //Bucle to check if an enemy is near, then damage him too.
                                      for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
                                      {
                                          
                                          //If the enemy is in the damage area, then make damage. In this case Damage / 2
                                          //DEV we may should check this damage for final version
                                          if ( CGRectIntersectsRect(rectAreaDamage, enemy.enemySprite.boundingBox))
                                          {
                                              //Make the enemy bleed.
                                              [enemy bleedEnemyFromAngle:angle];
                                              //Send damage to the enemy.
                                              [enemy receiveShootWithDamage:bulletDamage/2];
                                          }
                                      }
                                      [self removeBullet];                                      
                                  }
                                  ]]];
        }
              //If bullet is out of screen then remove it.
    }else
    {
        //Call the remove method
        [self removeBullet];
    }
}
-(void)updateMine
{
    //Check if the bullet is inside the screen.
    if (CGRectIntersectsRect(bulletSprite.boundingBox, screenRect)) {
        //Move the mine slower until it gets to vel 0.
        if(bulletVelocity > 0)
        {
            //Get the bullet next position, adding the velocity to the position, and then setting it.
            CGPoint pos = ccp (bulletSprite.position.x + finalVelocity.x,
                               bulletSprite.position.y + finalVelocity.y );
            [bulletSprite setPosition:pos];
            //slow the velocity.
            bulletVelocity -= 0.5 ;
            //calculate the velocity ccp for the new vel.
            finalVelocity = [self getCCPVelocityForVelocity:bulletVelocity];
        }
        
        
        //Doing this, the mine will move to a X position, and if it hit to an enemy in the way
        //It will explode. When the mine lands it'll remind ther until a enemy touches it then explode.
        
        
        
        //Bucle to check if bullet hit an enemy.
        for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
        {
            //Check if bullet bounds intersects enemy bounds.
            if (CGRectIntersectsRect(bulletSprite.boundingBox, enemy.enemySprite.boundingBox))
            {
                //Make the enemy bleed.
                [enemy bleedEnemyFromAngle:angle];
                //Send damage to the enemy.
                [enemy receiveShootWithDamage:bulletDamage];
                //If the bullet can't perfore remove it.
                [self removeBullet];
                //Area damage radius
                int areaDamageRadius = 20;
                //Rect for the secondary damage area.
                CGRect rectAreaDamage = CGRectMake(enemy.enemySprite.position.x - areaDamageRadius,
                                                   enemy.enemySprite.position.y - areaDamageRadius,
                                                   areaDamageRadius*2,
                                                   areaDamageRadius*2);
                
                //Bucle to check if an enemy is near, then damage him too.
                for (MainEnemyClass * _enemy in theGame.enemyManager.enemiesArray)
                {
                    //If the checking enemy is the hited enemy then do nothing.
                    if ( _enemy == enemy )
                        return;
                    //If not, and the enemy is in the damage area, then make damage. In this case Damage / 2
                    //DEV we may should check this damage for final version
                    else if ( CGRectIntersectsRect(rectAreaDamage, _enemy.enemySprite.boundingBox))
                    {
                        //Make the enemy bleed.
                        [_enemy bleedEnemyFromAngle:angle];
                        //Send damage to the enemy.
                        [_enemy receiveShootWithDamage:bulletDamage/2];
                    }
                }
            }
        }
        //If bullet is out of screen then remove it.
    }else
    {
        //Call the remove method
        [self removeBullet];
    }
}
-(void)updateFlame
{

    if (bulletSprite.opacity < 10)
    {
        [self unschedule:@selector(updateFlame)];
        [self removeBullet];
    }else
    {
        
        //Get the bullet next position, adding the velocity to the position, and then setting it.
        CGPoint pos = ccp (bulletSprite.position.x + finalVelocity.x,
                           bulletSprite.position.y + finalVelocity.y );
        [bulletSprite setPosition:pos];
        
        //Grow the fire sprite to make fire effect.
        if ( bulletSprite.scale < 1)
        {
            bulletSprite.scale += 0.25;
        }else
        {
            bulletSprite.opacity -= 25;
        }
        //Get the real rect of the fire depending on his scale.
        CGRect fireRealRect = CGRectMake(bulletSprite.position.x - (int)(bulletSprite.contentSize.width * bulletSprite.scale),
                                         bulletSprite.position.y - (int)(bulletSprite.contentSize.height * bulletSprite.scale),
                                         (int)(bulletSprite.contentSize.width * bulletSprite.scale) * 2,
                                         (int)(bulletSprite.contentSize.height * bulletSprite.scale) * 2);
        
        //Bucle to check if bullet hit an enemy.
        for (MainEnemyClass * enemy in theGame.enemyManager.enemiesArray)
        {
            //Check if bullet bounds intersects enemy bounds.
            if (CGRectIntersectsRect(fireRealRect, enemy.enemySprite.boundingBox))
            {
                //Make the enemy bleed.
                [enemy bleedEnemyFromAngle:angle];
                //Send damage to the enemy.
                [enemy receiveShootWithDamage:bulletDamage * bulletSprite.scale * (bulletSprite.opacity / 255)];
                
            }
        }
        
    }

    
}
-(void)updateLaser
{
}

-(void)removeBullet
{
    //Remove the bullet sprite from the game.
    if (bulletSprite)
        [theGame removeChild:bulletSprite cleanup:YES];
    
    //Remove the aux bullet sprite from the game.
    if(bulletAuxSprite)
        [theGame removeChild:bulletAuxSprite cleanup:YES];
    
    //If bullet is not normal type remove it now.
    if (bulletType != kBulletNormal) {
            [theGame removeChild:self cleanup:YES];	
    }

}
@end
