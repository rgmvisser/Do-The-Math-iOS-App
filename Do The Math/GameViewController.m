//
//  GameViewController.m
//  dothemath
//
//  Created by Innovattic 1 on 10/4/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "GameViewController.h"
#import "SoundController.h"
#import "AchievementManager.h"
@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *tryLaterButton;

@end

@implementation GameViewController

/**
 * Super class for gameviewcontrollers. 
 */


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setQuestion:(Question *)question
{
    //must be overwritten by subclass
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tryLaterButton setTitle:NSLocalizedString(@"TRY_LATER", @"Try Later button") forState:UIControlStateNormal];
    
    [Appearance setStyleButton:self.tryLaterButton];
    [AchievementManager shared].delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) translateExpression:(UIView*)view loadNew:(void(^)())loadNew completion:(void(^)())completed
{
    // Current position
    CGRect currentFrame = view.frame;
    
    // Throw the old question out
    [UIView transitionWithView:view duration:0.2f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        view.frame = CGRectMake(currentFrame.origin.x-self.view.frame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
        
    } completion:^(BOOL finished) {
        // Load the new one
        view.frame = CGRectMake(currentFrame.origin.x+self.view.frame.size.width, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
        
        loadNew();
        
        [UIView transitionWithView:view duration:0.2f options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.frame = currentFrame;
        } completion:^(BOOL finished2) {
            // done
            completed();
            if ( !finished2) {
                DLog(@"Hoezo not finished? (second)");
            }
        }];
        if ( !finished) {
            DLog(@"Hoezo not finished? (first)");
        }
    }];

}

- (void) achievementUnlocked:(GKAchievement*)achievement {
    
    //Not yet used
    
}
- (void)viewDidUnload {
    [self setTryLaterButton:nil];
    [super viewDidUnload];
}
@end
