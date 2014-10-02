//
//  BadgeManager.h
//  dothemath
//
//  Created by Innovattic 1 on 11/14/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BadgeManager : NSObject

+ (BadgeManager *)shared;

-(void)increaseBadges:(id)sender;
-(void)decreaseBadges:(id)sender;
-(void)calculate:(NSArray *)lists;
-(void)set:(int)number;
@end
