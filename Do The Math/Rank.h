//
//  Rank.h
//  dothemath
//
//  Created by Innovattic 1 on 11/27/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rank : NSObject

-(id)initWithRankName:(NSString *)name andExperience:(NSNumber *)xp;

@property (retain,nonatomic) NSString *name;
@property (retain,nonatomic) NSNumber *experience;

@end
