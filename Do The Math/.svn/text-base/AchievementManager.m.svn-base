//
//  AchievementManager.m
//  dothemath
//
//  Created by Rogier Slag on 14/12/2012.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "AchievementManager.h"
#import <GameKit/GameKit.h>
#import "Question+Functions.h"
#import "RankManager.h"
#import "User+Functions.h"
#import "SoundController.h"

//Achievement IDs
#define AQuestion10  @"com.innovattic.dothemath.question10"
#define AQuestion10Spree  @"com.innovattic.dothemath.question10spree"
#define ARound1      @"com.innovattic.dothemath.1round"
#define ARound2      @"com.innovattic.dothemath.2round"
#define AGame1       @"com.innovattic.dothemath.3round"
#define AQuestion3_10 @"com.innovattic.dothemath.3questions.10sec"
#define Afailure     @"com.innovattic.dothemath.allwrong"
#define AFacebookShare     @"com.innovattic.dothemath.fbshare"
#define AFacebookInvite     @"com.innovattic.dothemath.fbinvite"
#define ATweet     @"com.innovattic.dothemath.tweet"
#define AGame50 @"com.innovattic.dothemath.game50"
#define AGame100 @"com.innovattic.dothemath.game100"
#define AGame250 @"com.innovattic.dothemath.game250"
#define AGame500 @"com.innovattic.dothemath.game500"
#define AWon50 @"com.innovattic.dothemath.won50"
#define AWon100 @"com.innovattic.dothemath.won100"
#define AWon250 @"com.innovattic.dothemath.won250"
#define AWon500 @"com.innovattic.dothemath.won500"
#define A5Friends @"com.innovattic.dothemath.5friends"

@implementation AchievementManager {
    int _questionCorrectSpree;
    int _questionCorrectRound;
    NSDate *_timeAnsweredQuestion;
    NSMutableArray *_questionsTime;    
    NSMutableArray* _questions;
    Game* _game;
    int _roundNumber;
    
    // Achievements
    GKAchievement* _aQuestion10;
    GKAchievement* _aQuestion10Spree;
    GKAchievement* _aRound1;
    GKAchievement* _aRound2;
    GKAchievement* _aGame1;
    GKAchievement* _aQuestion3_10;
    GKAchievement* _aFailure;
    GKAchievement* _aFacebookShare;
    GKAchievement* _aFacebookInvite;
    GKAchievement* _aTweet;
    
    GKAchievement* _aGame50;
    GKAchievement* _aGame100;
    GKAchievement* _aGame250;
    GKAchievement* _aGame500;
    
    GKAchievement* _aWon50;
    GKAchievement* _aWon100;
    GKAchievement* _aWon250;
    GKAchievement* _aWon500;
    
    GKAchievement* _a5Friends;
    
    NSMutableDictionary *_achievementData;
    
}
static AchievementManager *_manager = nil;

# pragma Lifecycle


+(AchievementManager *)shared {
    if(!_manager) {
        _manager = [[AchievementManager alloc] init];
    }
    return _manager;
}

- (AchievementManager*) init {
    self = [super init];   
    return self;
}

- (BOOL)isLoggedIn {
    return [GKLocalPlayer localPlayer].authenticated;
}

-(void)loginGameCenter {
    if([GameCenterManager isGameCenterAvailable]) {
        [self initAchievements];
		self.gameCenterManager= [[GameCenterManager alloc] init];
		[self.gameCenterManager setDelegate: self];
		[self.gameCenterManager authenticateLocalUser];
	}
}

-(void)loadAchievementData{
    
    _achievementData = [[NSUserDefaults standardUserDefaults] objectForKey:@"achievements"];
    if(!_achievementData)
    {
        _achievementData = [[NSMutableDictionary alloc] init];
    }
}

-(void)saveAchievementData{
    
    if(_achievementData)
    {
        [[NSUserDefaults standardUserDefaults] setObject:_achievementData forKey:@"achievements"];
    }

}


/**
 * Init all achievements
 */
