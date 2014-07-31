//
//  CharacterClass.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
@class GameScene;

@interface CharacterClass : CCNode {
    GameScene * theGame; 

    //Health and velocity of character.
    float characterHealthPoints;
    float characterCurrentHealthPoints;    
    float characterSpeed;
    float characterXp;
    int characterMoney;
    int characterLevel;
    
    //Bonus for healt and velocity
    float bonusCharacterShield;
    float bonusCharacterSpeed;
    float bonusCharacterXp;

    CCSprite * aimPointSprite;  
    CCSprite * characterSpriteTorso;
    //We're going to use this only inside this class, so we won't make it a property.
    CCSprite * characterSpriteLegs;
    
    BOOL isDead;
    float xpToNextLevel;
    int characterProfile;
    
    
    //HP BAR
    CCSprite * hpBackBar;
    CCSprite * hpFrontBar;
    //TEST DEV. Label that show character HP.
    CCLabelTTF * hpLabel;
    //TEST DEV. Label that show character XP.
    CCLabelTTF * xpLabel;
    //TEST DEV. Label that show character Money.
    CCLabelTTF * moneyLabel;
    
}
@property (nonatomic,assign) GameScene * theGame;
@property (nonatomic,readwrite) float characterHealthPoints;
@property (nonatomic,readwrite) float characterCurrentHealthPoints;
@property (nonatomic,readwrite) float characterSpeed;
@property (nonatomic,readwrite) float characterXp;
@property (nonatomic,readwrite) int characterMoney;
@property (nonatomic,readwrite) int characterLevel;
@property (nonatomic,readwrite) float bonusCharacterShield;
@property (nonatomic,readwrite) float bonusCharacterSpeed;
@property (nonatomic,readwrite) float bonusCharacterXp;
@property (nonatomic,retain) CCSprite * characterSpriteTorso;
@property (nonatomic,readonly) BOOL isDead;

-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position;
//Move character and set properly rotation
-(void)moveCharacter:(ccTime)dt;
//Move aim point.
-(void)moveAimPoint;
//Set the legs rotation and make animation.
-(void)setCharacterLegsRotation:(CGPoint)vel;
//Set the torso rotation.
-(void)setCharacterTorsoRotation:(CGPoint)vel;
//Receive damage when hit by enemy.
-(void)receiveDamage:(float)enemyDamage;
//Receive XP.
-(void)receiveExperience:(float)_experience;
//Do shoot blowback movement.
-(void)shootMovement:(int)_angle;


-(void)legsAnimation;
@end
