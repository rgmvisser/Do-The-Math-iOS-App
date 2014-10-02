//
//  Game+Functions.h
//  Do The Math
//
//  Created by Innovattic 1 on 9/25/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "Game.h"
#import "Opponent+Functions.h"

#define _TURN @"turn"
#define _WAIT @"wait"
#define _COMPLETE @"complete"

#define _DRAW @"draw"
#define _WON @"won"
#define _LOST @"lost"


#define _DIFFICULTY_1 NSLocalizedString(@"DIFFICULTY_EASY", @"Difficulty easy")
#define _DIFFICULTY_2 NSLocalizedString(@"DIFFICULTY_MEDIUM", @"Difficulty medium")
#define _DIFFICULTY_3 NSLocalizedString(@"DIFFICULTY_HARD", @"Difficulty hard")
#define _DIFFICULTY_4 NSLocalizedString(@"DIFFICULTY_EVIL", @"Difficulty evil")

@interface Game (Functions)

-(NSString *)description;
+(Game *) currentGame;
+(void) setCurrentGame: (Game *) game;
-(NSNumber *) currentRoundNumber;
-(Round *)currentRound;


-(BOOL)isComplete;
- (BOOL)isDeleted;
-(BOOL)userDidFinishGame;
-(BOOL)opponentDidFinishGame;

+(NSString *)getDifficultyName:(NSNumber *)difficultyOfGame;

-(NSNumber *)getTotalGameScore;
-(NSNumber *)getOpponentTotalGameScore;

-(NSNumber *)maxScorePossible;

-(NSString *)getResultOfGame;

@end
