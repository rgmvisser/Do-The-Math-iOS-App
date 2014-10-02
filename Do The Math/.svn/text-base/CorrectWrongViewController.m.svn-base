//
//  CorrectWrongViewController.m
//  Do The Math
//
//  Created by Rogier Slag on 10/1/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "GameViewController.h"
#import "CorrectWrongViewController.h"
#import "CorrectWrong.h"
#import "AchievementManager.h"

@interface CorrectWrongViewController ()
@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
@property (weak, nonatomic) CorrectWrong *question;
@property (nonatomic) BOOL answer;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UIButton *correctButton;
@property (weak, nonatomic) IBOutlet UIButton *wrongButton;
@property (weak, nonatomic) IBOutlet UIButton *tryLaterButton;
@end

@implementation CorrectWrongViewController
@synthesize backgroundView = _backgroundView;
@synthesize textLabel = _textLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.expressionLabel.text = self.question.question;
    self.backgroundView.image = [UIImage imageNamed:@"achtergrond.png"];
    [Appearance setLabelFont:self.textLabel];
    [Appearance setLabelFont:self.expressionLabel];
    [self.textLabel setText:NSLocalizedString(@"RIGHT_OR_WRONG", @"Right or wrong title")];
}

/*
 * The Correct button was clicked
 * (as the button which says correct)
 */
- (IBAction)correctButtonClick:(id)sender {
    if ( self.view.userInteractionEnabled == NO ) {
        DLog(@"Kutding");
        return;
    }
    [self.view setUserInteractionEnabled:NO];
    
    self.question.yourAnswer = @"true";
    self.question.yourAnswerCorrect = [NSNumber numberWithBool:[self.question.answer isEqualToString:@"true"]];
    [self.delegate userAnswer:[self.question.yourAnswerCorrect boolValue]];
}

/*
 * The Wrong button was clicked
 * (as the button which says wrong)
 */
- (IBAction)wrongButtonClick:(id)sender {
    if ( self.view.userInteractionEnabled == NO ) {
        DLog(@"Kutding");
        return;
    }
    [self.view setUserInteractionEnabled:NO];
    
    self.question.yourAnswer = @"false";
    self.question.yourAnswerCorrect = [NSNumber numberWithBool:[self.question.answer isEqualToString:@"false"]];
    [self.delegate userAnswer:[self.question.yourAnswerCorrect boolValue]];
}

- (IBAction)tryLaterButtonClick:(id)sender {
    if ( self.view.userInteractionEnabled == NO ) {
        DLog(@"Kutding");
        return;
    }
    [self.view setUserInteractionEnabled:NO];
    [self.delegate tryLater];
}

/*
 * Sets the question in this MVC and sets all relevant values
 */
- (void) setQuestion:(Question *)question
{
    // Deactivate the buttons
    [self.view setUserInteractionEnabled:NO];
    
    _question = (CorrectWrong*) question;
    
    [self translateExpression:self.expressionLabel loadNew:^{
        self.expressionLabel.text =  _question.question;
        if ([_question.answer isEqualToString:@"true"]) {
            self.answer = YES;
        } else {
            self.answer = NO;
        }
    } completion:^{
               
        // Reactivate the buttons
        [self.view setUserInteractionEnabled:YES];
        
    }];

}

- (void)viewDidUnload {
    [self setExpressionLabel:nil];
    [self setCorrectButton:nil];
    [self setWrongButton:nil];
    [self setBackgroundView:nil];
    [self setTextLabel:nil];
    [self setCorrectButton:nil];
    [self setWrongButton:nil];
    [super viewDidUnload];
    [self setTryLaterButton:nil];
}
@end
