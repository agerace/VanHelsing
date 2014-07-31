//
//  EnemyManager.m
//  vanhelsing
//
//  Created by César Andrés Gerace on 25/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//COMMON ENEMIES.
#import "EnemyManager.h"
#import "EnemyVampire.h"
#import "EnemyZombie.h"
#import "EnemySpider.h"
#import "EnemyPredator.h"

//BOSSES.
#import "EnemyBossZombie.h"
#import "EnemyBossSpider.h"

//SPAWN POINTS.
#import "EnemySpawnPointZombie.h"

@implementation EnemyManager
@synthesize theGame, enemiesArray, enemiesDeadArray, bonusEnemiesVelocity, bonusEnemiesFreeze;

-(id)initWithTheGame:(GameScene *)_theGame
{
 if(self = [super init])
 {
     //Assign the game scene.
     theGame = _theGame;
     //Add this node to the game.
     [theGame addChild:self];
     //Initiate the spawn object variable.
     actualSpawnObject = 0;
     //Initiate in 1 the velocity multiplier. 0.5 'll be for slow motion.
     bonusEnemiesVelocity = 1;
     //Initiate in 1 the freeze multiplier. 0 'll be for freeze.
     bonusEnemiesFreeze = 1;
     //Create the enemies array to save all enemies.
     enemiesArray = [[NSMutableArray alloc] initWithCapacity:0];     
     
     //Search the path for the level enemies plist file.
     NSString *path = [[NSBundle mainBundle] bundlePath];
     NSString *finalPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"level%d.plist",[[NSUserDefaults standardUserDefaults] integerForKey:@"level"]]];
        
     //Save the sequence of enemies into levelInfoarray.
     NSDictionary * dict = [[NSDictionary alloc]initWithContentsOfFile:finalPath];     
     levelInfoArray = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"levelInfo"]];
     [dict release];
     
     //Schedule the update.
     [self schedule:@selector(spawnEnemies) interval:0.1];
 }
    return self;
}

//Update that will check the time and make the spawn of enemies.
-(void)spawnEnemies
{
    //if there's no more spawn objects 
    if (actualSpawnObject >= [levelInfoArray count])
    {
        //If there's no enemies left.
        if ([enemiesArray  count] == 0 )
        {
            //Unschedule the update.
            [self unschedule:@selector(spawnEnemies)];         
            //DEVELOPEMENT
            //Show the user the results of level and the menu to play again, menu, share, etc.
            [theGame gameOver];
            return;
        }
    //If are spawn objects left 
    }else
    {
        //Save the next time to spawn from the actual spawn object.
        timeToNextSpawn = [[[levelInfoArray objectAtIndex:actualSpawnObject] valueForKey:@"fromTime"] intValue];
    }

    //Timer variable.
    time += 1;
    
    //If time of the next respawn has passed.
    if ( time == timeToNextSpawn )
    {
        //Get the position the spawn will appear.
        int position = [[[levelInfoArray objectAtIndex:actualSpawnObject]valueForKey:@"fromPosition"] intValue];

        //Create enemies equal to the qty of enemies to spawn.
        for ( int i = 0 ; i < [[[levelInfoArray objectAtIndex:actualSpawnObject] valueForKey:@"enemyQty"]intValue ] ; i++)
        {
            //Create enemy from position and with the enemy info.
            [self createEnemyFromPosition:position  andType:[[[levelInfoArray objectAtIndex:actualSpawnObject] valueForKey:@"enemyType"]intValue]];
        }
        //increase the actual spawn object.
        actualSpawnObject ++;                
    }
}

