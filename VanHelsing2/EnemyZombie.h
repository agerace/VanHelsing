
//
//  EnemyZombie.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "MainEnemyClass.h"
typedef enum kZombieMoveState
{
    kZombieMoveForward = 1,
    kZombieMoveRotate = 2,
    kZombieMoveForwardAndRotate = 3
}kZombieMoveState;

@interface EnemyZombie : MainEnemyClass  {
    int moveToAngle;
    int moveFromAngle;
    int actualAngle;
    float bonusZombieRageSpeed;
    
    NSString * zombieEnemyName;
    
    BOOL isInMovementArea;
    BOOL isAvoidingEnemy;
    
    kZombieMoveState moveState;
}
-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position;

-(void)setZombieAtributes;
-(void)changeActualAngle;
-(int)angleToCharacter;
-(int)angleToRandom;
@end