//
//  Question.h
//  dothemath
//
//  Created by Innovattic 1 on 12/12/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Round;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSNumber * questionId;
@property (nonatomic, retain) NSNumber * roundId;
@property (nonatomic, retain) NSString * theirAnswer;
@property (nonatomic, retain) NSNumber * theirAnswerCorrect;
@property (nonatomic, retain) NSNumber * yourTimeSpent;
@property (nonatomic, retain) NSString * yourAnswer;
@property (nonatomic, retain) NSNumber * yourAnswerCorrect;
@property (nonatomic, retain) NSNumber * theirTimeSpent;
@property (nonatomic, retain) Round *round;

@end
