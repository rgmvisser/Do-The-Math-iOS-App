//
//  HeaderCell.m
//  dothemath
//
//  Created by Innovattic 1 on 11/14/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "HeaderCell.h"
#import "Appearance.h"

@interface HeaderCell()
{
    UILabel *_title;
}

@end

@implementation HeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_header.png"]];
    
    
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    background.frame = frame;
    
    if(!_title)
    {
        //init title
        _title = [[UILabel alloc] init];
    }
    
    frame.origin.y = 22;
    //DLog(@"frame: %@",NSStringFromCGRect(frame));
    [_title setFrame:frame];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.backgroundColor = [UIColor clearColor];
    _title.textColor = [UIColor whiteColor];
    _title.font = [UIFont fontWithName:[Appearance getFont] size:21];
    [self addSubview:_title];
    [self setBackgroundView:background];
    // [self addSubview:_background];
}

-(void)setHeader:(NSString *)title
{
    _title.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBounds:(CGRect)bounds
{
    //bounds.origin.y = 10;
    [super setBounds:bounds];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.size.width -= 2 * 10;
    //DLog(@"Header frame: %@",NSStringFromCGRect(frame));
    
    [super setFrame:frame];
}

@end