//Method called to create an enemy.
-(void)createEnemyFromPosition:(int)_position andType:(kEnemyType)_type
{
    //DEVELOPEMENT 
    //Should review this variable. By now it just let us know if the spawn will appear up,down,left or right out of the screen.
    //But in some time we should have enemies respawning in screen, with specify CGPOINT. By now, and with the point of have some
    //playable beta version this is fine.

    //Make the enemies appear not in line, but in random zig zag.
    int avoidLinealPosition = ((arc4random()%200)+20);
    
    CGPoint spawnPosition;
    switch (_position) {
            //UP
        case 1:
//            spawnPosition = ccp (arc4random()%(int)(theGame.screenSize.width) ,theGame.screenSize.height - avoidLinealPosition);
            spawnPosition = ccp (arc4random()%(int)(theGame.screenSize.width) ,theGame.screenSize.height + avoidLinealPosition);            
            break;
            //RIGHT
        case 2:
//            spawnPosition = ccp ( theGame.screenSize.width - avoidLinealPosition , arc4random()%(int)(theGame.screenSize.height));
            spawnPosition = ccp ( theGame.screenSize.width + avoidLinealPosition , arc4random()%(int)(theGame.screenSize.height));            
            break;
            //DOWN
        case 3:
//            spawnPosition = ccp (arc4random()%(int)(theGame.screenSize.width) , avoidLinealPosition);            
            spawnPosition = ccp (arc4random()%(int)(theGame.screenSize.width) , avoidLinealPosition * (-1));
            break;
            //LEFT
        case 4:
//            spawnPosition = ccp (avoidLinealPosition , arc4random()%(int)(theGame.screenSize.height));            
            spawnPosition = ccp (avoidLinealPosition * (-1) , arc4random()%(int)(theGame.screenSize.height));
            break;
        case 5:
            spawnPosition = ccp (arc4random()%(int)(theGame.screenSize.width) ,arc4random()%(int)(theGame.screenSize.height));
            break;
        default:
            break;
    }
    //Create the enemy.
    switch (_type) {
        case kEnemySpider:
        {
            EnemySpider * enemy = [[EnemySpider alloc] initWithGame:theGame andPosition:spawnPosition];
            [enemiesArray addObject:enemy];            
        }
            break;
        case kEnemyZombie:
        {
            EnemyZombie * enemy = [[EnemyZombie alloc] initWithGame:theGame andPosition:spawnPosition];
            [enemiesArray addObject:enemy];
        }
            break;
        case kEnemyVampire:
        {
            EnemyVampire * enemy = [[EnemyVampire alloc] initWithGame:theGame andPosition:spawnPosition];
            [enemiesArray addObject:enemy];
        }
            break;            
        case kEnemyPredator:
        {
            EnemyPredator * enemy = [[EnemyPredator alloc] initWithGame:theGame andPosition:spawnPosition];
            [enemiesArray addObject:enemy];
        }
            break;
        case kEnemyBossZombie:
        {
            EnemyBossZombie * enemy = [[EnemyBossZombie alloc] initWithGame:theGame andPosition:spawnPosition];
            [enemiesArray addObject:enemy];            
        }
            break;
        case kEnemyBossSpider:
        {
            EnemyBossSpider * enemy = [[EnemyBossSpider alloc] initWithGame:theGame andPosition:spawnPosition];
            [enemiesArray addObject:enemy];            
        }
            break;
        case kEnemySpawnPointZombie:
        {
            EnemySpawnPointZombie * enemy = [[EnemySpawnPointZombie alloc] initWithGame:theGame andPosition:spawnPosition];
            [enemiesArray addObject:enemy];            
        }
            break;
        default:
            break;
    }    
}
-(void)createEnemy:(kEnemyType)_type
{

//    
//    MainEnemyClass * enemy = [[MainEnemyClass alloc]initWithGame:theGame andPosition:spawnPosition andInfo:_infoDictionary];
//    //Add the enemy to the enemies array. They'll removed from this array when drop dead. This array'll be usefull to do stuffs
//    //with living enemies.

    
}
-(void)dealloc
{
    if(enemiesArray)
    {
        enemiesArray = nil;
        [ enemiesArray removeAllObjects];
    }
    [enemiesArray release];
    
    
    if(levelInfoArray)
    {
        levelInfoArray = nil;
        [ levelInfoArray removeAllObjects];
    }
    [levelInfoArray release];
    
    [super dealloc];
}
@end
