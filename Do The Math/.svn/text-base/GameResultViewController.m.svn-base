//
//  GameResultViewController.m
//  Do The Math
//
//  Created by Innovattic 1 on 10/1/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "GameResultViewController.h"
#import "MainGameViewController.h"
#import "Game+Functions.h"
#import "User+Functions.h"
#import "Opponent+Functions.h"
#import "Round+Functions.h"
#import "Appearance.h"
#import <RestKit/RestKit.h>
#import "RankManager.h"
#import "UIImageView+dynamicLoad.h"
#import "DifficultyView.h"
#import "ScoreBarView.h"
#import "FriendController.h"
#import "FriendSearch.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SoundController.h"
#import "PostToFacebookViewController.h"
#import "Flurry.h"
#import "HomeViewController.h"
#import "AchievementManager.h"
#import "UIAlertView+BlockExtensions.h"
@interface GameResultViewController ()
{
    int _maxScore;
    UIBarButtonItem* _RightBarButton;
    FriendSearch *_requestFriend;
    UIButton *_inviteButton;
}


@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextRoundButton;
@property (weak, nonatomic) IBOutlet UILabel *playerOneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerOneAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *playerTwoAvatar;
@property (weak, nonatomic) IBOutlet UILabel *playerTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScorePlayerOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScorePlayerTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankPlayerOne;
@property (weak, nonatomic) IBOutlet UILabel *rankPlayerTwo;
@property (weak, nonatomic) IBOutlet DifficultyView *difficultyView;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scoreBar;
@property (weak, nonatomic) IBOutlet UIImageView *opponentScoreBar;
@property (weak, nonatomic) IBOutlet UIImageView *playerOneWins;
@property (weak, nonatomic) IBOutlet UIImageView *playerTwoWins;
@property (retain, nonatomic) Game *game;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityOIndicator;
@property (weak, nonatomic) IBOutlet UIButton *pokeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareOnFacebookButton;
@property (weak, nonatomic) IBOutlet UILabel *shareOnFB;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation GameResultViewController


@synthesize game = _game;
@synthesize playerOneLabel = _playerOneLabel;
@synthesize playerOneAvatar = _playerOneAvatar;
@synthesize playerTwoAvatar = _playerTwoAvatar;
@synthesize playerTwoLabel = _playerTwoLabel;





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
    
    
    [Appearance setLabelFont:self.playerOneLabel];
    [Appearance setLabelFont:self.playerTwoLabel];
    [Appearance setLabelFont:self.totalScorePlayerOneLabel];
    [Appearance setLabelFont:self.totalScorePlayerTwoLabel];
    [Appearance setLabelFont:self.rankPlayerOne];
    [Appearance setLabelFont:self.rankPlayerTwo];
    [Appearance setLabelFont:self.playerOneLabel];
    [Appearance setLabelFont:self.difficultyLabel];
    [Appearance setLabelFont:self.turnLabel];
    [Appearance setLabelFont:self.shareOnFB];
    [Appearance setStyleButton:self.pokeButton];
    [Appearance setStyleButton:self.startButton];
    
    [self setTitle:NSLocalizedString(@"RESULTS", @"Results title")];
    [self.startButton setTitle:NSLocalizedString(@"START", @"Start button") forState:UIControlStateNormal];
    [self.pokeButton setTitle:NSLocalizedString(@"POKE", @"Poke button") forState:UIControlStateNormal];
    [self.shareOnFB setText:NSLocalizedString(@"SHARE", @"Share on fb")];
    [self.difficultyLabel setText:NSLocalizedString(@"LEVEL", @"Level")];
    
    
    self.game = [Game currentGame];
    DLog(@"currentgame: %@",self.game);
    User *user = [User currentUser];
    self.playerOneLabel.text = user.username;
    self.playerTwoLabel.text = self.game.opponent.username;
    self.totalScorePlayerOneLabel.text = @"";
    self.totalScorePlayerTwoLabel.text = @"";
    self.turnLabel.text = @"";
    
    [self.playerOneWins setAlpha:0];
    [self.playerTwoWins setAlpha:0];
    [self.playerOneAvatar setDynamicImage:user.id avatarId:user.avatar];
    [self.playerTwoAvatar setDynamicImage:self.game.opponent.opponentId avatarId:self.game.opponent.avatar];
    [self.difficultyView setDifficulty:self.game.difficulty withLabel:NO];
    _inviteButton = [[FriendController shared] friendInviteButton];
    [_inviteButton addTarget:self action:@selector(inviteFriend:) forControlEvents:UIControlEventTouchUpInside];
    [_inviteButton setHidden:YES];
    [self.playerTwoAvatar setUserInteractionEnabled:YES];
    [self.playerTwoAvatar addSubview:_inviteButton];
    if(![[FriendController shared] isFriend:self.game.opponent.opponentId])
    {
        [_inviteButton setHidden:NO];
    }
    
    [self.backgroundImage setImage:[UIImage imageNamed:@"result_background_2.jpg"]];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.game.gameId forKey:@"gameId"];
    [Flurry logEvent:@"Open game results" withParameters:dict];
}

