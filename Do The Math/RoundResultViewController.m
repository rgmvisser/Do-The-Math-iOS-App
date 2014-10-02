//
//  RoundResultViewController.m
//  dothemath
//
//  Created by Innovattic 1 on 11/21/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "RoundResultViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Round+Functions.h"
#import "Appearance.h"
#import "GameResultViewController.h"
#import "UILabelCounter.h"
#import "User+Functions.h"
#import "RankManager.h"
#import "Game+Functions.h"
#import "SoundController.h"
#import "GADInterstitialDelegate.h"
#import "GADInterstitial.h"
#import "DTMTableViewController.h"
#import "PremiumVersionViewController.h"


@interface RoundResultViewController () <GADInterstitialDelegate>
{
    Round *_round;
    NSNumber *_currentXp;
    NSNumber *_newXP;
    CGFloat _progress;
    CGFloat _targetProgress;
    CGFloat _steps;
    NSTimer *_timer;
    GADInterstitial* _admob;
    BOOL _adLoaded;
    NSTimer* _adDownloadTimer;
    BOOL _ownAdShown;
    UIBarButtonItem *_continue;
}
@property (weak, nonatomic) IBOutlet UILabel *labelNumberCorrectAnswers;
@property (weak, nonatomic) IBOutlet UILabel *labelScore;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeBonus;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalScore;


@property (weak, nonatomic) IBOutlet UILabel *numberCorrectAnswers;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *timeBonus;
@property (weak, nonatomic) IBOutlet UILabel *totalScore;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *addSign;

@property (weak, nonatomic) IBOutlet UILabel *previousXpLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextXpLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextXp;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *currentXpLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentXpNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

@end

@implementation RoundResultViewController

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
    
    [self setTitle:NSLocalizedString(@"ROUND_RESULT", @"Round result title")];
    [self.labelNumberCorrectAnswers setText:NSLocalizedString(@"NUM_ANSWER_CORRECT", @"Number answers correct: label")];
    [self.labelScore setText:NSLocalizedString(@"SCORE", @"Score: label")];
    [self.labelTimeBonus setText:NSLocalizedString(@"TIME_BONUS", @"Time bonus: label")];
    [self.labelTotalScore setText:NSLocalizedString(@"TOTAL", @"Total: label")];
    [self.continueButton setTitle:NSLocalizedString(@"CONTINUE", @"Continue label")];
    _ownAdShown = NO;
    _adLoaded = NO;
    //[Appearance setResultNavigationBar:self.navigationController];
    _continue = self.navigationItem.rightBarButtonItem;
    [self enableContinue:NO];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.backgroundView setImage:[UIImage imageNamed:@"result_background_2.jpg"]];
    
    [Appearance setLabelFont:self.labelNumberCorrectAnswers];
    [Appearance setLabelFont:self.labelScore];
    [self.labelScore setTextColor:UIColorFromRGB(COLOR_ORANJE)];
    [Appearance setLabelFont:self.labelTimeBonus];
    [self.labelTimeBonus setTextColor:UIColorFromRGB(COLOR_RED)];
    [Appearance setLabelFont:self.labelTotalScore];
    [Appearance setLabelFont:self.addSign];
    [Appearance setLabelFont:self.score];
    [self.score setTextColor:UIColorFromRGB(COLOR_ORANJE)];
    [Appearance setLabelFont:self.numberCorrectAnswers];
    [Appearance setLabelFont:self.timeBonus];
    [self.timeBonus setTextColor:UIColorFromRGB(COLOR_RED)];
    [Appearance setLabelFont:self.totalScore];
    [Appearance setLabelFont:self.nextXpLabel];
    [Appearance setLabelFont:self.nextXp];
    [Appearance setLabelFont:self.previousXpLabel];
    [Appearance setLabelFont:self.currentXpLabel];
    [Appearance setLabelFont:self.currentXpNameLabel];

    [self loadAd];
    
    User *user = [User currentUser];
    _currentXp = user.experience;
    [self setProgressBarWithXP:_currentXp animated:NO];
    [self.currentXpLabel setText:[NSString stringWithFormat:@"%@",_currentXp]];
    DLog(@"Current xp: %@",_currentXp);
    if(_round)
    {
        NSNumber *numCorrectAnswers = [NSNumber numberWithInt:[_round getCorrectAnswers]];
        NSNumber *score = [NSNumber numberWithInt:[_round getYourScore]];
        NSNumber *timeBonus = _round.yourTimeBonus;
        NSNumber *totalScore = [_round getTotalRoundScore];
        DLog(@"Correct:%@, Score:%@, timebonus: %@, total: %@",numCorrectAnswers,score,timeBonus,totalScore);
        UILabelCounter *counter = [[UILabelCounter alloc] init];
        [counter animateUILabel:self.numberCorrectAnswers from:[NSNumber numberWithInt:0] to:numCorrectAnswers duration:500 delay:200 completion:^{
            [counter animateUILabel:self.score from:[NSNumber numberWithInt:0] to:score duration:800 delay:200 completion:^{
                [counter animateUILabel:self.timeBonus from:[NSNumber numberWithInt:0] to:timeBonus duration:800 delay:200 completion:^{
                    [counter animateUILabel:self.totalScore from:[NSNumber numberWithInt:0] to:totalScore duration:500 delay:200 completion:^{
                        
                        
                        //add xp to user
                        
                        _newXP = [NSNumber numberWithInt:[_currentXp intValue] + [totalScore intValue]];
                        
                        user.experience = _newXP;                       
                        NSError *error;
                        [[user managedObjectContext] save:&error];
                        [self setProgressBarWithXP:_newXP animated:YES];
                        
                        [self enableContinue:YES];
                        
                    }];
                }];
            }];
        }];
    } else {
        DLog(@"No round set!");
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No round found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
        NSException* myException = [NSException
                                    exceptionWithName:@"No Round Found"
                                    reason:@"No round is set"
                                    userInfo:nil];
        @throw myException;
    }
    
    
    
	// Do any additional setup after loading the view.
}

