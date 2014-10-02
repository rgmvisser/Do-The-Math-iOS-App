//
//  CorrectWrong+Functions.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/27/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "CorrectWrong+Functions.h"


@implementation CorrectWrong (Functions)

/**
 * Gives a description of the Correct-Wrong object
 */

-(NSString *)description {
    return [NSString stringWithFormat:@"Question:[id:%@,type:%@,question:%@,answer:%@,yourAnswer:%@,theirAnswer:%@, yourtimeSpent: %d, theirtimeSpent: %d] ",self.questionId,[self class],self.question,self.answer,self.yourAnswer,self.theirAnswer, [self.yourTimeSpent intValue], [self.theirTimeSpent intValue]];
}

@end
