//
//  UILabelCounter.m
//  dothemath
//
//  Created by Innovattic 1 on 11/21/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "UILabelCounter.h"

@interface UILabelCounter ()

@property (nonatomic) int from;
@property (nonatomic) int to;
@property (nonatomic) double durationPerNumber;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) UILabel *label;
@property (copy, nonatomic) void (^completion) (void);
@end

@implementation UILabelCounter

/**
 * Make a counter for a label, with a delay and duration
 */
-(void)animateUILabel:(UILabel*)label from:(NSNumber *)from to:(NSNumber *)to duration:(int)duration delay:(int)delay completion:(void (^)(void))completion
{
    self.label = label;
    self.from = [from intValue];
    self.to = [to intValue];
    self.completion = completion;
    double steps = (double) abs(self.to - self.from);
    //Doesnt have any steps, continue
    if(steps == 0)
    {
        label.text = [NSString stringWithFormat:@"%d",self.to];
        self.completion();
        return;
    }
    self.durationPerNumber = ((double)duration / 1000) / steps; //duration in milliseconde
    double secondsDelay = (double) delay / 1000; //delay in milliseconde
    
    //Logs:
    //DLog(@"Steps: %f",steps);
    //DLog(@"Duration:%f",self.durationPerNumber);
    //DLog(@"Delay :%f",secondsDelay);
    
    
    //Make a timer to delay the animation
    NSTimer *delayTimer = [NSTimer timerWithTimeInterval:secondsDelay target:self selector:@selector(startAnimating) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:delayTimer forMode:NSDefaultRunLoopMode];
}

/**
 * Start the animation
 */
-(void)startAnimating
{
    //set the start value for the label
    self.label.text = [NSString stringWithFormat:@"%d",self.from];
    
    //Add a timer which animates the label
    self.timer = [NSTimer timerWithTimeInterval:self.durationPerNumber target:self selector:@selector(animateLabel) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

/**
 * Animate the label
 */
-(void)animateLabel
{
    //increase or decrease the label to the goal
    if(self.from < self.to)
    {
        self.from++;
    }
    else if(self.from > self.to)
    {
        self.from--;
    }
    else{
        //goal reached, stop
        [self.timer invalidate];
        self.completion();
        
    }
    
    //set the label to the current counter
    self.label.text = [NSString stringWithFormat:@"%d",self.from];
}

@end
