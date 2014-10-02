//
//  AchievementCell.m
//  dothemath
//
//  Created by Innovattic 1 on 1/23/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "AchievementCell.h"
#import "Appearance.h"

@interface AchievementCell ()
{
    GKAchievementDescription *_achievement;
}

@end

@implementation AchievementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib
{
    [Appearance setCellLabel:self.achievementTitle];
    [Appearance setCellLabel:self.achievementDescription];
    //[self.achievementDescription setFont:[UIFont fontWithName:[Appearance getFont] size:[Appearance subTextFontSize]]];

}

-(void)setAchievement:(GKAchievementDescription *)achievement
{
    _achievement = achievement;
    self.achievementTitle.text = achievement.title;
    self.achievementDescription.text = achievement.unachievedDescription;
    [self.achievementImage setImage:[GKAchievementDescription incompleteAchievementImage]];
}

-(void)setEarned
{
    self.achievementDescription.text = _achievement.achievedDescription;
    [self.achievementImage setImage:[GKAchievementDescription placeholderCompletedAchievementImage]];
    [_achievement loadImageWithCompletionHandler:^(UIImage *image, NSError *error) {
        [self.achievementImage setImage:image];
    }];
}
@end
