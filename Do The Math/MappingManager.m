//
//  MappingManager.m
//  dothemath
//
//  Created by Innovattic 1 on 11/21/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "MappingManager.h"
#import "User+Functions.h"
#import "Friend+Functions.h"
#import "FriendSearch.h"
#import <RestKit/RestKit.h>
#import "GameInvite.h"
#import "Game+Functions.h"
#import "Opponent+Functions.h"
#import "Round+Functions.h"
#import "Question+Functions.h"
#import "Solve+Functions.h"
#import "CorrectWrong.h"
#import "TwentyFour.h"
#import "SolveGameResult.h"
#import "CorrectWrongGameResult.h"
#import "TwentyFourGameResult.h"
#import "Operators.h"
#import "OperatorsGameResult.h"

@implementation MappingManager

+(void)setObjectMapping:(RKManagedObjectStore *)store;
{
    [self setUserMapping:store];
    [self setFriendMapping:store];
    RKManagedObjectMapping *opponentMapping = [self setOpponentMapping:store];
    
    //CorrectWrong class
    RKManagedObjectMapping *correctWrongMapping = [self setCorrectWrongMapping:store];
    [self setQuestionMappingOn:correctWrongMapping inStore:store];
    
    // Solve class
    RKManagedObjectMapping *solveMapping = [self setSolveMapping:store];
    [self setQuestionMappingOn:solveMapping inStore:store];
    
    // TwentyFour class
    RKManagedObjectMapping *twentyFourMapping = [self setTwentyFourMapping:store];
    [self setQuestionMappingOn:twentyFourMapping inStore:store];
    
    // Operators class
    RKManagedObjectMapping *operatorsMapping = [self setOperatorsMapping:store];
    [self setQuestionMappingOn:operatorsMapping inStore:store];
    
    //dynamic mapping for roundmapping
    RKDynamicObjectMapping *dynamicMapping = [RKDynamicObjectMapping new];
    [dynamicMapping setObjectMapping:correctWrongMapping whenValueOfKeyPath:@"type" isEqualTo:@"correctwrong"];
    [dynamicMapping setObjectMapping:twentyFourMapping whenValueOfKeyPath:@"type" isEqualTo:@"twentyfour"];
    [dynamicMapping setObjectMapping:solveMapping whenValueOfKeyPath:@"type" isEqualTo:@"solve"];
    [dynamicMapping setObjectMapping:operatorsMapping whenValueOfKeyPath:@"type" isEqualTo:@"operators"];
    
    //Round Class
    RKManagedObjectMapping *roundMapping = [self setRoundMappingWithDynamicMapping:dynamicMapping inStore:store];
    
    //Game Class
    RKManagedObjectMapping *gameMapping = [self setGameMappingWithRoundMapping:roundMapping AndOpponentMapping:opponentMapping inStore:store];
    
    //connections
    [roundMapping hasOne:@"game" withMapping:gameMapping];
    [roundMapping connectRelationship:@"game" withObjectForPrimaryKeyAttribute:@"gameId"];
    [opponentMapping hasMany:@"game" withMapping:gameMapping];
    
    
    // NOTE - SolveGameResults is not backed by Core Data
    RKObjectMapping *solveGameResultsMapping = [RKObjectMapping mappingForClass:[SolveGameResult class]];
    [solveGameResultsMapping mapKeyPath:@"questions" toRelationship:@"questions" withMapping:solveMapping];
    [solveGameResultsMapping mapKeyPath:@"time_bonus" toAttribute:@"timeBonus"];
    [solveGameResultsMapping mapKeyPath:@"score" toAttribute:@"score"];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:solveGameResultsMapping forKeyPath:@"questions"];
    RKObjectMapping *solveGameResultsSerialization = [solveGameResultsMapping inverseMapping];
    [solveGameResultsSerialization setRootKeyPath:@"results"];
    [[[RKObjectManager sharedManager] mappingProvider]  setSerializationMapping:solveGameResultsSerialization forClass:[SolveGameResult class]];
    
    // NOTE - CorrectWrongGameResult is not backed by Core Data
    RKObjectMapping *correctWrongGameResultMapping = [RKObjectMapping mappingForClass:[CorrectWrongGameResult class]];
    [correctWrongGameResultMapping mapKeyPath:@"time_bonus" toAttribute:@"timeBonus"];
    [correctWrongGameResultMapping mapKeyPath:@"score" toAttribute:@"score"];
    [correctWrongGameResultMapping mapKeyPath:@"questions" toRelationship:@"questions" withMapping:correctWrongMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:correctWrongGameResultMapping forKeyPath:@"questions"];
    RKObjectMapping *correctWrongGameResultsSerialization = [correctWrongGameResultMapping inverseMapping];
    [correctWrongGameResultsSerialization setRootKeyPath:@"results"];
    [[[RKObjectManager sharedManager] mappingProvider]  setSerializationMapping:correctWrongGameResultsSerialization forClass:[CorrectWrongGameResult class]];
    
    // NOTE - TwentyFourGameResult is not backed by Core Data
    RKObjectMapping *twentyFourGameResultMapping = [RKObjectMapping mappingForClass:[TwentyFourGameResult class]];
    [twentyFourGameResultMapping mapKeyPath:@"time_bonus" toAttribute:@"timeBonus"];
    [twentyFourGameResultMapping mapKeyPath:@"score" toAttribute:@"score"];
    [twentyFourGameResultMapping mapKeyPath:@"questions" toRelationship:@"questions" withMapping:twentyFourMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:twentyFourGameResultMapping forKeyPath:@"questions"];
    RKObjectMapping *twentyFourGameResultsSerialization = [twentyFourGameResultMapping inverseMapping];
    [twentyFourGameResultsSerialization setRootKeyPath:@"results"];
    [[[RKObjectManager sharedManager] mappingProvider]  setSerializationMapping:twentyFourGameResultsSerialization  forClass:[TwentyFourGameResult class]];
    
    // NOTE - OperatorsGameResult is not backed by Core Data
    RKObjectMapping *operatorsGameResultMapping = [RKObjectMapping mappingForClass:[OperatorsGameResult class]];
    [operatorsGameResultMapping mapKeyPath:@"time_bonus" toAttribute:@"timeBonus"];
    [operatorsGameResultMapping mapKeyPath:@"score" toAttribute:@"score"];
    [operatorsGameResultMapping mapKeyPath:@"questions" toRelationship:@"questions" withMapping:operatorsMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:operatorsGameResultMapping forKeyPath:@"questions"];
    RKObjectMapping *operatorsGameResultSerialization = [operatorsGameResultMapping inverseMapping];
    [operatorsGameResultSerialization setRootKeyPath:@"results"];
    [[[RKObjectManager sharedManager] mappingProvider]  setSerializationMapping:operatorsGameResultSerialization  forClass:[OperatorsGameResult class]];
    
    // NOTE - Friend request is not backed by Core Data
    RKObjectMapping *friendsearchMapping = [RKObjectMapping mappingForClass:[FriendSearch class]];
    [friendsearchMapping mapKeyPath:@"id" toAttribute:@"id"];
    [friendsearchMapping mapKeyPath:@"username" toAttribute:@"username"];
    [friendsearchMapping mapKeyPath:@"avatar" toAttribute:@"avatar"];
    [friendsearchMapping mapKeyPath:@"experience" toAttribute:@"experience"];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:friendsearchMapping forKeyPath:@"friend_requests"];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:friendsearchMapping forClass:[FriendSearch class]];
    
    // NOTE - Game request is not backed by Core Data
    RKObjectMapping *gameInviteMapping = [RKObjectMapping mappingForClass:[GameInvite class]];
    [gameInviteMapping mapKeyPath:@"id" toAttribute:@"id"];
    [gameInviteMapping mapKeyPath:@"difficulty" toAttribute:@"difficulty"];
    [gameInviteMapping hasOne:@"friend" withMapping:friendsearchMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:gameInviteMapping forKeyPath:@"match_requests"];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:gameInviteMapping forClass:[GameInvite class]];
   
    //Empty mapping
    RKObjectMapping *emptymapping = [RKObjectMapping mappingForClass:[NSObject class]];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:emptymapping forKeyPath:@""];
}

