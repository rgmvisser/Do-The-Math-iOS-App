//
//  RankManager.m
//  dothemath
//
//  Created by Innovattic 1 on 11/27/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "RankManager.h"
#import "Rank.h"
#import <RestKit/RestKit.h>
#import "SBJson.h"






@interface RankManager()
{
    NSMutableArray *_ranks;
}
@end

@implementation RankManager

static RankManager *_manager = nil;


/**
 * Singelton init function
 */
+(RankManager *)shared
{
    if(!_manager)
    {
        _manager = [[RankManager alloc] init];
        //update if the ranks are updated
        
        // Voor de localized tool, dat hij deze ook mee pakt
        NSLocalizedString(@"RANK_1",@"Soldier Addition");
        NSLocalizedString(@"RANK_2",@"Soldier Division");
        NSLocalizedString(@"RANK_3" ,@"Soldier Exponent");
        NSLocalizedString(@"RANK_4" ,@"Soldier Gradient");
        NSLocalizedString(@"RANK_5" ,@"Soldier Polynomial");
        NSLocalizedString(@"RANK_6" ,@"Soldier Laplace");
        NSLocalizedString(@"RANK_7" ,@"Soldier Fourier");
        NSLocalizedString(@"RANK_8" ,@"Soldier Euler");
        NSLocalizedString(@"RANK_9" ,@"Corporal Division");
        NSLocalizedString(@"RANK_10" ,@"Corporal Exponent");
        NSLocalizedString(@"RANK_11" ,@"Corporal Gradient");
        NSLocalizedString(@"RANK_12" ,@"Corporal Polynomial");
        NSLocalizedString(@"RANK_13" ,@"Corporal Laplace");
        NSLocalizedString(@"RANK_14" ,@"Corporal Fourier");
        NSLocalizedString(@"RANK_15" ,@"Corporal Euler");
        NSLocalizedString(@"RANK_16" ,@"Sergeant Exponent");
        NSLocalizedString(@"RANK_17" ,@"Sergeant Gradient");
        NSLocalizedString(@"RANK_18" ,@"Sergeant Polynomial");
        NSLocalizedString(@"RANK_19" ,@"Sergeant Laplace");
        NSLocalizedString(@"RANK_20" ,@"Sergeant Fourier");
        NSLocalizedString(@"RANK_21" ,@"Sergeant Euler");
        NSLocalizedString(@"RANK_22" ,@"Lieutenant Gradient");
        NSLocalizedString(@"RANK_23" ,@"Lieutenant Polynomial");
        NSLocalizedString(@"RANK_24" ,@"Lieutenant Laplace");
        NSLocalizedString(@"RANK_25" ,@"Lieutenant Fourier");
        NSLocalizedString(@"RANK_26" ,@"Lieutenant Euler");
        NSLocalizedString(@"RANK_27" ,@"Captain Polynomial");
        NSLocalizedString(@"RANK_28" ,@"Captain Laplace");
        NSLocalizedString(@"RANK_29" ,@"Captain Fourier");
        NSLocalizedString(@"RANK_30" ,@"Captain Euler");
        NSLocalizedString(@"RANK_31" ,@"Major Laplace");
        NSLocalizedString(@"RANK_32" ,@"Major Fourier");
        NSLocalizedString(@"RANK_33" ,@"Major Euler");
        NSLocalizedString(@"RANK_34" ,@"Colonel Fourier");
        NSLocalizedString(@"RANK_35" ,@"Colonel Euler");
        NSLocalizedString(@"RANK_36" ,@"General Euler");
        [_manager setRanks];
        
        
    }
    return _manager;
}

-(void)initialize
{
    
}

/**
 * Set the ranks from the NSUserdefaults
 */
-(void)setRanks
{
    if(!_ranks)
    {
        _ranks = [[NSMutableArray alloc] init];
    }
    NSArray *ranks = [[NSUserDefaults standardUserDefaults] objectForKey:@"ranks"];
     DLog(@"Ranks: %@",ranks);
    if(ranks) //if the ranks are found
    {
        _ranks = [[NSMutableArray alloc] init];
        [ranks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *object = (NSDictionary *)obj;
            //create a rank object
            Rank *rank = [[Rank alloc] initWithRankName:NSLocalizedString([object objectForKey:@"name"],"Rank name (dynamic)RANK_1,RANK_2...") andExperience:[object objectForKey:@"experience"]];
            [_ranks addObject:rank];
        }];
    }
    [self updateRanks];
}

/**
 * Return the current rank name with an amount of experience 
 */
-(NSString *)getCurrentRankNameWithExperience:(NSNumber *)xp
{
    __block NSString *currentName = @"";
    __block int rankNumber = 0;
    [_ranks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Rank *rank = (Rank *)obj;
        if([rank.experience intValue] > [xp intValue])
        {
            *stop = YES;
        }
        else{
            rankNumber++;
            currentName = rank.name;
        }
    }];
    return [NSString stringWithFormat:@"%d. %@",rankNumber,currentName];
}


/**
 * Return the next rank name with an amount of experience
 */
-(NSString *)getNextRankNameWithExperience:(NSNumber *)xp
{
    __block NSString *nextName = @"";
    __block int rankNumber = 0;
    [_ranks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Rank *rank = (Rank *)obj;
        rankNumber++;
        if([rank.experience intValue] > [xp intValue])
        {
            nextName = rank.name;
            *stop = YES;
        }
    }];
    return [NSString stringWithFormat:@"%d. %@",rankNumber,nextName];
}

/**
 * Return the minimum current rank experience with an amount of experience
 */
-(NSNumber *)getCurrentRankExperienceWithExperience:(NSNumber *)xp
{
    __block NSNumber *currentXP = [NSNumber numberWithInt:0];
    [_ranks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Rank *rank = (Rank *)obj;
        if([rank.experience intValue] > [xp intValue])
        {
            
            *stop = YES;
        }
        else{
            currentXP = rank.experience;
        }
    }];
    return currentXP;
}

/**
 * Return the next minimum rank experience with an amount of experience
 */
-(NSNumber *)getNextRankExperienceWithExperience:(NSNumber *)xp
{
    __block NSNumber *nextXP = [NSNumber numberWithInt:0];
    [_ranks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Rank *rank = (Rank *)obj;
        if([rank.experience intValue] > [xp intValue])
        {
            nextXP = rank.experience;
            *stop = YES;
        }
    }];
    return nextXP;
}


-(void)updateRanks {
    NSDate *last_update;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"ranks_updated"]) {
        last_update = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ranks_updated"];
    } else {
        last_update = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    }
    
    //of als hij nog niet gezet is of als de tijd langer dan een uur geleden is
    if((int)[last_update timeIntervalSinceNow] < -60*60 || [_ranks count] < 1) {
        [[RKClient sharedClient] get:@"/settings/rank" usingBlock:^(RKRequest *request) {
            request.onDidLoadResponse =  ^(RKResponse *response){
                if(response.statusCode == 200) {
                    NSArray *ranks = [response.bodyAsString JSONValue];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:ranks forKey:@"ranks"];
                    [self setRanks];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"ranks_updated"];
                } else {
                    DLog(@"Failed to get ranks:%@",response);
                }
            };
        }];
        
        
    }
}

@end
