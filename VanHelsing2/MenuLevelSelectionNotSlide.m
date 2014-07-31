//
//  MenuLevelSelectionNotSlide.m
//  VanHelsing2
//
//  Created by César Andrés Gerace on 07/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MenuLevelSelectionNotSlide.h"
#import "GameScene.h"

// THIS IS NOT A SLIDE MENU. :) :) 

@implementation MenuLevelSelectionNotSlide
+(CCScene *) scene
{
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLevelSelectionNotSlide *layer = [MenuLevelSelectionNotSlide node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id)init
{
    if ( self = [super init])
    {
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCLabelTTF * label1 =[CCLabelTTF labelWithString:@"Level 1"
                                                fontName:@"arial"
                                                fontSize:20];
        [label1 setColor:ccORANGE];
        CCMenuItemImage * item1 =  [CCMenuItemLabel itemWithLabel:label1
                                                            block:^(id sender){
                                                                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"level"];
                                                                [self startLevel];
                                                            }];
        [item1 setPosition:ccp(screenSize.width/2 , screenSize.height/3)];

        CCLabelTTF * label2 =[CCLabelTTF labelWithString:@"Level 2"
                                                fontName:@"arial"
                                                fontSize:20];
        [label2 setColor:ccORANGE];
        
        CCMenuItemImage * item2 = [CCMenuItemLabel itemWithLabel:label2
                                                                 block:^(id sender){
                                                                     [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"level"];
                                                                     [self startLevel];
                                                                 }];
        [item2 setPosition:ccp(screenSize.width/2 , screenSize.height/4)];
        
        CCLabelTTF * label3 =[CCLabelTTF labelWithString:@"Level 3"
                                                fontName:@"arial"
                                                fontSize:20];
        [label3 setColor:ccORANGE];
        
        CCMenuItemImage * item3 =  [CCMenuItemLabel itemWithLabel:label3
                                                                  block:^(id sender){
                                                                      [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"level"];
                                                                      [self startLevel];
                                                                  }];

        [item3 setPosition:ccp(screenSize.width/2 , screenSize.height/2)];
        
        CCMenu * menu = [CCMenu menuWithItems:item1, item2, item3, nil];
        [menu setPosition:ccp(0,0)];
        [self addChild:menu];
        
        [self createWeaponMenu];
    }
    return self ;
}
/*
 kWeaponPistol = 1,
 kWeaponSubMachineGun = 2,
 kWeaponShotgun = 3,
 kWeaponAutomaticRifle = 4,
 kWeaponJackHamer = 5,
 kWeaponGaussGun = 6,
 kWeaponMiniGun = 7,
 kWeaponGaussShotgun = 8,
 kWeaponPlasmaRifle = 9,
 kWeaponPlasmaShotgun = 10,
 kWeaponIonRifle = 11,
 kWeaponIonShotgun = 12,
 kWeaponMisilLauncher = 13,
 kWeaponGranadeLauncher = 14,
 kWeaponMineLauncher = 15 ,
 kWeaponLaserBeam = 16 ,
 kWeaponFlameThrower = 17 ,
 kWeaponTotal = 18
 */
-(void)createWeaponMenu
{
        CGSize screenSize = [CCDirector sharedDirector].winSize;
    NSMutableArray * menuItemsArray = [NSMutableArray arrayWithCapacity:0];
    
    for ( int i = 1 ; i < 18 ; i ++ )
    {
        CCLabelTTF * label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"weapon %d",i ]
                                                fontName:@"arial"
                                                fontSize:20];
        [label setColor:ccORANGE];
        CCMenuItemImage * item =  [CCMenuItemLabel itemWithLabel:label
                                                            block:^(id sender){
                                                                [[NSUserDefaults standardUserDefaults] setInteger:i forKey:@"NSCurrentWeapon"];
                                                            }];
        [item setPosition:ccp(screenSize.width/5 , screenSize.height - 100 - (35*i))];
        
        [menuItemsArray addObject:item];
    }

    CCMenu * weaponMenu = [CCMenu menuWithArray:menuItemsArray];
    [weaponMenu setPosition:ccp(0,0)];
    [self addChild:weaponMenu];
    
    
    
}
-(void)startLevel
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScene scene] withColor:ccBLACK]];
}
@end