+(RKManagedObjectMapping *) setUserMapping:(RKManagedObjectStore *)store;
{
    //define the mapping for the user object
    RKManagedObjectMapping* userMapping = [RKManagedObjectMapping mappingForClass:[User class] inManagedObjectStore:store];
    userMapping.primaryKeyAttribute = @"id";
    [userMapping mapKeyPath:@"id" toAttribute:@"id"];
    [userMapping mapKeyPath:@"username" toAttribute:@"username"];
    [userMapping mapKeyPath:@"password" toAttribute:@"password"];
    [userMapping mapKeyPath:@"email" toAttribute:@"email"];
    [userMapping mapKeyPath:@"token" toAttribute:@"token"];
    [userMapping mapKeyPath:@"avatar" toAttribute:@"avatar"];
    [userMapping mapKeyPath:@"premium" toAttribute:@"premium"];
    [userMapping mapKeyPath:@"language" toAttribute:@"language"];
    [userMapping mapKeyPath:@"losses" toAttribute:@"losses"];
    [userMapping mapKeyPath:@"wins" toAttribute:@"wins"];
    [userMapping mapKeyPath:@"draws" toAttribute:@"draws"];
    [userMapping mapKeyPath:@"gender" toAttribute:@"gender"];
    [userMapping mapKeyPath:@"age" toAttribute:@"age"];
    [userMapping mapKeyPath:@"experience" toAttribute:@"experience"];
    [userMapping mapKeyPath:@"facebook_id" toAttribute:@"facebook_id"];
    
    [[[RKObjectManager sharedManager] mappingProvider] registerMapping:userMapping withRootKeyPath:@"user"];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:userMapping forClass:[User class]];
    return userMapping;
}