- (void) drawScores {
    //reset first all subviews
    [self.activityOIndicator startAnimating];
    [self.turnLabel setText:@""];
    for(UIView *view in self.scoreBar.subviews)
    {
        [view removeFromSuperview];
    }
    //reset first all subviews
    for(UIView *view in self.opponentScoreBar.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self.activityOIndicator startAnimating];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/match/%d",[self.game.gameId intValue]] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects){
            [self.activityOIndicator stopAnimating];
            [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                self.game = (Game *) obj;
                //DLog(@"Game: %@", self.game);
                
            }];
            [self setScores];
        };
        
        loader.onDidFailWithError = ^(NSError *error){
            DLog(@"Error failed to load game results:%@",error.localizedDescription);
            [self.activityOIndicator stopAnimating];
            [self setScores];
        };
        
    }];
    [[RKObjectManager sharedManager] getObject:[User currentUser] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadResponse = ^(RKResponse *response) {
            if(response.statusCode == 200)
            {
                DLog(@"User updated");
            }
            
        };
        
        loader.onDidFailLoadWithError = ^(NSError *error) {
            DLog(@"Failed to update user");
        };
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    _RightBarButton = self.nextRoundButton;
    self.navigationItem.rightBarButtonItem = nil;
    [super viewWillAppear:animated];
    [self drawScores];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawScores) name:[NSString stringWithFormat:@"com.innovattic.dothemath.push.match.%d",[self.game.gameId intValue]] object:nil];

    _RightBarButton = self.nextRoundButton;
    self.navigationItem.rightBarButtonItem = nil;
    [super viewWillAppear:animated];
    //[Appearance setResultNavigationBar:self.navigationController];
    
   self.rankPlayerOne.text = [[RankManager shared] getCurrentRankNameWithExperience:[User currentUser].experience];
    self.rankPlayerTwo.text = [[RankManager shared] getCurrentRankNameWithExperience:self.game.opponent.experience];
}


- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) setScores
{
    int yourTotalScore = 0;
    int theirTotalScore = 0;
    int currentRoundNumber = [self.game.currentRoundNumber intValue];
    if(currentRoundNumber != 0) // alleen laten zien als er al een ronde is gespeeld
    {
        
        NSMutableArray *ownScore = [[NSMutableArray alloc] init];
        NSMutableArray *theirScore = [[NSMutableArray alloc] init];
        int roundNumber = 0;
        for(Round *round in self.game.rounds)
        {
            roundNumber++;
            if([round played])
            {
                int yourRoundScore = [[round getTotalRoundScore] intValue];
                [ownScore addObject:[NSNumber numberWithInt:yourRoundScore]];
                yourTotalScore += yourRoundScore;
                if(currentRoundNumber != roundNumber || ![self.game.status isEqualToString:_WAIT])
                {
                    int theirRoundScore = [[round getTheirTotalRoundScore] intValue];
                    [theirScore addObject:[NSNumber numberWithInt:theirRoundScore]];
                    theirTotalScore += theirRoundScore;
                }
            }
        }
        if(yourTotalScore > theirTotalScore)
        {
            _maxScore = yourTotalScore;
        }
        else{
            _maxScore = theirTotalScore;
        }
        
        [self setScores:self.scoreBar score:ownScore];
        [self setScores:self.opponentScoreBar score:theirScore];
        [self.totalScorePlayerOneLabel setText:[NSString stringWithFormat:@"%d %@",yourTotalScore,NSLocalizedString(@"POINTS", @"Points, weergeven in resultaten scherm")]];
        [self.totalScorePlayerTwoLabel setText:[NSString stringWithFormat:@"%d %@",theirTotalScore,NSLocalizedString(@"POINTS", @"Points, weergeven in resultaten scherm")]];
        
    }
    
    
    //only enable the next round button when it is your turn
    if([self.game.status isEqualToString:_TURN])
    {
        [self.turnLabel setText:NSLocalizedString(@"ITS_YOUR_TURN", @"Je bent aan de beurt")];
        [self.pokeButton setHidden:YES];
        [self.pokeButton setEnabled:NO];
        [self.startButton setHidden:NO];
        [self.startButton setEnabled:YES];
        [self.shareOnFacebookButton setHidden:YES];
        [self.shareOnFacebookButton setEnabled:NO];
        [self.shareOnFB setHidden:YES];
        self.navigationItem.rightBarButtonItem = _RightBarButton;
    }
    else if([self.game.status isEqualToString:_WAIT])
    {
        [self.pokeButton setHidden:NO];
        [self.pokeButton setEnabled:YES];
        [self.startButton setHidden:YES];
        [self.startButton setEnabled:NO];
        [self.shareOnFacebookButton setHidden:YES];
        [self.shareOnFacebookButton setEnabled:NO];
        [self.shareOnFB setHidden:YES];
        [self.turnLabel setText:NSLocalizedString(@"WAITING_FOR_OPPONENT", @"Je tegenstander is aan de beurt")];
    }
    else if ( [self.game.status isEqualToString:_COMPLETE] ) {
        
        // Set the revanche button
        UIBarButtonItem *revancheButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"REVANCHE", @"Revanche button in game result") style:UIBarButtonItemStyleBordered target:self action:@selector(startRevanche:)];
        self.navigationItem.rightBarButtonItem = revancheButton;
        
        // Show the "Share on Facebook Button"
        [self.pokeButton setHidden:YES];
        [self.pokeButton setEnabled:NO];
        [self.startButton setHidden:YES];
        [self.startButton setEnabled:NO];
        [self.shareOnFacebookButton setHidden:NO];
        [self.shareOnFacebookButton setEnabled:YES];
        [self.shareOnFB setHidden:NO];
        // Show summary
        UIImageView *winner;
        NSString *resultText;
        if([self.game.result isEqualToString:@"won"])
        {
            winner = self.playerOneWins;
            resultText = NSLocalizedString(@"YOU_WON", @"Je hebt gewonnen!");
            
        }else if([self.game.result isEqualToString:@"lost"]){
            winner = self.playerTwoWins;
            resultText = NSLocalizedString(@"YOU_LOST", @"Je hebt verloren!");
        }
        else if([self.game.result isEqualToString:@"draw"]){
            //no winner
            resultText = NSLocalizedString(@"DRAW_GAME", @"Het is een gelijk spel!");
        }else{
            //no winner
            resultText = NSLocalizedString(@"DECLINED_GAME", @"Het spel is verlopen.");
        }
        DLog(@"Check wins/played");
        [[AchievementManager shared] checkNumberOfGamesPlayed];
        
        [UIView animateWithDuration:1.0 delay:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if(winner)
            {
                [winner setAlpha:1];
                if(winner == self.playerOneWins)
                {
                    [[SoundController shared] playGameWon];
                }
            }
            
        } completion:^(BOOL finished) {
            if(resultText)
            {
                [self.turnLabel setText:resultText];
            }
        }];
        
        
        
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [_requestFriend removeObserver:self forKeyPath:@"invited"];
    [self setPlayerOneLabel:nil];
    [self setPlayerTwoLabel:nil];
    [self setPlayerOneAvatar:nil];
    [self setPlayerTwoAvatar:nil];
    [self setTotalScorePlayerOneLabel:nil];
    [self setTotalScorePlayerTwoLabel:nil];

    [self setNextRoundButton:nil];
    [self setBackgroundImage:nil];
    [self setRankPlayerOne:nil];
    [self setRankPlayerTwo:nil];
    [self setDifficultyView:nil];
    [self setDifficultyLabel:nil];
    [self setScoreBar:nil];
    [self setOpponentScoreBar:nil];
    [self setPlayerOneWins:nil];
    [self setPlayerTwoWins:nil];
    [self setTurnLabel:nil];
    [self setActivityOIndicator:nil];
    [self setPokeButton:nil];
    [self setShareOnFacebookButton:nil];
    [self setStartButton:nil];
    [self setShareOnFB:nil];
    [super viewDidUnload];
}


- (IBAction)playNextRound:(id)sender {
}

/**
 * Update the view with game scores
 */
