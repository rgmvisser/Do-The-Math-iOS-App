//
//  ScoreBarView.m
//  dothemath
//
//  Created by Innovattic 1 on 12/11/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "ScoreBarView.h"
#import <UIKit/UIKit.h>

@interface ScoreBarView()
{
    
    CGRect _initialFrame;
    UIImageView *_imageView;
}
@end

@implementation ScoreBarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.delay = 0;
        self.duration = 0.5;
        _initialFrame = frame;
    }
    return self;
}

// Add the score bar to this view without any filling done
-(void)addScoreBarImage:(UIImage *)image {
    _imageView = [[UIImageView alloc] initWithFrame:self.frame];
    _imageView.image = image;
    [self setPresentage:0 withLabel:nil animated:NO];
    [self addSubview:_imageView];
    
}

// Animates the scorebar in the round results screen to a new value
-(void)setPresentage:(double)percentage withLabel:(UILabel *)label animated:(BOOL)animated {
    // Prevent a drawing overflow in case the parameter is incorrect
    if(percentage > 1) {
        percentage = 1;
    }
    
    // Calculate the new values
    CGFloat y = _initialFrame.size.height * (1 - percentage);
    CGFloat height = _initialFrame.size.height * percentage;
    CGRect newFrame = self.frame;
    newFrame.origin.y = y;
    newFrame.size.height = height;
    CGRect newImageFrame = _imageView.frame;
    newImageFrame.origin.y = -y;
    
    if(animated) {
        // Go to the new value in an animated way
       [UIView animateWithDuration:self.duration delay:self.delay options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = newFrame;
            _imageView.frame = newImageFrame;
        } completion:^(BOOL finished) {
            if(label) {
                [UIView animateWithDuration:0.2 animations:^{
                    [label setAlpha:1];
                }];
            }
        }];
    } else {
        // Just set the new frame
        self.frame = newFrame;
        _imageView.frame = newImageFrame;
        if(label) {
            [label setAlpha:1];
        }
    }
}

@end
