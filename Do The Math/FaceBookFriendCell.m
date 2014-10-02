//
//  FaceBookFriendCell.m
//  dothemath
//
//  Created by Innovattic 1 on 10/25/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "FaceBookFriendCell.h"
#import <FacebookSDK/FBGraphUser.h>

@implementation FaceBookFriendCell
{
    NSDictionary<FBGraphUser> *_facebookFriend;
}
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sendInviteMail:(id)sender {
    [self.delegate facebookFriendCell:self didTouchToInviteByEmail:_facebookFriend];
}


-(void)setFaceBookFriend:(NSDictionary<FBGraphUser> *)facebookFriend
{
    _facebookFriend = facebookFriend;
    self.faceBookNameLabel.text = facebookFriend.name;
    //@TODO avatar inbouwen
    //self.avatar = friend.avatar;
}


@end
