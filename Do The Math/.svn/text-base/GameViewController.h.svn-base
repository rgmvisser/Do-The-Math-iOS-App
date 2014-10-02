//
//  GameViewController.h
//  dothemath
//
//  Created by Innovattic 1 on 10/4/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameMVCProtocol.h"
#import "Appearance.h"
#import "MainGameViewController.h"
#import <GameKit/GameKit.h>

@interface GameViewController : UIViewController <GameMVCProtocol>

- (void) translateExpression:(UIView*)view loadNew:(void(^)())loadNew completion:(void(^)())completed;
- (void) achievementUnlocked:(GKAchievement*)achievement;

@property (weak, nonatomic) MainGameViewController *delegate;

@end
