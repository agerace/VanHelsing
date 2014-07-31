
//
//  EnemyBossZombie.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


@class GameScene;
#import "MainEnemyClass.h"

@interface EnemySpawnPointZombie : MainEnemyClass  {
    
}
-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position;
-(void)spawnZombie;
@end