-(void)setScores:(UIView *)scoreBar score:(NSMutableArray *)score
{
    
    //int maxScore = [[self.game maxScorePossible] intValue];
    int maxScore = (int)(_maxScore * 1.3);
    ScoreBarView *firstRound = [[ScoreBarView alloc] initWithFrame:scoreBar.bounds];
    [firstRound addScoreBarImage:[UIImage imageNamed:@"scorebar_red.png"]];
    
    ScoreBarView *secondRound = [[ScoreBarView alloc] initWithFrame:scoreBar.bounds];
    [secondRound addScoreBarImage:[UIImage imageNamed:@"scorebar_orange.png"]];
    
    ScoreBarView *thirdRound = [[ScoreBarView alloc] initWithFrame:scoreBar.bounds];
    [thirdRound addScoreBarImage:[UIImage imageNamed:@"scorebar_yellow.png"]];
    //views toevoegen aan bar
    [scoreBar addSubview:thirdRound];
    [scoreBar addSubview:secondRound];
    [scoreBar addSubview:firstRound];
    CGSize barSize = scoreBar.frame.size;
    
    CGFloat minimumY = barSize.height * 0.9;
    if(maxScore > 0)
    {
        int currentScore = 0;
        if([score count] > 0)
        {
            currentScore += [[score objectAtIndex:0] intValue];
            double firstRoundPrecentage = (double) currentScore  / maxScore;
            CGFloat y = (barSize.height * (1-firstRoundPrecentage))-8;
            if(y > minimumY)
            {
                y = minimumY;
            }
            UILabel *scoreRoundOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(barSize.width, y , 60, 20)];
            [scoreRoundOneLabel setText:[NSString stringWithFormat:@"- %d",[[score objectAtIndex:0] intValue]]];
            [Appearance setLabelFont:scoreRoundOneLabel];
            [scoreRoundOneLabel setTextColor:UIColorFromRGB(COLOR_RED)];
            [scoreRoundOneLabel setBackgroundColor:[UIColor clearColor]];
            [scoreRoundOneLabel setAlpha:0];
            [scoreBar addSubview:scoreRoundOneLabel];            
            
            [firstRound setPresentage:firstRoundPrecentage withLabel:scoreRoundOneLabel animated:YES];
        }
        if([score count] > 1)
        {
            currentScore += [[score objectAtIndex:1] intValue];
            double secondRoundPrecentage = (double) currentScore / maxScore;
            CGFloat y = (barSize.height * (1-secondRoundPrecentage))-8;
            if(y > minimumY)
            {
                y = minimumY;
            }
            minimumY -= 20;
            UILabel *scoreRoundTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(-60, y, 60, 20)];
            [scoreRoundTwoLabel setText:[NSString stringWithFormat:@"%d -",[[score objectAtIndex:1] intValue]]];
            [Appearance setLabelFont:scoreRoundTwoLabel];
            [scoreRoundTwoLabel setTextAlignment:NSTextAlignmentRight];
            [scoreRoundTwoLabel setTextColor:UIColorFromRGB(COLOR_ORANJE)];
            [scoreRoundTwoLabel setBackgroundColor:[UIColor clearColor]];
            [scoreRoundTwoLabel setAlpha:0];
            [scoreBar addSubview:scoreRoundTwoLabel];
            
            //wachten tot de eerst klaar is
            [secondRound setDelay:0.5];
            [secondRound setPresentage:secondRoundPrecentage withLabel:scoreRoundTwoLabel animated:YES];
        }
        if([score count] > 2)
        {
            currentScore += [[score objectAtIndex:2] intValue];
            double thirdRoundPrecentage = (double) currentScore / maxScore ;
            CGFloat y = (barSize.height * (1-thirdRoundPrecentage))-8;
            if(y > minimumY)
            {
                y = minimumY;
            }
            minimumY -= 20;
            UILabel *scoreRoundThreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(barSize.width, y , 60, 20)];
            [scoreRoundThreeLabel setText:[NSString stringWithFormat:@"- %d",[[score objectAtIndex:2] intValue]]];
            [Appearance setLabelFont:scoreRoundThreeLabel];
            [scoreRoundThreeLabel setTextColor:UIColorFromRGB(COLOR_YELLOW)];
            [scoreRoundThreeLabel setBackgroundColor:[UIColor clearColor]];
            [scoreRoundThreeLabel setAlpha:0];
            [scoreBar addSubview:scoreRoundThreeLabel];
            
            //wachten tot de 2e klaar is
            [thirdRound setDelay:1.0];
            [thirdRound setPresentage:thirdRoundPrecentage withLabel:scoreRoundThreeLabel animated:YES];
        }

    }
    
    
    
}
/**
 * Seque to the Main Game controller if the nextRound button is pressed
 * Set the current round, the main game controller has to deal with
 */
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"nextRound"])
    {
        MainGameViewController *mainGameVC = (MainGameViewController*)segue.destinationViewController;
        mainGameVC.round = [self.game currentRound];
    }
}

