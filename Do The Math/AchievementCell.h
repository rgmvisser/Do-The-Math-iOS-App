//
//  AchievementCell.h
//  dothemath
//
//  Created by Innovattic 1 on 1/23/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTMCell.h"
#import <GameKit/GameKit.h>

@interface AchievementCell : DTMCell
@property (weak, nonatomic) IBOutlet UILabel *achievementTitle;
@property (weak, nonatomic) IBOutlet UILabel *achievementDescription;
@property (weak, nonatomic) IBOutlet UIImageView *achievementImage;

-(void)setAchievement:(GKAchievementDescription *)achievement;
-(void)setEarned;
@end
