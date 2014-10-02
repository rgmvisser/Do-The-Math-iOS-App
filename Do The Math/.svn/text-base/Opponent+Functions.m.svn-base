//
//  Opponent+Functions.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/25/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "Opponent+Functions.h"
#import "Game.h"

@implementation Opponent (Functions)

/**
 * Gives a description of the question object
 */

-(NSString *)description {
    NSString *description = [NSString stringWithFormat:@"[id:%@,username:%@,avatar:%@] ",self.opponentId,self.username,self.avatar];
    return description;
}

-(NSString *)getAvatarUrl {
    return [NSString stringWithFormat:@"%@_%@.png",self.opponentId,self.avatar];
}


@end
