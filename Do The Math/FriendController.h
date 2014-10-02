//
//  FriendController.h
//  dothemath
//
//  Created by Innovattic 1 on 1/11/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend+Functions.h"
#import "CustomFriendInviteCell.h"
#import "CustomFriendCell.h"

#define FRIEND_INVITES @"friend_invites"

@protocol RKObjectLoaderDelegate;
@interface FriendController : NSObject

+(FriendController *)shared;

- (void) inviteForFriendRequest:(FriendSearch *)requestFriend;
- (void) inviteForGame:(NSNumber *)friendId InViewController:(UIViewController *)vc withCompletion:(void (^)())completion;

- (void) searchUsernames:(NSString *)username delegate:(id<RKObjectLoaderDelegate>)delegate;
- (NSMutableArray *) getFriendsWithdelegate:(id<RKObjectLoaderDelegate>)delegate;
- (UIButton *) friendInviteButton;
- (BOOL) isFriend:(NSNumber *)friendId;
-(void)setFriends:(NSMutableArray *)friends;
@end
