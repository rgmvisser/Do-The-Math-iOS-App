//
//  FaceBookFriendCell.h
//  dothemath
//
//  Created by Innovattic 1 on 10/25/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserCell.h"
@protocol FBGraphUser;
@class CustomFaceBookFriendCell;

@protocol FaceBookFriendCellDelegate <NSObject>

-(void)facebookFriendCell:(CustomFaceBookFriendCell *)cell didTouchToInviteByFacebook:(NSDictionary<FBGraphUser> *)facebookFriend;

@end



@interface CustomFaceBookFriendCell : UserCell

@property (nonatomic,weak) id<FaceBookFriendCellDelegate> delegate;

-(void)setFaceBookFriend:(NSDictionary<FBGraphUser> *)facebookFriend;

- (IBAction)sendInviteMail:(id)sender;


@end
