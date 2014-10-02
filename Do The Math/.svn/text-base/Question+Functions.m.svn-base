//
//  Question+Functions.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/25/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "Question+Functions.h"
#import "Round.h"

@implementation Question (Functions)

/**
 * Gives a description of the Question object
 */

-(NSString *)description {
    NSString *description = [NSString stringWithFormat:@"Question:[id:%@,type:%@] ",self.questionId,[self class]];
    return description;
}
/**
 * Returns if the question is answered by the user
 */
-(BOOL)isAnswered {
    if([self.yourAnswer isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

/**
 * Returns if the question is answered correct by the user
 */
-(BOOL)isCorrect {
    if([self.yourAnswerCorrect boolValue]) {
        return YES;
    } else {
        return NO;
    }
}


/**
 * Returns if the question is answered correct by the opponent
 */
-(BOOL)opponentCorrect {
    if([self.theirAnswerCorrect boolValue]) {
        return YES;
    } else {
        return NO;
    }
}
@end