+(RKManagedObjectMapping *)setFriendMapping:(RKManagedObjectStore *)store;
{
    // Friend class
    RKManagedObjectMapping* friendMapping = [RKManagedObjectMapping mappingForClass:[Friend class] inManagedObjectStore:store] ;
    friendMapping.primaryKeyAttribute = @"id";
    [friendMapping mapKeyPath:@"id" toAttribute:@"id"];
    [friendMapping mapKeyPath:@"username" toAttribute:@"username"];
    [friendMapping mapKeyPath:@"avatar" toAttribute:@"avatar"];
    [friendMapping mapKeyPath:@"experience" toAttribute:@"experience"];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:friendMapping forKeyPath:@"friends"];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:friendMapping forClass:[Friend class]];
    return friendMapping;
}

+(RKManagedObjectMapping *)setOpponentMapping:(RKManagedObjectStore *)store;
{
    // Opponent class
    RKManagedObjectMapping* opponentMapping = [RKManagedObjectMapping mappingForClass:[Opponent class] inManagedObjectStore:store] ;
    opponentMapping.primaryKeyAttribute = @"opponentId";
    [opponentMapping mapKeyPath:@"id" toAttribute:@"opponentId"];
    [opponentMapping mapKeyPath:@"username" toAttribute:@"username"];
    [opponentMapping mapKeyPath:@"avatar" toAttribute:@"avatar"];
    [opponentMapping mapKeyPath:@"game_id" toAttribute:@"gameId"];
    [opponentMapping mapKeyPath:@"experience" toAttribute:@"experience"];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:opponentMapping forKeyPath:@"opponent"];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:opponentMapping forClass:[Opponent class]];
    return opponentMapping;
}

+(void)setQuestionMappingOn:(RKManagedObjectMapping *)mapping inStore:(RKManagedObjectStore *)store;
{
    // Correctwrong class    
    mapping.primaryKeyAttribute = @"questionId";
    [mapping mapKeyPath:@"id" toAttribute:@"questionId"];
    [mapping mapKeyPath:@"your_answer" toAttribute:@"yourAnswer"];
    [mapping mapKeyPath:@"their_answer" toAttribute:@"theirAnswer"];
    [mapping mapKeyPath:@"your_answer_correct" toAttribute:@"yourAnswerCorrect"];
    [mapping mapKeyPath:@"their_answer_correct" toAttribute:@"theirAnswerCorrect"];
    [mapping mapKeyPath:@"round_id" toAttribute:@"roundId"];
    [mapping mapKeyPath:@"your_time_spent" toAttribute:@"yourTimeSpent"];
    [mapping mapKeyPath:@"their_time_spent" toAttribute:@"theirTimeSpent"];
}

