//
//  CustomFriendInviteCell.h
//  dothemath
//
//  Created by Innovattic 1 on 11/1/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCell.h"
@class FriendSearch;
@class CustomFriendInviteCell;


@protocol CustomFriendInviteCellDelegate <NSObject>

@optional
-(void)customFriendInviteCell:(CustomFriendInviteCell*)cell didTouchInviteForFriendRequest:(FriendSearch*)requestFriend;
-(void)customFriendInviteCell:(CustomFriendInviteCell*)cell didTouchToReplyToRequest:(FriendSearch*)requestFriend;
-(void)customFriendInviteCell:(CustomFriendInviteCell*)cell didTouchInviteForGame:(FriendSearch *)requestFriend;
@end



@interface CustomFriendInviteCell : UserCell


@property (nonatomic,weak) id<CustomFriendInviteCellDelegate> delegate;

- (IBAction)inviteFriend:(id)sender;
- (IBAction)replyToFriendInvite:(id)sender;

-(void)setRequestFriend:(FriendSearch *)requestFriend;

@end




