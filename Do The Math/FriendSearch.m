    //
//  FriendSearch.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/20/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "FriendSearch.h"

@implementation FriendSearch

@synthesize id = _id;
@synthesize avatar = _avatar;
@synthesize username = _username;
@synthesize experience = _experience;
@synthesize invited = _invited;

-(NSString *)getAvatarUrl {
    return [NSString stringWithFormat:@"%@_%@.png",self.id,self.avatar];
}

-(BOOL)invited {
    if(!_invited) {
        _invited = NO;
    }
    return _invited;
}


@end
