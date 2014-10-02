//
//  SoundController.h
//  dothemath
//
//  Created by Innovattic 1 on 12/21/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SOUND_EFFECT @"sound_effects"


@interface SoundController : NSObject

+(SoundController *)shared;

-(void)playAchievement;
-(void)playStartRound;
-(void)playEndRound;
-(void)playCorrectAnswer;
-(void)playWrongAnswer;
-(void)playLevelUp;
-(void)playCountdown;
-(void)stopCountDown;
-(void)playGameWon;
@end