-(void) setRound:(Round *)round{
    _round = round;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)continue:(id)sender {
    DLog(@"continue");
    
    if([[User currentUser] isPremium])
    {
        [self continueToResults];        
    }else{
        
    
        // First set a modal push to ads. Which can be dismissed after 5 seconds
        if ( _adLoaded && _admob.hasBeenUsed == NO ) {
            NSLog(@"continue admob");
            [_admob presentFromRootViewController:self];
        } else if ( !_ownAdShown){
            NSLog(@"continue house ad");
            _ownAdShown = YES;
            [self performSegueWithIdentifier:@"showOwnAd" sender:self];
        } else {
            NSLog(@"continue results");
            [self continueToResults];
        }
    }
}

-(void) continueToResults {

    __block GameResultViewController *gameResultVC;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[GameResultViewController class]])
        {
            gameResultVC = (GameResultViewController *)obj;
        }
    }];
    
    if(gameResultVC)
    {
        [self.navigationController popToViewController:gameResultVC animated:YES];
    }else{
        //no difficulty found
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Result controller found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
        NSException* myException = [NSException
                                    exceptionWithName:@"ViewController not found"
                                    reason:@"Result view controller is not in stack navigation controller"
                                    userInfo:nil];
        @throw myException;
        
    }

}

- (void)viewDidUnload {
    [self setRankImageView:nil];
    [self setNumberCorrectAnswers:nil];
    [self setScore:nil];
    [self setTimeBonus:nil];
    [self setTotalScore:nil];
    [self setLabelNumberCorrectAnswers:nil];
    [self setLabelScore:nil];
    [self setLabelTimeBonus:nil];
    [self setLabelTotalScore:nil];
    [self setPreviousXpLabel:nil];
    [self setNextXpLabel:nil];
    [self setContinueButton:nil];
    [self setCurrentXpLabel:nil];
    [self setCurrentXpNameLabel:nil];
    [self setProgressView:nil];
    [self setAddSign:nil];
    [self setBackgroundView:nil];
    [self setNextXp:nil];
    [super viewDidUnload];
}

- (void)setProgressBarWithXP:(NSNumber *)xp animated:(BOOL)animated
{
    NSNumber *currentRankXp = [[RankManager shared] getCurrentRankExperienceWithExperience:_currentXp];
    NSNumber *nextRankXp = [[RankManager shared] getNextRankExperienceWithExperience:_currentXp];
    NSString *currentRankName = [[RankManager shared] getCurrentRankNameWithExperience:_currentXp];
    NSString *nextRankName = [[RankManager shared] getNextRankNameWithExperience:_currentXp];
    self.previousXpLabel.text = [NSString stringWithFormat:@"%@",currentRankName];
    self.nextXpLabel.text = [NSString stringWithFormat:@"%@",nextRankName];
    self.nextXp.text = [NSString stringWithFormat:@"%@",nextRankXp];
    //DLog(@"Current: %@(%@), next: %@(%@)",currentRankName,currentRankXp,nextRankName,nextRankXp);
    int beginXp = [currentRankXp intValue];
    int endXp = [nextRankXp intValue];
    int difference = endXp - beginXp;
    CGFloat progress = (float)( [xp intValue] - beginXp) / difference ;
    if(progress >= 1)
    {
        progress = 1;
    }
    _steps = (progress - _progress) / 70;
    
    if(animated)
    {
        _targetProgress = progress;
        _timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(animateProgress) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode: NSDefaultRunLoopMode];
        [self drawProgressBar];
    }
    else{
        _progress = progress;
        [self drawProgressBar];
    }
}

