//
//  AchievementManager.h
//  dothemath
//
//  Created by Rogier Slag on 14/12/2012.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question+Functions.h"
#import "GameViewController.h"
#import "GameCenterManager.h"
#import "Game+Functions.h"

@interface AchievementManager : NSObject <GKAchievementViewControllerDelegate, GameCenterManagerDelegate>

@property (weak,nonatomic) GameViewController* delegate;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
+ (AchievementManager *) shared;

- (NSArray *)achievementsList;
-(NSDictionary *)earndedAchievementList;

- (BOOL)isLoggedIn;
-(void)loginGameCenter;

- (void) checkQuestionForAchievement:(Question*)question;
- (void) roundComplete:(Game*)game;
- (void) faceBookInvite;
- (void) faceBookShare;
- (void) tweet;

- (void) checkNumberOfGamesPlayed;
- (void) friends:(int)friends;

- (void) resetForGame:(Game*)game roundNumber:(NSNumber*)round;
- (void) resetAchievements;
@end
