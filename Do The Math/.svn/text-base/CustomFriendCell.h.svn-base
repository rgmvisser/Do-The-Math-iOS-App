//
// CustomFriendCell.h
// Do The Math
//
// Created by Rogier Slag on 9/20/12.
// Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend+Functions.h"
#import "UserCell.h"
#import "GameInvite.h"

@class CustomFriendCell;

@protocol CustomFriendCellDelegate <NSObject>

@optional
-(void)customFriendCell:(CustomFriendCell *)cell didTouchInviteForGame:(Friend *)friend;
-(void)customFriendCell:(CustomFriendCell *)cell didTouchToReplyToGameInvite:(GameInvite *)GameInvite;

@end



@interface CustomFriendCell : UserCell

@property (nonatomic,weak) id<CustomFriendCellDelegate> delegate;

- (IBAction)inviteForGame:(id)sender;
- (IBAction)replyToGameInvite:(id)sender;

-(void)setGameInvite:(GameInvite *)gameInvite;
-(void)setFriend:(Friend *) friend;

@end