- (void)startRevanche:(id)sender {
    [Flurry logEvent:@"Start revanche"];
    if([HomeViewController canPlayGame])
    {
        RKClient *client = [RKClient sharedClient];
        [client post:[NSString stringWithFormat:@"/match/invite/%@/difficulty/%d",self.game.opponent.opponentId,[self.game.difficulty intValue]] usingBlock:^(RKRequest *request) {
            request.onDidLoadResponse = ^(RKResponse *response) {
                if(response.statusCode == 200)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"GAME_REVANCHE_SEND", @"Game revanche send") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
                    [alert show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    DLog(@"Failed to revanche for game:%@",response);
                }
            };
            
            request.onDidFailLoadWithError = ^(NSError *error) {
                DLog(@"Request failed to revanche for game:%@",error);
            };
            
        }];
    }else{
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPGRADE_TO_PREMIUM", @"Upgrade to premium account") message:NSLocalizedString(@"MAX_GAMES_REACHED", @"U can only play x games in the free verion, please upgrade for more features and a ad free game.") completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView) {
            if(buttonIndex == 1)
            {
                
                [self performSegueWithIdentifier:@"showOwnAd" sender:self];
            }
        } cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:NSLocalizedString(@"BUY", "Koop"),nil];
        [alertview show];
    }
}

// If a game is in progress a user can send a poke. This can be done every x hours (server determines this)
// After a poke was send the button is disabled and the text in the button indicates a successfull poke
- (IBAction)sendPoke:(id)sender {
    // Do a server request to send the poke
    [[RKClient sharedClient] post:[NSString stringWithFormat:@"/user/%d/poke",[self.game.opponent.opponentId intValue]] usingBlock:^(RKRequest *request) {
        request.onDidLoadResponse = ^(RKResponse *response) {
            if(response.statusCode == 403) {
                // The poke is disallowed (cant poke too much)
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"POKE_FAILURE", @"Je kunt niet zovaak iemand poken") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil] show];
            } else if ( response.statusCode == 200 ) {
                // The poke was successfull. Set the text indicating this
                [self.pokeButton setTitle:NSLocalizedString(@"POKED", @"Je hebt iemand gepoked button") forState:UIControlStateDisabled];
                [self.pokeButton setEnabled:NO];
            } else {
                // An unexpected error occured, Log
                DLog(@"Error while poking %d",response.statusCode);
                
            }
        };
        
        // Something failed in the request
        request.onDidFailLoadWithError = ^(NSError *error) {
            DLog(@"Request failed to poke :%@",error);
        };
    }];
}

/**
 * Invite a opponent if he is not yet your friend
 */
-(void)inviteFriend:(id)sender
{
    _requestFriend = [FriendSearch new];
    _requestFriend.id = self.game.opponent.opponentId;
    [_requestFriend addObserver:self forKeyPath:@"invited" options:NSKeyValueObservingOptionNew context:nil];
    [[FriendController shared] inviteForFriendRequest:_requestFriend];
}

- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if ([keyPath isEqual:@"invited"]) {
        // do something with the changedName - call a method or update the UI here
        [_inviteButton setHidden:YES];
    }

}

- (IBAction)startButton:(id)sender {
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.game.currentRound.type forKey:@"gametype"];
    [dict setObject:self.game.difficulty forKey:@"difficulty"];

    DLog(@"Dict: %@",dict);
    [Flurry logEvent:@"Start game" withParameters:dict];
    DLog(@"Start!");
    //[self.startButton setHidden:YES];
}

// After a round is finished a user has the option to share the result on Facebook.
// After pressing the button a FB dialog is opened, where he may enter some text
// accompaning his result. The result is then posted to his wall
- (IBAction)shareOnFacebookButtonClicked:(id)sender {
    // Initialize the Facebook session
    
    
    if([[User currentUser] isFacebookUser])
    {
        [PostToFacebookViewController shareScoreOnFacebook: [NSString stringWithFormat:NSLocalizedString(@"FB_SHARED_ON_WALL", @"Message to share on own wall"),self.game.opponent.username,[self.totalScorePlayerOneLabel.text intValue],[self.totalScorePlayerTwoLabel.text intValue]] sender:self];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"NO_FACEBOOK_USER", @"Current user is not a facebook user, please connect") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
        [alert show];
        
    }
    
}

#pragma mark fbsession delegate methods

// Handle the publish feed call back
- (void)dialogCompleteWithUrl:(NSURL *)url {
    NSDictionary *params = [self parseURLParams:[url query]];
    NSString *msg = [NSString stringWithFormat:
                     @"Posted story, id: %@",
                     [params valueForKey:@"post_id"]];
    DLog(@"%@", msg);
    // Show the result in an alert
    [[[UIAlertView alloc] initWithTitle:@"Result"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}


@end

