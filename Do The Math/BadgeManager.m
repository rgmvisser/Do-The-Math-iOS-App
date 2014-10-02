//
//  BadgeManager.m
//  dothemath
//
//  Created by Innovattic 1 on 11/14/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "BadgeManager.h"
#import "Game+Functions.h"
#import <RestKit/RestKit.h>


//the singelton
static BadgeManager *badgeManager;

@implementation BadgeManager

- (id)init
{
    if ( self = [super init] )
    {
        
    }
    return self;
    
}

/**
 * Get the singelton
 */
+ (BadgeManager *)shared
{
    if (!badgeManager)
    {
        // allocate the shared instance, because it hasn't been done yet
        badgeManager = [[BadgeManager alloc] init];
    }
    
    return badgeManager;
}

/**
 * Increase the badge with 1
 */
-(void)increaseBadges:(id)sender
{
    int badgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    badgeNumber++;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: badgeNumber];

}

/**
 * Decrease the badge with 1
 */
-(void)decreaseBadges:(id)sender
{
    int badgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    if(badgeNumber > 0)
    {
        badgeNumber--;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: badgeNumber];
    }
}

-(void)calculate:(NSArray *)lists
{
    int badgeNumber = 0;
    for(NSArray *list in lists)
    {
        badgeNumber += [list count];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: badgeNumber];
}

-(void)set:(int)number
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: number];
}

@end
