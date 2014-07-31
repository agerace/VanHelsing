//
//  HelloWorldLayer.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 10/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CharacterClass.h"
#import "MainEnemyClass.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "WeaponBulletManager.h"
#import "EnemyManager.h"
#import "PowerUpManager.h"
#import "AppDelegate.h"

@class EnemyManager;
@class CharacterClass;
@class WeaponBulletManager;
@class PowerUpManager;

// GameScene
@interface GameScene : CCLayer
{
    UITouch * leftTouch;
    UITouch * rightTouch;
    
    CCSpriteFrameCache * cache;
    EnemyManager * enemyManager;
    WeaponBulletManager * weaponManager;
    PowerUpManager * powerUpManager;
    CharacterClass * character;
    CGSize screenSize;
    SneakyJoystick * JSMovement;
    SneakyJoystickSkinnedBase * js;    
    SneakyJoystick * JSAiming;
    SneakyJoystickSkinnedBase * js2;
    NSMutableArray * enemiesSpritesArray;
    NSMutableArray * characterInfoArray;
    
    CCNode * bloodSpritesNode;
    
    float aAngle;
    int yPos;
    int xPos;
}
@property (nonatomic,retain)EnemyManager * enemyManager;
@property (nonatomic,retain)WeaponBulletManager * weaponManager;
@property (nonatomic,retain)PowerUpManager * powerUpManager;
@property (nonatomic,retain)NSMutableArray * enemiesSpritesArray;
@property (nonatomic,readonly)CGSize screenSize;
@property (nonatomic,retain)CharacterClass * character;
@property (nonatomic,retain)SneakyJoystick * JSMovement;
@property (nonatomic,retain)SneakyJoystick * JSAiming;
@property (nonatomic,retain)CCNode * bloodSpritesNode;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)doSpritesCache;
//Add joysticks.
-(void)addJoystick;
//Restart Level;
-(void)restartLevel;
//End level when character dies.
-(void)gameOver;

@end
