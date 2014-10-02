//
//  Game+Functions.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/25/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//


#import "Game+Functions.h"
#import "Opponent+Functions.h"
#import "Round+Functions.h"
#import "Question+Functions.h"

@implementation Game (Functions)



static Game *_currentGame = nil;

/**
 * Get the current game 
 */
+(Game *) currentGame {
    return _currentGame;
}

/**
 * Sets the current game the user is playing
 */
+(void) setCurrentGame: (Game *) game {
    _currentGame = game;
}

/**
 * Gives a description of the game object
 */

-(NSString *)description {
    __block NSString *rounds = [NSString stringWithFormat:@"["];
    [self.rounds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Round *round = (Round *) obj;
        rounds = [rounds stringByAppendingFormat:@"%@, ",round];
    }];
    [rounds stringByAppendingString:@"]"];
    NSString *description = [NSString stringWithFormat:@"Game:[id:%@, opponent:%@, difficulty:%d, status:%@, result:%@, deleted: %@, rounds:%@] ",self.gameId,self.opponent,[self.difficulty intValue],   self.status, self.result, self.deleted, rounds];
    
    return description;
}

/**
 * check which round is the current round
 * roundnumer is 0/1/2, 3 is when the game is played
 * returns the number of the round
 */
-(NSNumber *) currentRoundNumber {
     __block NSNumber *roundNumber = [NSNumber numberWithInt:[self.rounds count]]; //if all rounds are played the number is one more than the count of the rounds
    [self.rounds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Round *round = (Round *) obj;
        if(![round played]) {
            roundNumber = [NSNumber numberWithInteger:idx];
            *stop = YES;
        }
    }];
    return roundNumber;
}

- (BOOL) userDidFinishGame {
    return ([[self currentRoundNumber] isEqualToNumber:[NSNumber numberWithInt:3]])?YES:NO;
}

/**
 * Returns YES if the opponent finished the game
 * The opponent has finished the game if he did answer one of the questions
 */
- (BOOL) opponentDidFinishGame {
    __block BOOL result = NO;
    Round *round = [self.rounds objectAtIndex:[self.rounds count]-1];
    [round.questions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Question *q = (Question *) obj;
        if ( ! [q.theirAnswer isEqualToString:@""]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}



/**
 * Gets the current round
 * 
 */
-(Round *)currentRound {
    return [self.rounds objectAtIndex:[[self currentRoundNumber] integerValue]];
}

+(NSString *)getDifficultyName:(NSNumber *)difficultyOfGame {
    int difficulty = [difficultyOfGame intValue];
    //DLog(@"diff:%d",difficulty);
    if(difficulty == 1) {
        return _DIFFICULTY_1;
    }
    if(difficulty == 2) {
        return _DIFFICULTY_2;
    }
    if(difficulty == 3) {
        return _DIFFICULTY_3;
    }
    if(difficulty == 4) {
        return _DIFFICULTY_4;
    }
    //no difficulty found
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No difficulty found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
    NSException* myException = [NSException
                                exceptionWithName:@"DifficultyNotFound"
                                reason:@"Game has no known difficulty"
                                userInfo:nil];
    @throw myException;
    return @"";
}

-(NSNumber *)getTotalGameScore {
    int total = 0;
    for(Round *round in self.rounds) {
        total += [[round getTotalRoundScore] intValue];
    }
    return [NSNumber numberWithInt:total];
}

-(NSNumber *)getOpponentTotalGameScore {
    int total = 0;
    for(Round *round in self.rounds) {
        total += [[round getTheirTotalRoundScore] intValue];
    }
    return [NSNumber numberWithInt:total];
}

-(NSNumber *)maxScorePossible {
    int maxScore = 0;
    for(Round *round in self.rounds) {
        if(round.played) {
            maxScore += [[round maxScore] intValue];
        }
    }
    return [NSNumber numberWithInt:maxScore];
    
}

-(BOOL)isComplete {
    if([self.status isEqualToString:_COMPLETE]) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)isDeleted {
    return [self.deleted boolValue];
}

- (NSString *)getResultOfGame {
    NSLocalizedString(@"WON",@"Won");
    NSLocalizedString(@"DRAW",@"Draw");
    NSLocalizedString(@"LOST",@"Lost");
    if(self.result){
        return [NSString stringWithFormat:@"(%@)",NSLocalizedString([self.result uppercaseString], @"The game result, won/lost/draw")] ;
    }
    return @"";
}

@end
