//
//  EnemyManager.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 25/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

typedef enum kEnemyType
{
    kEnemySpider = 1,
    kEnemyZombie = 2,
    kEnemyVampire = 3,
    kEnemyPredator = 4,
    //BOSSES
    kEnemyBossZombie = 101,
    kEnemyBossSpider = 102,    
    //SPAWN POSITIONS
    kEnemySpawnPointZombie = 201
}kEnemyType;

@interface EnemyManager : CCNode {
    GameScene * theGame;
    NSMutableArray * enemiesArray;
    NSMutableArray * enemiesDeadArray;
    NSMutableArray * levelInfoArray;
    int actualSpawnObject;
    int time;
    int timeToNextSpawn;
    
    float bonusEnemiesVelocity;
    float bonusEnemiesFreeze;
}
@property (nonatomic,assign)GameScene * theGame;
@property (nonatomic,retain)NSMutableArray * enemiesArray;
@property (nonatomic,retain)NSMutableArray * enemiesDeadArray;

@property (nonatomic,readwrite)float bonusEnemiesVelocity;
@property (nonatomic,readwrite)float bonusEnemiesFreeze;

-(id)initWithTheGame:(GameScene *)_theGame;
-(void)spawnEnemies;
-(void)createEnemyFromPosition:(int)_position andType:(kEnemyType)_type;
-(void)createEnemy:(kEnemyType)_type;
@end
