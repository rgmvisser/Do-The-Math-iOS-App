//
//  Round+Functions.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/25/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "Round+Functions.h"
#import "Question+Functions.h"
#import "Game+Functions.h"

@implementation Round (Functions)

/**
 * Gives a description of the Round object
 */

-(NSString *)description {
    __block NSString *questions = [NSString stringWithFormat:@"["];
    [self.questions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Question *question = (Question *) obj;
        questions = [questions stringByAppendingFormat:@"%@, ",question];
    }];
    [questions stringByAppendingString:@"]"];
    NSString *description = [NSString stringWithFormat:@"Round:[id:%@,type:%@,played:%@,bonus: %@,questions:%@] ",self.roundId,self.type,self.isPlayed,self.yourTimeBonus,questions];
    
    return description;
}

/**
 * Returns if the round is played by the user
 */
-(BOOL) played {
    if([self.isPlayed boolValue]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 * Returns the number of correct answers of the user
 */
-(int)getCorrectAnswers {
    __block int score = 0;
    [self.questions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Question *question = (Question *) obj;
        if([question isCorrect]) {
            score++;
        }
    }];
    return score;
    
}

/**
 * Returns the number of correct answersof the opponent
 */
-(int)getOpponentCorrectAnswers
{
    __block int score = 0;
    [self.questions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Question *question = (Question *) obj;
        if([question opponentCorrect])
        {
            score++;
        }
    }];
    return score;
}

/**
 * Returns the score of the round
 */
-(int)getYourScore {
    int correctAnswers = [self getCorrectAnswers];
    int pointsPerQuestion = floor([self.roundPoints intValue] / [self.questions count]);

    return correctAnswers * pointsPerQuestion;
}

/**
 * Returns the score of the round of the opponent
 */
-(int)getTheirScore {
    int correctAnswers = [self getOpponentCorrectAnswers];
    int pointsPerQuestion = floor([self.roundPoints intValue] / [self.questions count]);
    
    return correctAnswers * pointsPerQuestion;
}

/**
 * Answers all the question with "" which are not yet answered
 */
-(void)answerAllUnansweredQuestions {
    [self.questions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Question *question = (Question *) obj;
        if(![question isAnswered]) {
            question.yourAnswer = _NOT_ANSWERED;
            question.yourAnswerCorrect = [NSNumber numberWithBool:NO];
        }
    }];
}

-(void)setYourBonus {
    int bonus = 0;
    double score = (double)[self getCorrectAnswers];
    double total_questions = (double)[self.questions count];
    DLog(@"Score: %f, RoundTime: %@, TimeSpent: %d",score, self.roundTime,[self totalTimeSpent]);
    
    if((total_questions * [self.game.minimalCorrectForBonus doubleValue]) <= score) {
        DLog(@"RoundTime: %@, TimeSpent: %d",self.roundTime,[self totalTimeSpent]);
        
        double timeLeft = (double)([self.roundTime intValue] - [self totalTimeSpent]);
        if(timeLeft > 0) {
            //sometime totaltimespent is 121 because of the rounding error
            double units = floor(timeLeft / [self.game.secondsPerUnit doubleValue]);
            bonus = units * [self.game.bonusPerUnit intValue];
        }
    }
    self.yourTimeBonus = [NSNumber numberWithInt:bonus];
}




/**
 * Get the total time spent on a round
 */
-(int)totalTimeSpent {
    __block int total = 0;
    [self.questions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Question *q = (Question *)obj;
        total = total + [q.yourTimeSpent intValue];
    }];
    return total/1000;
}

/**
 * Get the total time spent on a round
 */
-(int)theirTotalTimeSpent {
    __block int total = 0;
    [self.questions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Question *q = (Question *)obj;
        total = total + [q.theirTimeSpent intValue];
    }];
    return total/1000;
}


/**
 * Get the total score with bonus from a round
 */
-(NSNumber *)getTotalRoundScore {
    NSNumber *score = [NSNumber numberWithInt:[self getYourScore]];
    NSNumber *totalScore = [NSNumber numberWithInt:[score intValue] + [self.yourTimeBonus intValue]];
    return totalScore;
}

/**
 * Get the their total score with bonus from a round
 */
-(NSNumber *)getTheirTotalRoundScore {
    NSNumber *score = [NSNumber numberWithInt:[self getTheirScore]];
    NSNumber *totalScore = [NSNumber numberWithInt:[score intValue] + [self.theirTimeBonus intValue]];
    return totalScore;
}



/**
 * Get the maximum score from a round
 */
-(NSNumber *) maxScore {
    double maxTimeBonus = (([self.roundTime doubleValue] / [self.game.secondsPerUnit doubleValue]) * [self.game.bonusPerUnit doubleValue]);
    double maxScore = maxTimeBonus + [self.roundPoints doubleValue];
    return [NSNumber numberWithDouble:round(maxScore)];
}

@end
