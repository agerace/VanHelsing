//
//  PowerUpIndicator.m
//  VanHelsing2
//
//  Created by César Andrés Gerace on 18/01/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PowerUpIndicator.h"

@implementation PowerUpIndicator
@synthesize leftTime, totalTime, theGame;
-(id)initWithType:(int)_type andGame:(GameScene *)_theGame
{
    if ( self = [super init])
    {
        theGame = _theGame;
        
        totalTime = 0;
        leftTime = 0;
        
        NSString * powerUpName = [NSString stringWithFormat:@"powerUp%d.png",_type];
        
        powerUpSprite = [CCSprite spriteWithSpriteFrameName:powerUpName];
        [self addChild:powerUpSprite];
        
        lblTime = [CCLabelTTF labelWithString:@"" fontName:@"arial" fontSize:18];
        [self addChild:lblTime];
        [lblTime setColor:ccWHITE];
        
        [self reArrangeItems:(-1)];
        
        [theGame addChild:self];
    }
    return self;
}
-(void)reArrangeItems:(int)_atPosition
{
    //If the position is -1 then put the indicator outbounds.
    if (_atPosition == (-1))
    {
        //Arrange the sprite and the label out bounds.
        [powerUpSprite  setPosition:ccp ( -200 , -200 )];
        [lblTime setPosition:ccp(-200,-200)];
        //Replace this indicator by a pivote that'll let us know what position is empty or full.
        [theGame.powerUpManager.arrIndicators replaceObjectAtIndex:[theGame.powerUpManager.arrIndicators indexOfObject:self] withObject:[NSNull null]];
    //Else arrange the indicator in the right position having in count the gave position.
    }else
    {
        //Margin between the screen and the first indicator. Vertical Y
        int yMargin = 20;
        //Margin between the screen and the indicator. Horizontal X
        int xMargin = 10;
        //Distance between each indicator.
        int distance = 50;
        //Set the sprite position. (xMargin , screens top - (margen vertical +
        //(distancia entre indicadores multiplicado por la posicion))
        [powerUpSprite  setPosition:ccp ( xMargin , theGame.screenSize.height - (yMargin + (distance * _atPosition)))];
        //TEST DEV set the indicator label position.
        [lblTime setPosition:ccp(powerUpSprite.position.x + distance , powerUpSprite.position.y)];
    }

}
-(void)setTotalTime:(int)_totalTime
{
    //If totalTime == 0 . Meaning: if the power up was inactive.
    if(totalTime == 0)
    {
        int arrPosition = [theGame.powerUpManager.arrIndicators indexOfObject:self];
        
        //Arrange the indicator in the screen. Se acomoda depende los que estén activos
        //leyendo el array y viendo en qué posición se posicionó el indicador.
        [self reArrangeItems:arrPosition];
    }
    //Add total time.
    totalTime = leftTime + _totalTime;
    //TEST DEV Change the label that shows left and total time.
    [lblTime setString:[NSString stringWithFormat:@"%d/%d",leftTime,totalTime]];
}
-(void)setLeftTime:(int)_leftTime
{
    //Set the left time.
    leftTime = _leftTime;
    //If left time is equal to zero or less.
    if ( leftTime <= 0)
    {
        //Re arrange the indicator out bounds.
        [self reArrangeItems:(-1)];
        //Reset the total time.
        totalTime = 0;
    }else
        //TEST DEV set the indicator label.
        [lblTime setString:[NSString stringWithFormat:@"%d/%d",leftTime,totalTime]];
}

@end
