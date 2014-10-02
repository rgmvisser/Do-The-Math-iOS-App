//
//  FaceBookFriendCell.h
//  dothemath
//
//  Created by Innovattic 1 on 10/25/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceBookFriendCellDelegate.h"
@interface FaceBookFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *faceBookNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *facebookAvatar;
@property (nonatomic,weak) id<FaceBookFriendCellDelegate> delegate;

-(void)setFaceBookFriend:(NSDictionary<FBGraphUser> *)facebookFriend;

- (IBAction)sendInviteMail:(id)sender;


@end
