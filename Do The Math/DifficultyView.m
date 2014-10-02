//
//  Difficulty.m
//  dothemath
//
//  Created by Innovattic 1 on 12/11/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "DifficultyView.h"
#import "Appearance.h"

@implementation DifficultyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setDifficulty:(NSNumber *)difficulty withLabel:(BOOL)showLabel {
    // Clear the subviews from the view
    for(UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    //Uitrekenen hoe groot de label gaat zijn om de sterren er recht achteraan te plakken
    CGSize labelframe = self.frame.size;
    labelframe.width = 0;
    if(showLabel) {
        // Show the label before the stars (if necessary)
        NSString *level = NSLocalizedString(@"LEVEL", @"Difficulty of a game shown in tablecell");
        UIFont *font = [UIFont fontWithName:[Appearance getFont] size:[Appearance subTextFontSize]];
        labelframe = [level sizeWithFont:font forWidth:73 lineBreakMode:NSLineBreakByClipping];
        UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, labelframe.width, labelframe.height)];
        levelLabel.text = level;
        levelLabel.font = font;
        levelLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:levelLabel];
    }
    
    // Add the stars for the difficulties
    int diff = [difficulty intValue];
    for (int i = 0; i < 4; i++) {
        UIImageView *star;
        if(i < diff) {
            star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"difficulty_star.png"]];
        } else {
            star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"difficulty_star_transparant.png"]];
        }
        star.frame = CGRectMake((i*18)+labelframe.width, 0, 15, 15);
        [self addSubview:star];
    }
}

@end
