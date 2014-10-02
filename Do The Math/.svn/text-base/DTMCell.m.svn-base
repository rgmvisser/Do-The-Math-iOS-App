//
//  DTMCell.m
//  dothemath
//
//  Created by Innovattic 1 on 11/12/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "DTMCell.h"

@implementation DTMCell
{
    UIImageView *_background;
    UIImageView *_backgroundSelected;
}
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
    [super awakeFromNib];
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_middle.png"]];
    [self setBackgroundView:_background];
    _backgroundSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_middle_selected.png"]];
    [self setSelectedBackgroundView:_backgroundSelected];
    
    if(self.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
    {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow.png"]];
    }
    
    
}

-(void)isFirstCell
{
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_top.png"]];
     [self setBackgroundView:_background];
    
    _backgroundSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_top_selected.png"]];
    [self setSelectedBackgroundView:_backgroundSelected];
}

-(void)isLastCell
{
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bottom.png"]];
     [self setBackgroundView:_background];
    
    _backgroundSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bottom_selected.png"]];
    [self setSelectedBackgroundView:_backgroundSelected];

}
/*
 * Set the background to both first and last.
 */
-(void)isFirstAndLastCell
{
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_single.png"]];
    [self setBackgroundView:_background];
    
    _backgroundSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_single_selected.png"]];
    [self setSelectedBackgroundView:_backgroundSelected];
}

-(void)isNormalCell
{
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_middle.png"]];
    [self setBackgroundView:_background];
    _backgroundSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_middle_selected.png"]];
    [self setSelectedBackgroundView:_backgroundSelected];
    
}



- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    //frame.origin.y += 10;
    frame.size.width -= 2 * 10;
    //DLog(@"Cell Frame: %@",NSStringFromCGRect(frame));
    [super setFrame:frame];
}


@end
