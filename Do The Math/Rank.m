//
//  Rank.m
//  dothemath
//
//  Created by Innovattic 1 on 11/27/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "Rank.h"

@implementation Rank

-(id)initWithRankName:(NSString *)name andExperience:(NSNumber *)xp {
    self = [super init];
    if(self) {
        self.name = name;
        self.experience = xp;
    }
    return self;
}

@end
