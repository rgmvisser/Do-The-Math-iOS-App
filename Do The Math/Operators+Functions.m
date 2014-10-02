//
//  Operators+Functions.m
//  dothemath
//
//  Created by Rogier Slag on 27/11/2012.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "Operators+Functions.h"
#import "Round.h"

@implementation Operators (Functions)

- (NSString*) description {
    NSString *description = [NSString stringWithFormat:@"Question:[id:%@,typeround:%@,expression:%@, solution:%@, timeSpent: %d] ",self.questionId,self.round.type ,self.expression,self.solution, [self.timeSpent intValue]];
    return description;

}

@end
