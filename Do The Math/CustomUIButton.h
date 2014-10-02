//
//  CustomUIButton.h
//  Do The Math
//
//  Created by Rogier Slag on 10/1/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomUIButton : UIButton {
    CAGradientLayer *shineLayer;
    CALayer         *highlightLayer;
}

- (IBAction)colorButtonClicked:(UIButton *)sender;
@end
