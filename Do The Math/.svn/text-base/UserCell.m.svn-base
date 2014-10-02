//
//  UserCell.m
//  dothemath
//
//  Created by Innovattic 1 on 11/1/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "UserCell.h"
#import "RankManager.h"

@implementation UserCell

@synthesize username = _username;
@synthesize button = _button;
@synthesize avatar = _avatar;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setStyle];
        
        
    }

    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setStyle];  
    
}

-(void)setStyle
{
    [Appearance setCellLabel:self.username];
    [Appearance setCellLabel:self.subtext];
    [self.subtext setFont:[UIFont fontWithName:[Appearance getFont] size:[Appearance subTextFontSize]]];
    [Appearance setCellButton:self.button];
    [self.button setContentEdgeInsets:UIEdgeInsetsMake(4, 8, 0, 8)];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
