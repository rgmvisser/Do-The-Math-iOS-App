//
//  Round.h
//  dothemath
//
//  Created by Innovattic 1 on 12/19/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Question;

@interface Round : NSManagedObject

@property (nonatomic, retain) NSNumber * gameId;
@property (nonatomic, retain) NSNumber * isPlayed;
@property (nonatomic, retain) NSNumber * roundId;
@property (nonatomic, retain) NSNumber * roundPoints;
@property (nonatomic, retain) NSNumber * roundTime;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * yourTimeBonus;
@property (nonatomic, retain) NSNumber * theirTimeBonus;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) NSOrderedSet *questions;
@end

@interface Round (CoreDataGeneratedAccessors)

- (void)insertObject:(Question *)value inQuestionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromQuestionsAtIndex:(NSUInteger)idx;
- (void)insertQuestions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeQuestionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInQuestionsAtIndex:(NSUInteger)idx withObject:(Question *)value;
- (void)replaceQuestionsAtIndexes:(NSIndexSet *)indexes withQuestions:(NSArray *)values;
- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSOrderedSet *)values;
- (void)removeQuestions:(NSOrderedSet *)values;
@end
