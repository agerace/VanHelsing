//
//  PowerUpMain.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 30/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@interface PowerUpMain : CCNode {
    GameScene * theGame;
    kPowerUpType powerUpType;
    kCurrentWeapon weaponType;
    CCSprite * powerUpSprite;
    CGPoint position;
}
@property (nonatomic,assign)GameScene * theGame;
//Power up droped.
-(id)initWithTheGame:(GameScene *)_theGame andPosition:(CGPoint)_position andType:(kPowerUpType)_type;
//Weapon droped.
-(id)initWithTheGame:(GameScene *)_theGame andPosition:(CGPoint)_position andWeapon:(kCurrentWeapon)_type;
//Check what power up is touch and activate it.
-(void)activatePowerUp;
-(void)powerUpNukeBomb;
-(void)erasePowerUp;
@end
