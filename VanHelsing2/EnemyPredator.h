
//
//  EnemySpider.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainEnemyClass.h"
#import "BulletMainClass.h"


typedef enum kPredatorMoveState
{
    kPredatorMoveForward = 1,
    kPredatorTurnVisible = 2,
    kPredatorFireAtWill = 3,
    kPredatorTurnInvisible = 4 
    
}kPredatorMoveState;

@interface EnemyPredator : MainEnemyClass  {
    int actualAngle;
    int moveToAngle;
    int moveFromAngle;
    int marginToMove;
    kPredatorMoveState moveState;
}
//Get the angle from enemy sprite to character sprite.
-(int)angleToCharacter;
//Change the move state
-(void)changeMoveState; 

//Init Method.
-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position;
-(void)setInitialPosition;
@end