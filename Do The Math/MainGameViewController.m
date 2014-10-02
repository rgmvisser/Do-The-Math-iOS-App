//
//  MainGameViewController.m
//  Do The Math
//
//  Created by Rogier Slag on 9/27/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "MainGameViewController.h"
#import "CorrectWrongViewController.h"
#import "SolveViewController.h"
#import "Question+Functions.h"
#import "Round+Functions.h"
#import <RestKit/RestKit.h>
#import "Game+Functions.h"
#import "GameViewController.h"
#import "SolveGameResult.h"
#import "CorrectWrongGameResult.h"
#import "TwentyFourGameResult.h"
#import "BadgeManager.h"
#import "RoundResultViewController.h"
#import "TwentyFourGameViewController.h"
#import "OperatorsViewController.h"
#import "OperatorsGameResult.h"
#import "AchievementManager.h"
#import <QuartzCore/QuartzCore.h>
#import "SoundController.h"
#import "LoadingView.h"
#import "SBJson.h"
#import "UIAlertView+BlockExtensions.h"
#import "ConnectionManager.h"
#import "Flurry.h"

@interface MainGameViewController () <UIAlertViewDelegate>
{
    int _readyToShowResults;
    UIView *_loadingView;
}
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (weak, nonatomic) IBOutlet UIView *timeRemaningView;
@property (weak, nonatomic) IBOutlet UIImageView *timeBarView;
@property (weak, nonatomic) IBOutlet UIImageView *questionBar;
@property (strong,nonatomic) GameViewController* gameVC;
@property (nonatomic) int timeRemaining;
@property (nonatomic) int score;
@property (nonatomic) int currentQuestion;
@property (nonatomic) int questionAnsweredLeft;
@property (nonatomic) NSDate *timeSinceQuestionStarted;
@property (weak, nonatomic) IBOutlet UILabel *timeIndicator;



@end

@implementation MainGameViewController
@synthesize timeRemaining = _timeRemaining;
@synthesize score = _score;
@synthesize gameView = _gameView;
@synthesize currentQuestion = _currentQuestion;
@synthesize round = _round;
@synthesize questionAnsweredLeft = _questionAnsweredLeft;
@synthesize timeSinceQuestionStarted = _timeSinceQuestionStarted;
@synthesize timeRemaningView,questionBar;
@synthesize gameVC = _gameVC;


NSTimer *_timer;
NSDate *_startTime;

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
    _readyToShowResults = 0;
    //init The manager
    self.currentQuestion = 0;
    self.questionAnsweredLeft = [self.round.questions count];
    CALayer *layer = [self.timeRemaningView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10];
    [self.timeIndicator setFont:[UIFont fontWithName:[Appearance getFont] size:19.0f]];
    
    
    [self showSeperators];
    //check if there are unanswered questions
    if(self.questionAnsweredLeft <= 0)
    {
        [self allQuestionsAnswered]; //all questions are
    }
    else{
        GameViewController *theGame = [self getGame:self.round.type];
        self.gameVC = theGame;
        theGame.delegate = self;
        [theGame setQuestion:[self.round.questions objectAtIndex:self.currentQuestion]];
        [self addChildViewController:theGame];
        [self.gameView addSubview:theGame.view];
        // Set the frame to coincide with the next views, this prevents strange transition movements.
        theGame.view.frame = CGRectMake(0, 0, self.gameView.frame.size.width, self.gameView.frame.size.height);
    }

}

// Starts the timer as soon as the view appears
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _startTime = [NSDate date];
    NSString *round_key = [NSString stringWithFormat:@"round_started_%@",self.round.roundId];
    DLog(@"Checking round id:%@",round_key);
    if([[NSUserDefaults standardUserDefaults] boolForKey:round_key])
    {
        DLog(@"Cheated!!");
        [self cheated];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:round_key];
        DLog(@"Round_id set! id:%@",round_key);
    }
    
    [self startTimer];
    self.timeSinceQuestionStarted = [NSDate date];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [self setGameView:nil];
    [self setGameView:nil];
    [self setTimeRemaningView:nil];
    [self setQuestionBar:nil];
    [self setTimeBarView:nil];
    [self setTimeIndicator:nil];
    [super viewDidUnload];
}


