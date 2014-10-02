//
//  OperatorsViewController.m
//  dothemath
//
//  Created by Rogier Slag on 27/11/2012.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "OperatorsViewController.h"
#import "Operators+Functions.h"
#import "Question+Functions.h"
#import "DrawOperatorsExpression.h"

@interface OperatorsViewController() {
    Operators *_question;
    DrawOperatorsExpression *_expressionDrawer;
    BOOL _first;
}

@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *expressionView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *tryLaterButton;

@end

@implementation OperatorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _first = YES;
    self.backgroundImage.image = [UIImage imageNamed:@"operatoren invullenachtergrond.png"];
    _expressionDrawer = [[DrawOperatorsExpression alloc] initWithView:self.expressionView];
    [Appearance setLabelFont:self.expressionLabel];
    [self.expressionLabel setText:NSLocalizedString(@"FILL_IN", @"Fill in the operators title")];

    [_expressionDrawer setExpression:_question.expression];
}

- (IBAction)operatorEntered:(UIButton*)sender {
    if ( self.view.userInteractionEnabled == NO ) {
        DLog(@"Kutding");
        return;
    }
    [self.view setUserInteractionEnabled:NO];
    
    if ( sender.tag == 1 ) {
        [_expressionDrawer addOperator:@"+"];
    } else if ( sender.tag == 2 ) {
        [_expressionDrawer addOperator:@"-"];
    } else if (sender.tag == 3) {
        [_expressionDrawer addOperator:@"*"];
    } else if (sender.tag == 4) {
        [_expressionDrawer addOperator:@"/"];
    } else {
        // FAIL
        DLog(@"No know operator pressed: %d",sender.tag);
    }
    [self checkAnswer];
}

-(void)checkAnswer
{
    NSMutableArray *operators = [_expressionDrawer getCurrentSolution]; //array met operator die nu staan.
    for (int i = 0; i < [operators count]; i++) {
        if([[operators objectAtIndex:i] isKindOfClass:[NSNull class]]) {
            [self.view setUserInteractionEnabled:YES];
            return; //nog niet alles ingevuld
        }
    }
    
    NSMutableString* solution = [NSMutableString string];
    for (int index=0; index < [operators count]; index++) {
        [solution appendString:[NSString stringWithFormat:@"%@",[operators objectAtIndex:index]]];
    }
    //DLog(@"Own Solution: %@, Correct:%@",solution,_question.solution);
    _question.yourAnswer = solution;

    NSString *exp = _question.expression;
    for(NSString *operator in operators) {
        NSRange range = [exp rangeOfString:@"."];
        exp = [exp stringByReplacingCharactersInRange:range withString:operator];
    }
    //DLog(@"Expression: %@",exp);
    NSExpression *expr = [NSExpression expressionWithFormat:exp];
    int eval = [[expr expressionValueWithObject:nil context:nil] intValue];
    //DLog(@"Eval: %d",eval);
    
    if(eval == [_question.answer intValue]) {
        _question.yourAnswerCorrect = [NSNumber numberWithInt:1];
        [self.delegate userAnswer:YES];
    } else {
        _question.yourAnswerCorrect = [NSNumber numberWithInt:0];
        [self.delegate userAnswer:NO];
    }
}

- (void) setQuestion:(Question *)question {
    _question = (Operators*)question;

    [self.view setUserInteractionEnabled:NO];
    //laat de vraag nog zien voor 1 seconde
    if(_first) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(prepareQuestion:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    } else {
        [self prepareQuestion:self];
        DLog(@"Got called: %@",_first?@"true":@"false");
    }
    
    
}

-(void)prepareQuestion:(id)sender {
    [self translateExpression:self.expressionView loadNew:^{
        [_expressionDrawer setExpression:[NSString stringWithFormat:@"%@= %@",_question.expression,_question.answer]];
    } completion:^{
        // Reactivate the buttons
        [self.view setUserInteractionEnabled:YES];
    }];
}


- (IBAction)tryLater:(id)sender {
    if ( self.view.userInteractionEnabled == NO ) {
        DLog(@"Kutding");
        return;
    }
    [self.view setUserInteractionEnabled:NO];
    
    [self.delegate tryLater];
}


- (void)viewDidUnload {
    [self setExpressionLabel:nil];
    [self setBackgroundImage:nil];
    [self setExpressionLabel:nil];
    [self setExpressionView:nil];
    [self setButtonsView:nil];
    [self setTryLaterButton:nil];
    [super viewDidUnload];
}


@end
