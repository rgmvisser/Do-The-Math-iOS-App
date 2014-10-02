//
//  Opponent.h
//  dothemath
//
//  Created by Innovattic 1 on 12/11/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface Opponent : NSManagedObject

@property (nonatomic, retain) NSNumber * avatar;
@property (nonatomic, retain) NSNumber * gameId;
@property (nonatomic, retain) NSNumber * opponentId;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSSet *game;
@end

@interface Opponent (CoreDataGeneratedAccessors)

- (void)addGameObject:(Game *)value;
- (void)removeGameObject:(Game *)value;
- (void)addGame:(NSSet *)values;
- (void)removeGame:(NSSet *)values;

@end