/**
 * Gets the GameViewcontroller for the current game, function is made for easily adding more game types.
 */
- (GameViewController *) getGame: (NSString *) type
{
    GameViewController *game;
    if([type isEqualToString:_CORRECTWRONG]){
        game = (CorrectWrongViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"correctWrongGame"];
    }
    else if([type isEqualToString:_SOLVE]){
        game = (SolveViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"solveGame"];
    }
    else if([type isEqualToString:_TWENTYFOUR]){
        game = (TwentyFourGameViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"twentyFourGame"];
    }
    else if ([type isEqualToString:_OPERATORS]){
        game = (OperatorsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"operatorsGame"];
    }
    else{
        
    }
    [[AchievementManager shared] resetForGame:_round.game roundNumber:_round.game.currentRoundNumber];
    return game;
}

/**
 * Starts the timer of the round. Repeat every second
 */
- (void) startTimer
{
    [[SoundController shared] playStartRound];
    // Default to 120 seconds
    self.timeRemaining = [self.round.roundTime intValue];
    
    // Set the timer to call the decreaseTimer method every second.
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(decreaseTimer:) userInfo:nil repeats:YES];
    
    // Attach the timer to the currentRunLoop.
    // @TODO: check if this runloop is still reliable under stress
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

/**
 * GameViewController sends a user answer, if correct add 1 to the score.
 * Show next question to user
 */
-(void) userAnswer:(BOOL) answer
{
    if(answer)
    {
        [self goodAnswer];
    }
    else
    {
        [self wrongAnswer];
    }
    [self showAnswer:answer];
    self.questionAnsweredLeft--;
    [[AchievementManager shared] checkQuestionForAchievement:[self.round.questions objectAtIndex:self.currentQuestion]];
    [self nextQuestion];
}

-(void) showAnswer:(BOOL) answer
{
    UIImageView *answerImage;
    if(answer)
    {
        answerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"correct_icon.png"]];
    }
    else{
        answerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wrong_icon.png"]];
    }
    UIImageView *seperator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scorebar_seperator.png"]];
    int totalQuestions = [self.round.questions count];
    int questionsAnswered = totalQuestions - self.questionAnsweredLeft;
    
    CGSize imageSize = answerImage.frame.size;
    CGSize seperatorSize = seperator.frame.size;
    CGFloat totalWidth = self.questionBar.frame.size.width;
    CGFloat emptySpacePerIcon = (totalWidth - (seperatorSize.width * (totalQuestions -1)) - (imageSize.width * totalQuestions))/ totalQuestions;
    
    
    CGFloat padding = emptySpacePerIcon / 2;
    CGFloat currentOriginX = ((imageSize.width+seperatorSize.width+emptySpacePerIcon) * questionsAnswered) + padding;
    CGFloat currentOriginY = 0.0;
    CGRect newSeperatorFrame = CGRectMake(currentOriginX+imageSize.width + padding, 0, seperatorSize.width, seperatorSize.height);
    //if image doesnt fit in the holder
    if(emptySpacePerIcon < 0)
    {
        imageSize.width += emptySpacePerIcon/2;
        imageSize.height += emptySpacePerIcon/2;
        currentOriginY -= emptySpacePerIcon / 2;
        currentOriginX -= emptySpacePerIcon /2;
        
    }
    CGRect newImageFrame = CGRectMake(currentOriginX, currentOriginY, imageSize.width, imageSize.height);
    
    answerImage.frame = newImageFrame;
    seperator.frame = newSeperatorFrame;
    [self.questionBar addSubview:answerImage];    
}

