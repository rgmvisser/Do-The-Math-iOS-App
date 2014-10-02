//
//  LoadingAlert.m
//  dothemath
//
//  Created by Innovattic 1 on 3/18/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "LoadingAlert.h"

@implementation LoadingAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        CGFloat y = ((280 - 37) / 2);
        loading.frame = CGRectMake(y, 70, 37, 37);
        [loading startAnimating];
        [self addSubview:loading];    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
