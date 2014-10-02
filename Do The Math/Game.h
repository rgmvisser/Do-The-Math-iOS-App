//
//  Game.h
//  dothemath
//
//  Created by Innovattic 1 on 3/12/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Opponent, Round;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSNumber * bonusPerUnit;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) NSNumber * gameId;
@property (nonatomic, retain) NSDate * lastAction;
@property (nonatomic, retain) NSNumber * minimalCorrectForBonus;
@property (nonatomic, retain) NSNumber * secondsPerUnit;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * result;
@property (nonatomic, retain) Opponent *opponent;
@property (nonatomic, retain) NSOrderedSet *rounds;
@end

@interface Game (CoreDataGeneratedAccessors)

- (void)insertObject:(Round *)value inRoundsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRoundsAtIndex:(NSUInteger)idx;
- (void)insertRounds:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRoundsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRoundsAtIndex:(NSUInteger)idx withObject:(Round *)value;
- (void)replaceRoundsAtIndexes:(NSIndexSet *)indexes withRounds:(NSArray *)values;
- (void)addRoundsObject:(Round *)value;
- (void)removeRoundsObject:(Round *)value;
- (void)addRounds:(NSOrderedSet *)values;
- (void)removeRounds:(NSOrderedSet *)values;
@end
