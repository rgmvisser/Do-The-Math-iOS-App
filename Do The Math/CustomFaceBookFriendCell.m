//
//  FaceBookFriendCell.m
//  dothemath
//
//  Created by Innovattic 1 on 10/25/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "CustomFaceBookFriendCell.h"
#import <FacebookSDK/FBGraphUser.h>

@implementation CustomFaceBookFriendCell
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

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.button setTitle:NSLocalizedString(@"INVITE", @"Invite facebook friend button") forState:UIControlStateNormal];
}


- (IBAction)sendInviteMail:(id)sender {
    if([self.delegate respondsToSelector:@selector(facebookFriendCell:didTouchToInviteByFacebook:)]){
      [self.delegate facebookFriendCell:self didTouchToInviteByFacebook:_facebookFriend];  
    }
    
}


-(void)setFaceBookFriend:(NSDictionary<FBGraphUser> *)facebookFriend
{
    _facebookFriend = facebookFriend;
    self.username.text = facebookFriend.name;
    //[self.avatar setDynamicImageFromUrl:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=100&height=100",_facebookFriend.id]];
    [self.avatar loadDefaultImage];
    
}


@end