-(void) showSeperators {
    UIImageView *answerImage;
    answerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"correct_icon.png"]];
    UIImageView *seperator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scorebar_seperator.png"]];
    int totalQuestions = [self.round.questions count];
   
    CGSize imageSize = answerImage.frame.size;
    CGSize seperatorSize = seperator.frame.size;
    CGFloat totalWidth = self.questionBar.frame.size.width;
    CGFloat emptySpacePerIcon = (totalWidth - (seperatorSize.width * (totalQuestions -1)) - (imageSize.width * totalQuestions))/ totalQuestions;
    CGFloat padding = emptySpacePerIcon / 2;
    for (int i = 0; i < [self.round.questions count]-1; i++) {
        UIImageView *seperator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scorebar_seperator.png"]];
        CGFloat currentOriginX = ((imageSize.width+seperatorSize.width+emptySpacePerIcon) * i) + padding;
        CGRect newSeperatorFrame = CGRectMake(currentOriginX+imageSize.width + padding, 0, seperatorSize.width, seperatorSize.height);
        seperator.frame = newSeperatorFrame;
        [self.questionBar addSubview:seperator];
    }
    
}
/**
 * User answered right
 */
-(void) goodAnswer
{
    [[SoundController shared] playCorrectAnswer];
    self.score++;
        
}

/**
 * User answered wrong
 */
-(void) wrongAnswer
{
    [[SoundController shared] playWrongAnswer];
    //self.score--;
}




/**
 * Decrease timer, if time is up, call TimeUp
 */
- (void) decreaseTimer:(NSTimer*)timer
{
    self.timeRemaining = [self.round.roundTime intValue] - (int)[[NSDate date] timeIntervalSinceDate:_startTime];
    
    if(self.timeRemaining > [self.round.roundTime intValue])
    {
        DLog(@"Cheated with time!");
        [self cheated];        
    }
    
    
    // Update the timeindicator
    int minutes = MAX(floor(self.timeRemaining/60),0);
    int seconds = MAX(floor(self.timeRemaining%60),0);
    [self.timeIndicator setText:[NSString stringWithFormat:@"%d:%02d",minutes,seconds]];
    
    //three seconds left, play countdown sound
    if(self.timeRemaining == 12)
    {
        [[SoundController shared] playCountdown];
    }
    
    if ( self.timeRemaining < 0 ) {
        [self timeUp];
    }
}

/**
 * Skip question if user pressed the try later button
 */
-(void)tryLater{
    [self nextQuestion];
}


/**
 * Show next question to user
 */
- (void) nextQuestion
{
    [self updateQuestionTimeSpent];
       //check if there are unanswered questions
    if(self.questionAnsweredLeft <= 0)
    {
        [self allQuestionsAnswered]; //all questions are
    }
    else
    {
        self.currentQuestion++;
        //search for next unanswered question
        while([[self.round.questions objectAtIndex:self.currentQuestion] isAnswered])
        {
            self.currentQuestion++;
        }
        
        // Gets a new game vc, set its delegate and the question he must show
        [self.gameVC setQuestion:[self.round.questions objectAtIndex:self.currentQuestion]];
    }
   
}

- (void) updateQuestionTimeSpent
{
    // Set the time spent to the question, and update the nsdate object
    Question *q = [self.round.questions objectAtIndex:self.currentQuestion];
    NSNumber *extra = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:self.timeSinceQuestionStarted]];
    q.yourTimeSpent = [NSNumber numberWithInt:[q.yourTimeSpent intValue] + round([extra doubleValue] * 1000.0)];
    self.timeSinceQuestionStarted = [NSDate date];
    //DLog(@"Time spent on question %d is now %d milliseconds",self.currentQuestion,[q.timeSpent integerValue]);
}

//Override setter of current question, make sure current question is always in array bounds.
-(void) setCurrentQuestion:(int)currentQuestion
{
    int totalQuestions = [self.round.questions count];
    _currentQuestion = (currentQuestion % totalQuestions);
}

// Overridden setter
// Also updates the value in the view
- (void) setScore:(int)score
{
    _score = score;
}

