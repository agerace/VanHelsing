//
//  MainEnemyClass.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 10/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

@class GameScene;
#import "GameScene.h"

typedef enum kEnemyXp
{
    kEnemyXpSpider = 40,
    kEnemyXpZombie = 50,
    kEnemyXpVampire = 75,
    kEnemyXpPredator = 65,
    //BOSSES
    kEnemyXpBossZombie = 100,
    kEnemyXpBossSpider = 100,
    //SPAWN POSITIONS
    kEnemyXpSpawnPointZombie = 150,
    //BABIES
    kEnemyXpBabySpider = 5,
    kEnemyXpBabyZombie = 7,
}kEnemyXp;

@interface MainEnemyClass : CCNode {
    GameScene * theGame;  
    
    float enemyHealthPoints;
    float enemySpeed;
    float enemyDamage;
    
    int enemyType;
    
    float timeBetweenHits;
    float enemyTimeBetweenHits;
    
    BOOL isDead;
    
    CCSprite * enemySprite;
}
@property (nonatomic,assign) GameScene * theGame;
@property (nonatomic,retain) CCSprite * enemySprite;
@property (nonatomic,readwrite) float enemyHealthPoints;
@property (nonatomic,readwrite) float enemySpeed;
@property (nonatomic,readwrite) float enemyDamage;
@property (nonatomic,readonly) int enemyType;

////Receive the game, the position in CGPOINT and the info in a dictionary.
//-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position andInfo:(NSMutableDictionary * )_enemyInfo;
//Check if the enemy hits the character.
-(void)checkHitCharacter;
//Remove the enemy from the game.
-(void)removeEnemy;
//Kill the enemy.
-(void)killEnemy;
////Calculate angle and move the enemy to the character.
//-(void)moveEnemy;
//Drop power up and weapon when die.
-(void)dropAtKill;
//Receive the shoot.
-(void)receiveShootWithDamage:(float)bulletDamage;
//Do Bleed effect.
-(void)bleedEnemyFromAngle:(float)_angle;



//Move enemy
-(void)moveEnemy;
@end
