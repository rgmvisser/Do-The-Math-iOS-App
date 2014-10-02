//
//  Friend+Functions.m
//  Do The Math
//
//  Created by Rogier Slag on 9/18/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "Friend+Functions.h"
#import <RestKit/RestKit.h>

@implementation Friend (Functions)



- (NSString *) description {
    return [NSString stringWithFormat:@"<Friend: (id,username,avatar) (%@,%@,%@)", self.id, self.username, self.avatar];
}

-(NSString *)getAvatarUrl {
    return [NSString stringWithFormat:@"%@_%@.png",self.id,self.avatar];
}


@end