// Overridden setter
// Also updates the value in the view
-(void) setTimeRemaining:(int)timeRemaining
{
    _timeRemaining = timeRemaining;
    // Nog geldige klok
    int minutes = timeRemaining / 60;
    int seconds = timeRemaining % 60;
    
    // Seconds formatter. Handle the special case when seconds < 10 to add an extra zero
    NSString *remaining = [NSString stringWithFormat:@"%d:%d",minutes,seconds];
    if ( seconds < 10 )
        remaining = [NSString stringWithFormat:@"%d:0%d",minutes,seconds];
    
    CGFloat percentage = 1-(((double)_timeRemaining) /((double)[self.round.roundTime intValue]));
    //DLog(@"Percentage: %f",percentage);
    CGFloat width = self.timeBarView.image.size.width;
    CGFloat timeRemaningViewWidth = width*percentage;
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.timeRemaningView.frame = CGRectMake(self.timeRemaningView.frame.origin.x,self.timeRemaningView.frame.origin.y,timeRemaningViewWidth, self.timeRemaningView.frame.size.height);
    } completion:^(BOOL finished) {
            
    }];
}

/**
 * The time is up so stop the round
 */
-(void)timeUp
{
    [self updateQuestionTimeSpent];
    [self.round answerAllUnansweredQuestions];
    [self stopRound];
        // Display message to the user.
    NSString *timeUp = NSLocalizedString(@"TIME_IS_UP", @"The time is up, round is over");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math Title") message:timeUp delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"Ok button") otherButtonTitles:nil];
    [alert show];
}

/**
 * The time is up so stop the round
 */
-(void)cheated
{
    [self.round answerAllUnansweredQuestions];
    [self stopRound];
    // Display message to the user.
    NSString *timeUp = NSLocalizedString(@"CHEATED", @"You cheated!");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math Title") message:timeUp delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"Ok button") otherButtonTitles:nil];
    [alert show];
}

/**
 * All questions are answered, stop the round
 */
-(void)allQuestionsAnswered
{
    [self stopRound];
    // Display message to the user.
    NSString *allQuestionsAnswered = NSLocalizedString(@"ALL_QUESTIONS_ANSWERED", @"All questions are answered, round is over");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math Title") message:allQuestionsAnswered delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"Ok button") otherButtonTitles:nil];
    [alert show];
}

/**
 *Round is over save the data
 */
-(void)stopRound
{
    [_timer invalidate];
    [[SoundController shared] stopCountDown];
    [[SoundController shared] playEndRound];
    [self.round setYourBonus]; //sets the bonus for the current round
    
    //update round information
    self.round.isPlayed = [NSNumber numberWithBool:YES];
    self.round.game.status = _WAIT;
    [[AchievementManager shared] roundComplete:self.round.game];
    //save data to server! Restkit cannot save round, because we use dynamic mapping, restkit does not (yet, in 0.20 it will?) inverse dynamic mapping
    //@TODO: with restkit update, use the inverse dynamic mapping
    NSNumber *score = [NSNumber numberWithInt:[self.round getYourScore]];
    id questionResults;
    if([self.round.type isEqualToString:_SOLVE]){
        
        SolveGameResult *questionResultSolve = (SolveGameResult*)[[SolveGameResult alloc] init];
        questionResultSolve.questions = [[self.round.questions set] allObjects];
        questionResultSolve.timeBonus = self.round.yourTimeBonus;
        questionResultSolve.score = score;
        questionResults = questionResultSolve;
    }
    else if([self.round.type isEqualToString:_CORRECTWRONG]){
        
        CorrectWrongGameResult *questionResultCorrectWrong = (CorrectWrongGameResult*)[[CorrectWrongGameResult alloc] init];
        questionResultCorrectWrong.questions = [[self.round.questions set] allObjects];
        questionResultCorrectWrong.timeBonus = self.round.yourTimeBonus;
        questionResultCorrectWrong.score = score;
        questionResults = questionResultCorrectWrong;
    }
    else if([self.round.type isEqualToString:_TWENTYFOUR]){
        
        TwentyFourGameResult *questionResultTwentyFour = (TwentyFourGameResult*)[[TwentyFourGameResult alloc] init];
        questionResultTwentyFour.questions = [[self.round.questions set] allObjects];
        questionResultTwentyFour.timeBonus = self.round.yourTimeBonus;
        questionResultTwentyFour.score = score;
        questionResults = questionResultTwentyFour;
    }
    else if([self.round.type isEqualToString:_OPERATORS]){
        
        OperatorsGameResult* questionResultOperators = (OperatorsGameResult*)[[OperatorsGameResult alloc] init];
        questionResultOperators.questions = [[self.round.questions set] allObjects];
        questionResultOperators.timeBonus = self.round.yourTimeBonus;
        questionResultOperators.score = score;
        questionResults = questionResultOperators;
    }
    else{
        DLog(@"Type unknown error! %@",self.round.type);
        NSException* unkownTypeException = [NSException
                                    exceptionWithName:@"Type unkown"
                                    reason:@"Game type is unkown"
                                    userInfo:nil];
        [unkownTypeException raise];
        
    }
    _loadingView = [[LoadingView alloc] initInView:self.view withMessage:NSLocalizedString(@"SENDING_RESULTS", @"Bezig met versturen antwoorden..")];
    [self.view addSubview:_loadingView];
    [self sendResults:questionResults];
    
    NSError* error;
    //save the round data
    BOOL saved = [[self.round.game managedObjectContext] save:&error];
    DLog(@"Game saved local: %@",(saved) ? @"YES" : @"NO");
}