+(RKManagedObjectMapping *)setCorrectWrongMapping:(RKManagedObjectStore *)store;
{
    RKManagedObjectMapping* correctWrongMapping = [RKManagedObjectMapping mappingForClass:[CorrectWrong class] inManagedObjectStore:store];
    //correctwrong specifick
    [correctWrongMapping mapKeyPath:@"expression" toAttribute:@"question"];
    [correctWrongMapping mapKeyPath:@"solution" toAttribute:@"answer"];
    
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:correctWrongMapping forKeyPath:@"questions"];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:[correctWrongMapping inverseMapping] forClass:[CorrectWrong class]];
    
    return correctWrongMapping;
}

+(RKManagedObjectMapping *)setSolveMapping:(RKManagedObjectStore *)store;
{
    // Solve class
    RKManagedObjectMapping* solveMapping = [RKManagedObjectMapping mappingForClass:[Solve class] inManagedObjectStore:store] ;
    
    //solve specifick
    [solveMapping mapKeyPath:@"solution" toAttribute:@"answer"];
    [solveMapping mapKeyPath:@"expression" toAttribute:@"question"];
    //[[[RKObjectManager sharedManager] mappingProvider] registerObjectMapping:solveMapping withRootKeyPath:@"questions"];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:solveMapping forKeyPath:@"questions"];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:[solveMapping inverseMapping] forClass:[Solve class]];
    
    
    return solveMapping;
}

+(RKManagedObjectMapping *)setTwentyFourMapping:(RKManagedObjectStore *)store;
{
    // TwentyFour class
    RKManagedObjectMapping* twentyFourMapping = [RKManagedObjectMapping mappingForClass:[TwentyFour class] inManagedObjectStore:store] ;
    
    //twentyfour specfick
    [twentyFourMapping mapKeyPath:@"num1" toAttribute:@"number1"];
    [twentyFourMapping mapKeyPath:@"num2" toAttribute:@"number2"];
    [twentyFourMapping mapKeyPath:@"num3" toAttribute:@"number3"];
    [twentyFourMapping mapKeyPath:@"num4" toAttribute:@"number4"];
    [twentyFourMapping mapKeyPath:@"solution" toAttribute:@"solution"];
    
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:twentyFourMapping forKeyPath:@"questions"];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:[twentyFourMapping inverseMapping] forClass:[TwentyFour class]];
    
    
    
    return twentyFourMapping;
}

+(RKManagedObjectMapping *)setOperatorsMapping:(RKManagedObjectStore *)store;
{
    // Operators class
    RKManagedObjectMapping* operatorsMapping = [RKManagedObjectMapping mappingForClass:[Operators class] inManagedObjectStore:store] ;
    
    //operators specfick
    [operatorsMapping mapKeyPath:@"expression" toAttribute:@"expression"];
    [operatorsMapping mapKeyPath:@"solution" toAttribute:@"solution"];
    [operatorsMapping mapKeyPath:@"answer" toAttribute:@"answer"];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:operatorsMapping forKeyPath:@"questions"];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:[operatorsMapping inverseMapping] forClass:[Operators class]];
    
    
    return operatorsMapping;
    
}

+(RKManagedObjectMapping *)setRoundMappingWithDynamicMapping:(RKDynamicObjectMapping *)dynamicMapping inStore:(RKManagedObjectStore *)store;
{
    // Round class
    RKManagedObjectMapping* roundMapping = [RKManagedObjectMapping mappingForClass:[Round class] inManagedObjectStore:store] ;
    roundMapping.primaryKeyAttribute = @"roundId";
    [roundMapping mapKeyPath:@"round_id" toAttribute:@"roundId"];
    [roundMapping mapKeyPath:@"type" toAttribute:@"type"];
    [roundMapping mapKeyPath:@"is_played" toAttribute:@"isPlayed"];
    [roundMapping mapKeyPath:@"round_time" toAttribute:@"roundTime"];
    [roundMapping mapKeyPath:@"round_points" toAttribute:@"roundPoints"];
    [roundMapping mapKeyPath:@"your_time_bonus" toAttribute:@"yourTimeBonus"];
    [roundMapping mapKeyPath:@"their_time_bonus" toAttribute:@"theirTimeBonus"];
    [roundMapping mapKeyPath:@"game_id" toAttribute:@"gameId"];
    [roundMapping mapRelationship:@"questions" withMapping:dynamicMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:roundMapping forKeyPath:@"rounds"];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:[roundMapping inverseMapping] forClass:[Round class]];
    return roundMapping;
}