- (void) initAchievements {
    // Add the achievements
    
    _aQuestion10 = [[GKAchievement alloc] initWithIdentifier:AQuestion10];    
    _aQuestion10Spree = [[GKAchievement alloc] initWithIdentifier:AQuestion10Spree];
    
    _aRound1 = [[GKAchievement alloc] initWithIdentifier:ARound1];
    _aRound2 = [[GKAchievement alloc] initWithIdentifier:ARound2];
    _aGame1 = [[GKAchievement alloc] initWithIdentifier:AGame1];
    
    _aQuestion3_10 = [[GKAchievement alloc] initWithIdentifier:AQuestion3_10];
    
    _aFailure = [[GKAchievement alloc] initWithIdentifier:Afailure];
    
    _aFacebookInvite = [[GKAchievement alloc] initWithIdentifier:AFacebookInvite];
    _aFacebookShare = [[GKAchievement alloc] initWithIdentifier:AFacebookShare];
    _aTweet = [[GKAchievement alloc] initWithIdentifier:ATweet];
    
    _aGame50 = [[GKAchievement alloc] initWithIdentifier:AGame50];
    _aGame100 = [[GKAchievement alloc] initWithIdentifier:AGame100];
    _aGame250 = [[GKAchievement alloc] initWithIdentifier:AGame250];
    _aGame500 = [[GKAchievement alloc] initWithIdentifier:AGame500];
    
    _aWon50 = [[GKAchievement alloc] initWithIdentifier:AWon50];
    _aWon100 = [[GKAchievement alloc] initWithIdentifier:AWon100];
    _aWon250 = [[GKAchievement alloc] initWithIdentifier:AWon250];
    _aWon500 = [[GKAchievement alloc] initWithIdentifier:AWon500];
    
    _a5Friends = [[GKAchievement alloc] initWithIdentifier:A5Friends];
    
    
}


# pragma Public methods

/**
 * Reset the achievement manager
 */
- (void) resetForGame:(Game*)game roundNumber:(NSNumber*)round {
    _questionCorrectRound = 0;
    _questionCorrectSpree = 0;
    _questions = [[NSMutableArray alloc] init];
    _questionsTime = [[NSMutableArray alloc] init];
    _roundNumber = [round intValue];
    _timeAnsweredQuestion = [[NSDate alloc] init];
    _game = game;
}


/**
 * Check if there is an achievement is achieved
 */
- (void) checkQuestionForAchievement:(Question*)question {
    if(![self isLoggedIn]){
        return;
    }
    [_questions addObject:question];
    //DLog(@"De am heeft iets gekregen: %@",([question.yourAnswerCorrect boolValue])?@"TRUE":@"FALSE");
    NSDate *now = [[NSDate alloc] init];
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:_timeAnsweredQuestion];
    _timeAnsweredQuestion = now;
    
    if ( ![question.yourAnswerCorrect boolValue] ) {
        _questionCorrectSpree = 0;
        _questionsTime = [[NSMutableArray alloc] init];
        [self checkFailureAchievement];
        return;
    } else {
        _questionCorrectSpree++;
        _questionCorrectRound++;
        [self checkQuestion10Achievement];
        [self checkQuestion10SpreeAchievement];
        [self check3questions10sec:timeInterval];
    }    
}

/**
 * Check if there is an achievement is achieved
 */
- (void) roundComplete:(Game*)game {
    if(![self isLoggedIn]){
        return;
    }
    [self checkRound1Achievemen:game];
    [self checkRound2Achievement:game];
    [self checkGameCorrectAchievement:game];
    
}

/**
 * Check the count of games, wins and loses
 */