- (void)sendResults:(id)results
{
    if([[ConnectionManager shared] isReachable])
    {
        [[RKObjectManager sharedManager] putObject:results usingBlock:^(RKObjectLoader *loader) {
            //loader.timeoutInterval = 3;
            loader.onDidLoadResponse = ^(RKResponse *response){
                NSDictionary *responseBody = [response.bodyAsString JSONValue];
                //NSString *message = [responseBody objectForKey:@"message"];
                DLog(@"response: %@",responseBody);
                DLog(@"Roundid: %@, %d",[NSString stringWithFormat:@"round_started_%@",self.round.roundId],[[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"round_started_%@",self.round.roundId]]);
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"round_started_%@",self.round.roundId]];
                DLog(@"Roundid: %@, %d",[NSString stringWithFormat:@"round_started_%@",self.round.roundId],[[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"round_started_%@",self.round.roundId]]);
                [self showResults];
                [_loadingView setHidden:YES];
                
            };
            loader.onDidFailLoadWithError = ^(NSError *error){
                DLog(@"Failed to load send results, error:%@",error);
            };
            loader.onDidFailWithError = ^(NSError *error){
                DLog(@"Failed to send results, error:%@",error);
                //[self showResults];
                //[_loadingView setHidden:YES];
                if(error.code == -1001)
                {
                    DLog(@"Timeout");
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"OOPS", @"Oeps") message:NSLocalizedString(@"FAILED_TO_SEND_ROUND_RESULTS", @"Failed to send round results try again") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Ok") otherButtonTitles:nil] show];
                    [self sendResults:results];
                }else{
                    DLog(@"Other error");
                }
            
            };
         
            
            
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math Title") message:NSLocalizedString(@"FAILED_TO_SEND_RESULTS", @"Failed to send results of game to server, try again") completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView) {
            DLog(@"Resend!");
            [self sendResults:results];
            
        } cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"RESEND", @"Resend button"),nil] show];
    }
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self showResults];
}


/**
 * Segue to results view, if the user dismissed the alertbox and the data has been send.
 */
-(void)showResults
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.round.type forKey:@"gametype"];
    [dict setObject:self.round.game.difficulty forKey:@"difficulty"];
    
    DLog(@"Dict: %@",dict);
    [Flurry logEvent:@"End game" withParameters:dict];
    DLog(@"Start!");
    
    
    _readyToShowResults++;
    if(_readyToShowResults > 1)
    {
        [self performSegueWithIdentifier:@"showRoundResults" sender:self];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showRoundResults"])
    {
        if([segue.destinationViewController isKindOfClass:[RoundResultViewController class]])
        {
            RoundResultViewController *roundResultVC = (RoundResultViewController *)segue.destinationViewController;
            [roundResultVC setRound:self.round];
        }
    }
}



@end
