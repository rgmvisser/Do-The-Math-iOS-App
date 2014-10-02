//
//  SoundController.m
//  dothemath
//
//  Created by Innovattic 1 on 12/21/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "SoundController.h"
#import <AudioToolbox/AudioToolbox.h>

#define SOUND_ACHIEVEMENT @"achievement"
#define SOUND_CORRECT @"correct"
#define SOUND_WRONG @"wrong"
#define SOUND_COUNTDOWN @"count_down"
#define SOUND_END_ROUND @"round_end"
#define SOUND_START_ROUND @"round_start"
#define SOUND_LEVEL_UP @"levelup"
#define SOUND_GAME_WON @"game_won"

@interface SoundController()
{
    SystemSoundID _achievement;
    SystemSoundID _correctAnswer;
    SystemSoundID _countdown;
    SystemSoundID _endRound;
    SystemSoundID _startRound;
    SystemSoundID _wrongAnswer;
    SystemSoundID _levelUp;
    SystemSoundID _gameWon;
    BOOL _effectsOn;
}

@end

@implementation SoundController

static SoundController *_soundController;

#pragma mark Inits

+(SoundController *)shared {
    if(!_soundController) {
        _soundController = [[SoundController alloc] init];
    }
    return _soundController;
}


- (SoundController*) init {
    self = [super init];
    //get the sound effect settings
    if(![[NSUserDefaults standardUserDefaults] objectForKey:SOUND_EFFECT]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SOUND_EFFECT];
    }

    //Load all sounds
    NSString *achievementPath = [[NSBundle mainBundle] pathForResource:SOUND_ACHIEVEMENT ofType:@"aif"];
	NSURL *achievementUrl = [NSURL fileURLWithPath:achievementPath];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)achievementUrl, &_achievement);
    
    NSString *correctPath = [[NSBundle mainBundle] pathForResource:SOUND_CORRECT ofType:@"aif"];
	NSURL *correctUrl = [NSURL fileURLWithPath:correctPath];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)correctUrl, &_correctAnswer);
    
    NSURL *wrongPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:SOUND_WRONG ofType:@"aif"]];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)wrongPath, &_wrongAnswer);
    
    NSURL *levelUpPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:SOUND_LEVEL_UP ofType:@"aif"]];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)levelUpPath, &_levelUp);
    
    NSURL *startRoundPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:SOUND_START_ROUND ofType:@"aif"]];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)startRoundPath, &_startRound);
    
    NSURL *endRoundPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:SOUND_END_ROUND ofType:@"aif"]];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)endRoundPath, &_endRound);
    
    NSURL *countDownPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:SOUND_COUNTDOWN ofType:@"aif"]];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)countDownPath, &_countdown);
    
    NSURL *gameWonPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:SOUND_GAME_WON ofType:@"aif"]];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)gameWonPath, &_gameWon);
    
    return self;
}

#pragma mark Play sound methods

/**
 * Play a sound, if the sound effects are on
 */
-(void)playSound:(SystemSoundID)soundId
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:SOUND_EFFECT]) {
        AudioServicesPlaySystemSound(soundId);
    }
}

-(void)playAchievement
{
    if(_achievement) {
        [self playSound:_achievement];
    } else {
        DLog(@"Error: Achievement sound not found");
    }
}

-(void)playStartRound
{
    if(_startRound) {
        [self playSound:_startRound];
    } else {
        DLog(@"Error: Start Round sound not found");
    }
}

-(void)playEndRound
{
    if(_endRound) {
        [self playSound:_endRound];
    } else {
        DLog(@"Error: End round sound not found");
    }
}

-(void)playCorrectAnswer
{
    if(_correctAnswer) {
        [self playSound:_correctAnswer];
    } else {
        DLog(@"Error: Correct answer sound not found");
    }
}

-(void)playWrongAnswer
{
    if(_wrongAnswer) {
        [self playSound:_wrongAnswer];
    } else {
        DLog(@"Error: Wrong answer sound not found");
    }
}

-(void)playLevelUp
{
    if(_levelUp) {
        [self playSound:_levelUp];
    } else {
        DLog(@"Error: Level up sound not found");
    }
}

-(void)playCountdown
{
    if(_countdown) {
        [self playSound:_countdown];
    } else {
        DLog(@"Error: Countdown sound not found");
    }
}

-(void)playGameWon
{
    if(_gameWon) {
        [self playSound:_gameWon];
    } else {
        DLog(@"Error: Game won sound not found");
    }
}

-(void)stopCountDown
{
    if(_countdown) {
        //stop countdown
        AudioServicesDisposeSystemSoundID(_countdown);
        NSURL *countDownPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:SOUND_COUNTDOWN ofType:@"aif"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)countDownPath, &_countdown);
    } else {
        DLog(@"Error: Countdown sound not found");
    }
}
            

-(void)dealloc
{
    AudioServicesDisposeSystemSoundID(_correctAnswer);
    AudioServicesDisposeSystemSoundID(_wrongAnswer);
    AudioServicesDisposeSystemSoundID(_achievement);
    AudioServicesDisposeSystemSoundID(_levelUp);
    AudioServicesDisposeSystemSoundID(_countdown);
    AudioServicesDisposeSystemSoundID(_endRound);
    AudioServicesDisposeSystemSoundID(_gameWon);
    AudioServicesDisposeSystemSoundID(_startRound);
}



@end
