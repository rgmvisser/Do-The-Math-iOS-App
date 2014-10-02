//
//  LoginTextButton.m
//  dothemath
//
//  Created by Rogier Slag on 05/12/2012.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "LoginTextButton.h"
#import "Appearance.h"

@implementation LoginTextButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Draws a semi transparenttext in a custom view button
- (void) drawPlaceholderInRect:(CGRect)rect {
    [[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.75] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont fontWithName:[Appearance getFont] size:self.font.pointSize] lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
}

@end
