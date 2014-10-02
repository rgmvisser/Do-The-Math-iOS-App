//
//  LoadingView.m
//  dothemath
//
//  Created by Innovattic 1 on 3/12/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "LoadingView.h"
#import "Appearance.h"
#import <QuartzCore/QuartzCore.h>
@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initInView:(UIView*)view
{
    self = [self initWithFrame:view.frame];
    if(self)
    {
        CGRect fullFrame = self.frame;
        DLog(@"Frame: %@",NSStringFromCGRect(fullFrame));
        [self setUserInteractionEnabled:YES];
        [self setExclusiveTouch:YES];
        CGSize frameSize = CGSizeMake(150, 150);
        fullFrame.origin.x = (fullFrame.size.width - frameSize.width) / 2;
        fullFrame.origin.y = (fullFrame.size.height - frameSize.height) / 2;
        fullFrame.size = frameSize;
        
        UIView *loadingView = [[UIView alloc] initWithFrame:fullFrame];
        [loadingView setBackgroundColor:[UIColor blackColor]];
        [loadingView setAlpha:0.8];
        loadingView.layer.cornerRadius = 20;
        loadingView.layer.masksToBounds = YES;
        [self addSubview:loadingView];
        
        CGSize indicatorSize = CGSizeMake(37, 37);
        CGRect indicatorFrame = fullFrame;
        indicatorFrame.origin.x = (indicatorFrame.size.width - indicatorSize.width) / 2;
        indicatorFrame.origin.y = (indicatorFrame.size.height - indicatorSize.height) / 2;
        indicatorFrame.size = indicatorSize;
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:indicatorFrame];
        [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator startAnimating];
        [loadingView addSubview:indicator];
    }
    return self;
}

-(id)initInView:(UIView *)view withMessage:(NSString *)message
{
    self = [self initInView:view];
    if(self)
    {
        CGRect loadingFrame = self.frame;
        CGSize frameSize = CGSizeMake(150, 150);
        loadingFrame.origin.x = (loadingFrame.size.width - frameSize.width) / 2;
        loadingFrame.origin.y = (loadingFrame.size.height - frameSize.height) / 2;
        loadingFrame.size = frameSize;
        CGFloat padding = 10;
        CGRect messageLabelframe = CGRectMake(loadingFrame.origin.x+padding, loadingFrame.origin.y+100, frameSize.width-(2*padding), 50);
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:messageLabelframe];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setFont:[UIFont fontWithName:@"System" size:17]];
        [messageLabel setTextColor:[UIColor whiteColor]];
        [Appearance setLabelFont:messageLabel];
        [messageLabel setTextAlignment:NSTextAlignmentCenter];
        [messageLabel setMinimumFontSize:10];
        [messageLabel setNumberOfLines:0];
        [messageLabel setAdjustsFontSizeToFitWidth:YES];
        [messageLabel setText:message];
        [self addSubview:messageLabel];
        
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