- (void) checkNumberOfGamesPlayed{
    if(![self isLoggedIn]){
        return;
    }
       
    
    int wins = [[[User currentUser] wins] intValue];
    int losses = [[[User currentUser] losses] intValue];
    int draws = [[[User currentUser] draws] intValue];
    int total = wins + losses+ draws;
    DLog(@"Total: %d, wins: %d",total,wins);
    if (!_aGame50.completed && total >= 50 ) {
        
        _aGame50.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aGame50.identifier percentComplete: _aGame50.percentComplete];
    }
    
    if (!_aGame100.completed && total >= 100 ) {
        
        _aGame100.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aGame100.identifier percentComplete: _aGame100.percentComplete];
    }
    
    if (!_aGame250.completed && total >= 250 ) {
        
        _aGame250.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aGame250.identifier percentComplete: _aGame250.percentComplete];
    }    
    
    if (!_aGame500.completed && total >= 500 ) {
        
        _aGame500.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aGame500.identifier percentComplete: _aGame500.percentComplete];
    }

    if (!_aWon50.completed && wins >= 50 ) {
        
        _aWon50.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aWon50.identifier percentComplete: _aWon50.percentComplete];
    }
    
    if (!_aWon100.completed && wins >= 100 ) {
        
        _aWon100.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aWon100.identifier percentComplete: _aWon100.percentComplete];
    }
    
    if (!_aWon250.completed && wins >= 250 ) {
        
        _aWon250.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aWon250.identifier percentComplete: _aWon250.percentComplete];
    }
    
    if (!_aWon500.completed && wins >= 500 ) {
        
        _aWon500.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aWon500.identifier percentComplete: _aWon500.percentComplete];
    }   
    
}


-(NSArray *)achievementsList {
    return self.gameCenterManager.achievementDescriptions;
}

-(NSDictionary *)earndedAchievementList {
    return self.gameCenterManager.earnedAchievementCache;
}



# pragma Private methods

/**
 * Achievement is submitted
 */
-(void)achievementSubmitted:(GKAchievement *)achievement error:(NSError *)error {
    DLog(@"Achievement!!! %@",achievement);
    [[SoundController shared] playAchievement];
    [self notifyDelegateForAchievement:achievement];
}


/**
 * Notify the game controler that an achievement is achieved
 */
- (void) notifyDelegateForAchievement:(GKAchievement*)achievement {
    [self.delegate achievementUnlocked:achievement];
}


# pragma Achievement methods


-(void)friends:(int)friends{
    if(![self isLoggedIn]){
        return;
    }
    if (_a5Friends.completed) {
        return;
    }
    
    if(friends >= 5)
    {
        _a5Friends.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_a5Friends.identifier percentComplete: _a5Friends.percentComplete];
    }  
    
}

- (void) faceBookInvite{
    if(![self isLoggedIn]){
        return;
    }
    if (_aFacebookInvite.completed) {
        return;
    }
    _aFacebookInvite.percentComplete = 100.0;
    [self.gameCenterManager submitAchievement:_aFacebookInvite.identifier percentComplete: _aFacebookInvite.percentComplete];
}

-(void) faceBookShare{
    if(![self isLoggedIn]){
        return;
    }
    if (_aFacebookShare.completed) {
        return;
    }
    _aFacebookShare.percentComplete = 100.0;
    [self.gameCenterManager submitAchievement:_aFacebookShare.identifier percentComplete: _aFacebookShare.percentComplete];
}

-(void) tweet{
    
    if(![self isLoggedIn]){
        return;
    }
    if (_aTweet.completed) {
        return;
    }
    _aTweet.percentComplete = 100.0;
    [self.gameCenterManager submitAchievement:_aTweet.identifier percentComplete: _aTweet.percentComplete];
    
}


- (void) checkFailureAchievement {
    if ( _aFailure.completed ) {
        // Niet nog eens halen
        return;
    }
    int failures = [[[[_game rounds] objectAtIndex:_roundNumber] questions] count];
    if ( failures != [_questions count]) {
        // Ongelijk vragen aantal. Dus kan nooit allemaal al fout zijn
        return;
    }
    for ( Question* q in _questions) {
        if ([q.yourAnswerCorrect boolValue]) {
            // Goed antwoord. Kan nooit allemaal fout zijn
            return;
        }
    }
    // Nomnomnom je hebt alles fout
    _aFailure.percentComplete = 100.0;
    [self.gameCenterManager submitAchievement:_aFailure.identifier percentComplete: _aFailure.percentComplete];
}





