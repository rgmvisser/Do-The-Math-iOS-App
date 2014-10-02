//
//  SwitchCell.h
//  dothemath
//
//  Created by Innovattic 1 on 12/21/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTMCell.h"

@interface SwitchCell : DTMCell
@property (weak, nonatomic) IBOutlet UILabel *soundEffectLabel;
@property (weak, nonatomic) IBOutlet UISwitch *soundEffectSwitch;

@end
