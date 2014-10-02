//
//  TwitterController.h
//  dothemath
//
//  Created by Innovattic 1 on 3/7/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterController : NSObject

+(TwitterController *)shared;
-(void)tweetFrom:(UIViewController *)sender tweet:(NSString *)tweet;

@end
