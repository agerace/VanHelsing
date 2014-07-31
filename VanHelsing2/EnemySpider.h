
//
//  EnemySpider.h
//  vanhelsing
//
//  Created by César Andrés Gerace on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainEnemyClass.h"


typedef enum kSpiderMoveState
{
    kSpiderMoveForward = 1,
    kSpiderMoveRotateAndForward = 2,
    kSpiderMoveStayQuiet = 3 
    
}kSpiderMoveState;

@interface EnemySpider : MainEnemyClass  {
    int actualAngle;
    int moveToAngle;
    int moveFromAngle;
    kSpiderMoveState moveState;
    NSString * spiderEnemyName;
}
//set spider atributes.
-(void)setSpiderAtributes;
//Get the angle from enemy sprite to character sprite.
-(int)angleToCharacter;
//Change the move state
-(void)changeMoveState; 
-(id)initWithGame:(GameScene *)_theGame andPosition:(CGPoint)_position;

@end