+(RKManagedObjectMapping *)setGameMappingWithRoundMapping:(RKManagedObjectMapping *)roundMapping AndOpponentMapping:(RKManagedObjectMapping *)opponentMapping inStore:(RKManagedObjectStore *)store
{
    //Game Class
    RKManagedObjectMapping* gameMapping = [RKManagedObjectMapping mappingForClass:[Game class] inManagedObjectStore:store] ;
    gameMapping.primaryKeyAttribute = @"gameId";
    [gameMapping mapKeyPath:@"id" toAttribute:@"gameId"];
    [gameMapping mapKeyPath:@"status" toAttribute:@"status"];
    [gameMapping mapKeyPath:@"result" toAttribute:@"result"];
    [gameMapping mapKeyPath:@"deleted" toAttribute:@"deleted"];
    [gameMapping mapKeyPath:@"difficulty" toAttribute:@"difficulty"];
    [gameMapping mapKeyPath:@"last_action" toAttribute:@"lastAction"];
    [gameMapping mapKeyPath:@"bonus_per_unit" toAttribute:@"bonusPerUnit"];
    [gameMapping mapKeyPath:@"seconds_per_unit" toAttribute:@"secondsPerUnit"];
    [gameMapping mapKeyPath:@"minimal_correct_for_bonus" toAttribute:@"minimalCorrectForBonus"];
    
    [gameMapping mapRelationship:@"rounds" withMapping:roundMapping];
    [gameMapping mapRelationship:@"opponent" withMapping:opponentMapping];
    [[[RKObjectManager sharedManager] mappingProvider] registerMapping:gameMapping withRootKeyPath:@"game"];
    [[[RKObjectManager sharedManager] mappingProvider] setSerializationMapping:gameMapping forClass:[Game class]];
    return gameMapping;
}

+(void)setResultMappingForObject:(Class)resultClass withMapping:(RKManagedObjectMapping *)objectMapping
{
    RKObjectMapping *gameResultMapping = [RKObjectMapping mappingForClass:resultClass];
    [gameResultMapping mapKeyPath:@"time_bonus" toAttribute:@"timeBonus"];
    [gameResultMapping mapKeyPath:@"score" toAttribute:@"score"];
    [gameResultMapping mapKeyPath:@"questions" toRelationship:@"questions" withMapping:objectMapping];
    [[[RKObjectManager sharedManager] mappingProvider] setMapping:gameResultMapping forKeyPath:@"questions"];
    RKObjectMapping *gameResultSerialization = [gameResultMapping inverseMapping];
    [gameResultSerialization setRootKeyPath:@"results"];
    [[[RKObjectManager sharedManager] mappingProvider]  setSerializationMapping:gameResultSerialization  forClass:resultClass];
}

+(void)setRouting
{
    //set the routing for the User class
    RKObjectRouter *router = [[RKObjectManager sharedManager] router];
    [router routeClass:[User class] toResourcePath:@"/user/new" forMethod:RKRequestMethodPOST];
    [router routeClass:[User class] toResourcePath:@"/user" forMethod:RKRequestMethodPUT];
    [router routeClass:[User class] toResourcePath:@"/user" forMethod:RKRequestMethodGET];
    
    [router routeClass:[Friend class] toResourcePath:@"/friend/fetch/" forMethod:RKRequestMethodGET];
    [router routeClass:[SolveGameResult class] toResourcePath:@"/match/round/" forMethod:RKRequestMethodPUT];
    [router routeClass:[CorrectWrongGameResult class] toResourcePath:@"/match/round/" forMethod:RKRequestMethodPUT];
    [router routeClass:[TwentyFourGameResult class] toResourcePath:@"/match/round/" forMethod:RKRequestMethodPUT];
    [router routeClass:[OperatorsGameResult class] toResourcePath:@"/match/round/" forMethod:RKRequestMethodPUT];
    //[router routeClass:[Game class] toResourcePath:@"/match/create" forMethod:RKRequestMethodPOST];
    
}

@end