- (void) checkQuestion10Achievement {
    if ( _aQuestion10.completed) {
        return;
    }
    
    if ( _questionCorrectRound == 10 ) {
        _aQuestion10.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aQuestion10.identifier percentComplete: _aQuestion10.percentComplete];
    }
}


- (void) checkQuestion10SpreeAchievement {
    if ( _aQuestion10Spree.completed) {
        return;
    }
    
    if ( _questionCorrectSpree == 10 ) {
        _aQuestion10Spree.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aQuestion10Spree.identifier percentComplete: _aQuestion10Spree.percentComplete];
    }
}

- (BOOL) checkAllQuestionsInGame:(Game *)game forRound:(int)roundNumber {
    Round *round = [game.rounds objectAtIndex:roundNumber-1];
    for (Question *question in round.questions) {
        DLog(@"Question correct: %d",[question.yourAnswerCorrect boolValue]);
        if(![question.yourAnswerCorrect boolValue]) {
            return NO; //wrong answer, not every question is correct
        }
    }
    return YES;
}

- (void) checkRound1Achievemen:(Game *)game {
    if ( _aRound1.completed ) {
        // Niet nog eens halen
        return;
    }
    
    BOOL round1correct = [self checkAllQuestionsInGame:game forRound:1];
    BOOL round2correct = [self checkAllQuestionsInGame:game forRound:2];
    BOOL round3correct = [self checkAllQuestionsInGame:game forRound:3];
    if(round1correct || round2correct || round3correct ) {
        _aRound1.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aRound1.identifier percentComplete: _aRound1.percentComplete];
    }
    return;
}

- (void) checkRound2Achievement:(Game *)game {
    if ( _aRound2.completed ) {
        // Niet nog eens halen
        return;
    }
    
    BOOL round1correct = [self checkAllQuestionsInGame:game forRound:1];
    BOOL round2correct = [self checkAllQuestionsInGame:game forRound:2];
    BOOL round3correct = [self checkAllQuestionsInGame:game forRound:3];
    if( ( round1correct && round2correct ) || (round2correct && round3correct) ) {
        _aRound2.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aRound2.identifier percentComplete: _aRound2.percentComplete];
    }
    return;}

- (void) checkGameCorrectAchievement:(Game *)game {
    if ( _aGame1.completed ) {
        // Niet nog eens halen
        return;
    }
    
    BOOL round1correct = [self checkAllQuestionsInGame:game forRound:1];
    BOOL round2correct = [self checkAllQuestionsInGame:game forRound:2];
    BOOL round3correct = [self checkAllQuestionsInGame:game forRound:3];
    if(round1correct && round2correct && round3correct) {
        _aGame1.percentComplete = 100.0;
        [self.gameCenterManager submitAchievement:_aGame1.identifier percentComplete: _aGame1.percentComplete];
    }
    return;
}

- (void) check3questions10sec:(NSTimeInterval)timeInterval{
    if(_aQuestion3_10.completed) {
        //already done
        return;
    }
    
    if(_questionCorrectSpree > 2) {
        [_questionsTime addObject:[NSNumber numberWithDouble:timeInterval]];
        if([_questionsTime count] >= 3) {
            double total = 0;
            for (int i = 1; i < 4 ; i++) {
                NSNumber *time = [_questionsTime objectAtIndex:[_questionsTime count]-i];
                total += [time doubleValue];
            }
            DLog(@"Total: %f", total);
            if(total <= 10.0) {
                // Nomnomnom je 3 goed in 10 seconde
                _aQuestion3_10.percentComplete = 100.0;
                [self.gameCenterManager submitAchievement:_aQuestion3_10.identifier percentComplete: _aQuestion3_10.percentComplete];
            }
            
        }
    }
    
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController{
	[viewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)resetAchievements {
    [self.gameCenterManager resetAchievements];
}


@end
