//
//  PowerUpNukeBomb.h
//  VanHelsing2
//
//  Created by César Andrés Gerace on 10/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
@class GameScene;

@interface PowerUpNukeBomb : CCNode {
    CCSprite * bombExplosion;

    CGPoint explosionPosition;
    
    float expansiveRadius;
    float expansiveAlpha;
    
    GameScene * theGame;
}
@property (nonatomic,assign)GameScene * theGame;

-(id)initWithTheGame:(GameScene *)_theGame;


@end