-(void)nextLevel
 {
     [[SoundController shared] playLevelUp];
     NSNumber *nextRankXp = [[RankManager shared] getNextRankExperienceWithExperience:_currentXp];
     _currentXp = nextRankXp;
     [self setProgressBarWithXP:nextRankXp animated:NO];
     [self setProgressBarWithXP:_newXP animated:YES];
 }


-(void)animateProgress
{
    //DLog(@"Target: %f, Progress: %f",_targetProgress,_progress);
    if(_targetProgress <= _progress)
    {
        [_timer invalidate];
        if(_progress >= 1)
        {
            [self nextLevel];
        }
        else{ //set correct xp level (bug, sometimes it was 1 to less or many)
            [self.currentXpLabel setText:[NSString stringWithFormat:@"%@",_newXP]];
        }
        
    }
    else{
        
        [self drawProgressBar];
        _progress = _progress + _steps;
    }
}


-(void)drawProgressBar
{
    
    
    CGSize imageSize = self.progressView.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIImage imageNamed:@"rankingbar_filled.png"] drawAtPoint:CGPointMake(0, 0)];
    
    CGContextSetRGBFillColor(ctx, 1, 0, 0, 0);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceIn);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(imageSize.width /2,imageSize.height / 2)];
    
    //begin = M_PI * 0.62
    //einde = M_PI * 2.39
    //verschil = 1.77
    CGFloat progess = 0.621 + (1.77 *_progress);
    [path addArcWithCenter:CGPointMake(imageSize.width /2,imageSize.height / 2) radius:imageSize.width / 2 startAngle:M_PI * 0.62 endAngle:M_PI * progess clockwise:NO];
    
    
    CGContextAddPath(ctx, [path CGPath]);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.progressView.image = result;
    
    //DLog(@"Progress: %f",_progress);
    //DLog(@"TargetXP: %@",[[RankManager shared] getNextRankExperienceWithExperience:_currentXp]);
    //DLog(@"Total: %d",(int) (_progress * [[[RankManager shared] getNextRankExperienceWithExperience:_currentXp] intValue]));
    int difference  = [[[RankManager shared] getNextRankExperienceWithExperience:_currentXp] intValue] - [[[RankManager shared] getCurrentRankExperienceWithExperience:_currentXp] intValue];
    int part = (int)difference * _progress;
    
    self.currentXpLabel.text = [NSString stringWithFormat:@"%d",[[[RankManager shared] getCurrentRankExperienceWithExperience:_currentXp] intValue] + part];
    
}

#pragma admob

- (void) loadAd {
    if ( [self shouldShowInterstitial] ) {
        _admob = [[GADInterstitial alloc] init];
        [_admob setDelegate:self];
        _admob.adUnitID = AdMob_ID;
    
        GADRequest *r = [[GADRequest alloc] init];
        [_admob loadRequest:r];
    }
}

- (BOOL) shouldShowInterstitial {
    if ( [[User currentUser] isPremium] ) {
        return NO;
    }
    int x = rand() % 2;
    if ( x != 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void) enableContinue:(BOOL)boolean {
    if ( boolean ) {
        self.navigationItem.rightBarButtonItem = _continue;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma admob delegate

- (void) interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    DLog(@"Hmm: %@",error.localizedDescription);
    _adLoaded = NO;
}

- (void) interstitialDidReceiveAd:(GADInterstitial *)ad {
    _adLoaded = YES;
}

- (void) interstitialDidDismissScreen:(GADInterstitial *)ad {
    [self performSegueWithIdentifier:@"showOwnAd" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"showOwnAd"]) {

        UINavigationController *nav = segue.destinationViewController;
        PremiumVersionViewController *pvc = (PremiumVersionViewController *)nav.topViewController;
        pvc.delegate = self;
        pvc.withTimer = YES;
    }
    
    
}

@end
