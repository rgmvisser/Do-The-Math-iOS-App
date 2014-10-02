//
//  ButtonCell.m
//  dothemath
//
//  Created by Innovattic 1 on 11/28/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "ButtonCell.h"
#import "Appearance.h"

@implementation ButtonCell

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
    [Appearance setLabelFont:self.button.titleLabel];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
