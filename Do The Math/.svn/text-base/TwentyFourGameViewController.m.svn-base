//
//  TwentyFourGameViewController.m
//  dothemath
//
//  Created by Innovattic 1 on 10/8/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "TwentyFourGameViewController.h"
#import "TwentyFour+Functions.h"
#import "TwentyFourButton.h"

@interface TwentyFourGameViewController ()
{
    TwentyFour *_twentyFourQuestion;
    TwentyFourButton *_currentNumber;
    NSString *_currentOperator;
    NSMutableArray *_buttons;
}
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *tryLaterButton;
@property (weak, nonatomic) IBOutlet UIButton *eraseButton;

@end

@implementation TwentyFourGameViewController
@synthesize buttonsView = _buttonsView;
@synthesize titleLabel = _titleLabel;

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
    [Appearance setLabelFont:self.titleLabel];
    [Appearance setStyleButton:self.eraseButton];
    [self.titleLabel setText:NSLocalizedString(@"MAKE_24", @"Make 24")];
    [self.eraseButton setTitle:NSLocalizedString(@"ERASE", @"Erase button 24") forState:UIControlStateNormal];
    self.eraseButton.titleLabel.transform= CGAffineTransformMakeRotation(0.24 * M_PI);
    [self prepare];
}

- (void)prepare {
    [[self.buttonsView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton* toedeloe = (UIButton *)obj;
        [toedeloe removeFromSuperview];
         }];
    _currentNumber = nil;
    _currentOperator = nil;
    
    float width = 100;
    float height = 83;
       
    _buttons = [[NSMutableArray alloc] init];
    TwentyFourButton *button1 = [[TwentyFourButton alloc] initWithFrame:CGRectMake(0, 0, width, height) type:1];
    TwentyFourButton *button2 = [[TwentyFourButton alloc] initWithFrame:CGRectMake(width+1, 0, width, height) type:2];
    TwentyFourButton *button3 = [[TwentyFourButton alloc] initWithFrame:CGRectMake(0, height-5, width, height) type:3];
    TwentyFourButton *button4 = [[TwentyFourButton alloc] initWithFrame:CGRectMake(width+1, height, width, height) type:4];
    button1.value = [_twentyFourQuestion.number1 intValue];
    button2.value = [_twentyFourQuestion.number2 intValue];
    button3.value = [_twentyFourQuestion.number3 intValue];
    button4.value = [_twentyFourQuestion.number4 intValue];
    
    [button1 addTarget:self action:@selector(didSelectNumber:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(didSelectNumber:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(didSelectNumber:) forControlEvents:UIControlEventTouchUpInside];
    [button4 addTarget:self action:@selector(didSelectNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttons addObject:button1];[_buttons addObject:button2];[_buttons addObject:button3];[_buttons addObject:button4];
    [self.buttonsView addSubview:button1];
    [self.buttonsView addSubview:button2];
    [self.buttonsView addSubview:button3];
    [self.buttonsView addSubview:button4];
    
	// Do any additional setup after loading the view.
}


-(void)didSelectNumber:(TwentyFourButton *)button {
    if ( self.view.userInteractionEnabled == NO ) {
        DLog(@"Kutding");
        return;
    }
    
    if(_currentNumber && _currentOperator && button != _currentNumber) {
        // if there is already a number selected and a operator.
        
        [self.view setUserInteractionEnabled:NO];
        
        //make the equation
        NSString *equation = @"(";
        if([_currentNumber.equation isEqualToString:@""]) {
            equation = [equation stringByAppendingFormat:@"%d",_currentNumber.value];
        } else {
            equation = [equation stringByAppendingString:_currentNumber.equation];
        }
        equation = [equation stringByAppendingFormat:@"%@",_currentOperator];
        if([button.equation isEqualToString:@""]) {
            equation = [equation stringByAppendingFormat:@"%d",button.value];
        } else {
            equation = [equation stringByAppendingString:button.equation];
        }
        equation = [equation stringByAppendingString:@")"];
        //evaluate the equation
        BOOL valid = YES;
        if([_currentOperator isEqualToString:@"/"]) {
            //cannot divide by zero
            if(button.value == 0) {
                valid = NO;
            } else {
                if (_currentNumber.value % button.value != 0)  {
                    //check if its a whole number if the operator is "/", otherwise do nothing
                    valid = NO;
                }
            }
            
        }
        
        if(!valid) {
            [self.view setUserInteractionEnabled:YES];
            return;
        }
        
        NSExpression *expr = [NSExpression expressionWithFormat:equation];
        double solution = [[expr expressionValueWithObject:nil context:nil] doubleValue];
            
        [_buttons removeObject:_currentNumber];
        [UIView animateWithDuration:0.1f animations:^{
            button.value = solution;
            button.equation = equation;
            CGRect frame = button.frame;
            _currentNumber.frame = frame;
        } completion:^(BOOL finished) {
            [_currentNumber removeFromSuperview];
            _currentNumber = nil;
            _currentOperator = nil;
            [self checkAnswer];
            [self.view setUserInteractionEnabled:YES];
            [self didSelectNumber:button];
        }];
    } else {
        _currentNumber = button;
        _currentOperator = nil;
        //DLog(@"Number selected: %d",button.value);
        [self selectButton:button];
    }
}

-(void)checkAnswer {
    if([_buttons count] == 1) {
        TwentyFourButton *lastButton = (TwentyFourButton *) [_buttons objectAtIndex:0];
        if(lastButton.value == 24) {
            _twentyFourQuestion.yourAnswer = [NSString stringWithFormat:@"%d",(int)lastButton.value];
            _twentyFourQuestion.yourAnswerCorrect = [NSNumber numberWithInt:1];
            [self.delegate userAnswer:YES];
        } else {
            _twentyFourQuestion.yourAnswer = [NSString stringWithFormat:@"%d",(int)lastButton.value];
            _twentyFourQuestion.yourAnswerCorrect = [NSNumber numberWithInt:0];
            [self.delegate userAnswer:NO];
        }
    }
}

-(void)selectButton:(TwentyFourButton *)buttonToSelect {
    //deselect first all buttons
    [_buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TwentyFourButton *currentButton = (TwentyFourButton *)obj;
        [currentButton deselectPostIt];
    }];
    //select the right button
    [buttonToSelect selectPostIt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setButtonsView:nil];
    [self setTitleLabel:nil];
    [self setTryLaterButton:nil];
    [self setEraseButton:nil];
    [super viewDidUnload];
}

- (IBAction)tryLater:(id)sender {
    if ( self.view.userInteractionEnabled == NO ) {
        DLog(@"Kutding");
        return;
    }
    
    [self.view setUserInteractionEnabled:NO];
    [self.delegate tryLater];
}

/*
 * User click on a operand
 */
- (IBAction)didSelectOperand:(UIButton*)sender {
    //DLog(@"Operand selected: %@",sender.titleLabel.text);
    _currentOperator = sender.titleLabel.text;
}

/**
 * Set the current twentyFourQuestion
 */
- (void) setQuestion:(Question *)question {
    _twentyFourQuestion = (TwentyFour *) question;
    
    // Deactivate the buttons
    [self.view setUserInteractionEnabled:NO];
    
    _twentyFourQuestion = (TwentyFour*) question;
    
    [self translateExpression:self.buttonsView loadNew:^{
        [self prepare];
    } completion:^{
        // Reactivate the buttons
        [self.view setUserInteractionEnabled:YES];
    }];
}

// Erase what has been done
- (IBAction)eraseButtonClicked:(id)sender {
    // Dit is een tijdelijke animatie
    
    // Wat er moet gebeuren is dat de blaadjes terugvloeien naar hun oude positie
    // En de equations die erin staan moeten weer naar ""
    // Ook moeten de blaadjes weer op de oorspronkelijke getallen.
    [self setQuestion:_twentyFourQuestion];
}

@end
