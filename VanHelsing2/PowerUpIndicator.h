//
//  PowerUpIndicator.h
//  VanHelsing2
//
//  Created by César Andrés Gerace on 18/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
@class GameScene;

@interface PowerUpIndicator : CCNode {
    CCSprite * powerUpSprite;
    CCSprite * powerUpBackBar;
    CCSprite * powerUpFrontBar;
    
    int totalTime;
    int leftTime;
    
    CCLabelTTF * lblTime;
    
    GameScene * theGame;
}
@property (nonatomic,readwrite)int totalTime;
@property (nonatomic,readwrite)int leftTime;
@property (nonatomic,assign)GameScene * theGame;

-(id)initWithType:(int)_type andGame:(GameScene *)_theGame;

@end
