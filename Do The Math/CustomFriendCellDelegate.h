//
//  CustomFriendCellDelegate.h
//  dothemath
//
//  Created by Innovattic 1 on 10/16/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomFriendCell;
@class Friend;
@class FriendSearch;

@protocol CustomFriendCellDelegate <NSObject>

@optional

-(void)customFriendCell:(CustomFriendCell*)cell didTouchInviteForFriendRequest:(FriendSearch*)requestFriend;
-(void)customFriendCell:(CustomFriendCell *)cell didTouchInviteForGame:(Friend *)friend;
@end
