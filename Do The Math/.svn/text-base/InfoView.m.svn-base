//
//  info.m
//  dothemath
//
//  Created by Innovattic 1 on 3/26/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "InfoView.h"
#import "Appearance.h"
#import <QuartzCore/QuartzCore.h>
@implementation InfoView


-(id)initWithFrame:(CGRect)frame info:(NSString *)info board:(CGPoint)boardLocation circle:(CGRect)circle arrow:(CGRect)arrow
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.locationArrow = arrow;
        self.locationBoard = boardLocation;
        self.locationCircle = circle;
        self.info = info;
        UIImage *circleImage = [UIImage imageNamed:@"tutorial_redcircle"];
        UIImage *arrowImage = [UIImage imageNamed:@"tutorial_redarow"];
        UIImage *boardImage = [[UIImage imageNamed:@"tutorial_chalkboard_full" ] imageWithAlignmentRectInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
        UIImageView *circleView = [[UIImageView alloc] initWithFrame:circle];
        [circleView setImage:circleImage];
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:arrow];
        if(circle.origin.x < arrow.origin.x)
        {
            arrowView.transform = CGAffineTransformMakeScale(-1, 1);
        }
        
        [arrowView setImage:arrowImage];
        CGRect boardFrame = CGRectMake(boardLocation.x, boardLocation.y, 222, 193);
        UIImageView *boardView = [[UIImageView alloc] initWithFrame:boardFrame];
        [boardView setImage:boardImage];
        
        [self addSubview:circleView];
        [self addSubview:arrowView];
        [self addSubview:boardView];
        
        CGFloat left = 30;
        CGFloat right = 35;
        CGFloat top = 30;
        CGFloat bottom = 35;
        CGRect infoFrame = boardFrame;
        infoFrame.origin.x += left;
        infoFrame.size.width -= (left+right);
        infoFrame.origin.y += top;
        infoFrame.size.height -= (top+bottom);
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoFrame];
        [infoLabel setNumberOfLines:0];
        [infoLabel setFont:[UIFont fontWithName:@"System" size:14]];
        [Appearance setLabelFont:infoLabel];
        [infoLabel setTextColor:[UIColor whiteColor]];
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        [infoLabel setText:info];
        
        [self addSubview:infoLabel];
        
        
    }
    return self;
}


@end
