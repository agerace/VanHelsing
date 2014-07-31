//
//  AppDelegate.h
//  VanHelsing2
//
//  Created by César Andrés Gerace on 26/11/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

    NSMutableArray * tempArray;
    NSString * userFilePath;
    
	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@property (nonatomic, retain)NSMutableArray * tempArray;
@property (nonatomic, retain)NSString * userFilePath;
+(AppController *) get;
-(void)saveFile;
-(void)loadInfoFiles:(int)_profile;

@end
