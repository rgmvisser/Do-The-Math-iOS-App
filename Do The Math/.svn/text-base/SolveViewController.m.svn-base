//
//  SolveViewController.m
//  dothemath
//
//  Created by Rogier Slag on 10/4/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "SolveViewController.h"
#import "Solve+Functions.h"


@interface SolveViewController ()
@property (weak,nonatomic) Solve *question;
@property (nonatomic) int answer;
@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
@property (nonatomic) int userAnswer;
@property (weak, nonatomic) IBOutlet UILabel *userAnswerLabel;
@property (nonatomic) BOOL userIsEnteringANumber;
@property (nonatomic) BOOL userAnswerIsNegative;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UIView *calculatorView;
@property (weak, nonatomic) IBOutlet UIButton *tryLaterButton;

@end

@implementation SolveViewController
@synthesize question = _question;
@synthesize answer = _answer;
@synthesize userAnswer = _userAnswer;
@synthesize userIsEnteringANumber = _userIsEnteringANumber;

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
    [self.textLabel setText:NSLocalizedString(@"SOLVE", @"Solve title")];
    self.userIsEnteringANumber = NO;
    self.expressionLabel.text = [NSString stringWithFormat:@"%@ =",self.question.question ];
	// Do any additional setup after loading the view.
    self.backgroundImage.image = [UIImage imageNamed:@"calculator.png" ];
    
    [Appearance setLabelFont:self.expressionLabel];
    [Appearance setLabelFont:self.textLabel];
    self.userAnswerLabel.font = [UIFont fontWithName:@"DS-Digital" size:self.userAnswerLabel.font.pointSize];
}

/**
 * Init with a question given from the main vc
 */
- (void) setQuestion:(Question *)question
{
    // Deactivate the buttons
    [self.view setUserInteractionEnabled:NO];
    _question = (Solve *) question;
    
    [self translateExpression:self.expressionLabel loadNew:^{
        self.expressionLabel.text = [NSString stringWithFormat:@"%@ =",_question.question];
        self.userIsEnteringANumber = NO;
        self.userAnswer = 0;
        self.userAnswerLabel.text = [NSString stringWithFormat:@"%d",0];
        self.answer = [_question.answer integerValue];
        self.userAnswerIsNegative = NO;
    } completion:^{
               
        // Reactivate the buttons
        [self.view setUserInteractionEnabled:YES];
        
    }];
    
}

- (void)viewDidUnload {
    [self setExpressionLabel:nil];
    [self setUserAnswerLabel:nil];
    [self setBackgroundImage:nil];
    [self setTextLabel:nil];
    [self setCalculatorView:nil];
    [self setTryLaterButton:nil];
    [super viewDidUnload];
}

/**
 * Clear pressed, set everything on 0 and clear UI
 */
- (IBAction)clearPressed:(id)sender {
    self.userIsEnteringANumber = NO;
    self.userAnswer = 0;
    self.userAnswerLabel.text = [NSString stringWithFormat:@"%d",0];
    self.userAnswerIsNegative = NO;
}

/**
 * Digit is pressed, add to the current answer, and update view
 */
- (IBAction)digitPressed:(UIButton *)sender {
    int digit = sender.tag;
    
    self.userAnswer = self.userAnswer*10+digit;
    if ( self.userAnswerIsNegative ) //if negative add - sign
        self.userAnswerLabel.text = [NSString stringWithFormat:@"-%d",self.userAnswer];
    else
        self.userAnswerLabel.text = [NSString stringWithFormat:@"%d",self.userAnswer];
}
- (IBAction)tryLaterButtonClicked:(id)sender {
    if ( self.view.userInteractionEnabled == NO ) {
        DLog(@"Kutding");
        return;
    }
    [self.view setUserInteractionEnabled:NO];
    
    [self.delegate tryLater];
}

/**
 * User pressed enter, check if answer is right and let the main vc know there is an answer
 */
- (IBAction)enterPressed:(id)sender {
    if ( self.view.userInteractionEnabled == NO ) {
        DLog(@"Kutding");
        return;
    }
    [self.view setUserInteractionEnabled:NO];
    
    if ( self.userAnswerIsNegative)
        self.userAnswer  *= -1;
    
    self.question.yourAnswer = [NSString stringWithFormat:@"%d",self.userAnswer];
    self.question.yourAnswerCorrect = [NSNumber numberWithBool:self.answer == self.userAnswer];
    [self.delegate userAnswer:[self.question.yourAnswerCorrect boolValue]];
}

/**
 * User pressed minus, toggle the minus sign in front of the current answer
 */
- (IBAction)minusPressed:(id)sender {
    self.userAnswerIsNegative = !self.userAnswerIsNegative;
    if ( self.userAnswerIsNegative )
        self.userAnswerLabel.text = [NSString stringWithFormat:@"-%d",self.userAnswer];
    else
        self.userAnswerLabel.text = [NSString stringWithFormat:@"%d",self.userAnswer];
}


@end
