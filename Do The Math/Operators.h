//
//  Operators.h
//  dothemath
//
//  Created by Innovattic 1 on 12/4/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Question.h"


@interface Operators : Question

@property (nonatomic, retain) NSString * expression;
@property (nonatomic, retain) NSString * solution;
@property (nonatomic, retain) NSString * answer;

@end
