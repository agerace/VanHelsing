//
//  PowerUpNukeBomb.m
//  VanHelsing2
//
//  Created by César Andrés Gerace on 10/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PowerUpNukeBomb.h"


@implementation PowerUpNukeBomb

@synthesize theGame;

-(id)initWithTheGame:(GameScene *)_theGame
{
    
    if (self = [super init])
    {
        theGame = _theGame;
        explosionPosition = theGame.character.characterSpriteTorso.position;
        
        bombExplosion = [CCSprite spriteWithSpriteFrameName:@"bullet8.png"];
        [bombExplosion setPosition:explosionPosition];
        [bombExplosion setScale:0.1];
//        [bombExplosion setOpacity:190];

        
        expansiveAlpha = 1.0;
        expansiveRadius = 10;
        
        [theGame runAction:[CCSequence actions:
                            [CCMoveBy actionWithDuration:0.1 position:ccp(5,5)],
                            [CCMoveBy actionWithDuration:0.1 position:ccp(-5,-5)],
                            [CCMoveBy actionWithDuration:0.1 position:ccp(5,0)],
                            [CCMoveBy actionWithDuration:0.1 position:ccp(-5,0)],
                            nil]];
        
        [theGame addChild:self z:400];
        [theGame addChild:bombExplosion z:399];
        [bombExplosion runAction:[CCSpawn actions:
                                  [CCScaleTo actionWithDuration:0.4 scale:12],
                                  [CCFadeOut actionWithDuration:0.4],
                                  nil]];
        [self scheduleOnce:@selector(removeExplosion) delay:6];
    }
    
    return self;
}
-(void)draw
{
    //ENABLE ALPHA.
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    [super draw];
    //the color of the line
    ccDrawColor4F(1.0, 1.0, 1.0, expansiveAlpha);
    
    //the width of the line
    glLineWidth(1.0f);
    ccDrawCircle(explosionPosition, expansiveRadius, 0, 100, NO);

    glLineWidth(3.5f);
    ccDrawCircle(explosionPosition, expansiveRadius - (10/expansiveAlpha), 0, 100, NO);
    
    expansiveRadius += 10;
    
    expansiveAlpha -= 0.04;
}
-(void)removeExplosion
{
    if (expansiveAlpha < 0);
    {
        [theGame removeChild:bombExplosion cleanup:YES];
        [theGame removeChild:self cleanup:YES];
    }
}
@end
