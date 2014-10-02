//
//  User+Functions.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/13/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "User+Functions.h"
#import <RestKit/RestKit.h>
#import "DynamicImageLoader.h"
#import "RankManager.h"
#import "DTMInAppPurchase.h"

@implementation User (Functions)

static User *_user = nil;



/**
 * Get the current user which is logged in
 */
+(User *) currentUser {
    return _user;
}

/**
 * Sets the current user which is logged in
 */
+(void) setUser: (User *) user {
    _user = user;
    [self initPushNotifications];
}


+(void)initPushNotifications {
    DLog(@"Push init");
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}



/**
 * Gives a description of the user object
 */

-(NSString *)description {
    NSString *description = [NSString stringWithFormat:@"User:[id:%@,username:%@,password:%@,token:%@, email:%@,premium:%@, language:%@, facebook_id:%@, wins:%@, losses:%@, xp:%@] ",self.id,self.username,self.password,self.token,self.email,[self isPremium]?@"true":@"false",self.language,self.facebook_id,self.wins,self.losses,self.experience];
    return description;
    
}


-(BOOL) isFacebookUser {
    if([self.token rangeOfString:@"-"].location == NSNotFound) {
        return YES;
    } else {
        return NO;
    }
        
}

-(NSString *)getPrefferedLanguage {
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

-(void)newAvatar:(UIImage *)newAvatar {
    int avatar = [self.avatar intValue];
    if(avatar == 0) {
        avatar = 1;
    } else {
        avatar += 1;
    }
    self.avatar = [NSNumber numberWithInt:avatar];
    [[DynamicImageLoader shared] uploadAvatarToServer:newAvatar];
    [[DynamicImageLoader shared] saveImage:newAvatar imageName:[self getAvatarUrl]];
}

-(NSString *)getAvatarUrl {
    return [NSString stringWithFormat:@"%@_%@.png",self.id,self.avatar];
}

-(NSString *)getRankName {
    return [[RankManager shared] getCurrentRankNameWithExperience:self.experience];
}

- (BOOL) isPremium {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PREMIUM];
    //return [self.premium boolValue];
}



@end
