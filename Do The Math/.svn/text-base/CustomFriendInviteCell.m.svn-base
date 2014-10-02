//
//  CustomFriendInviteCell.m
//  dothemath
//
//  Created by Innovattic 1 on 11/1/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "CustomFriendInviteCell.h"
#import "FriendSearch.h"
#import "Appearance.h"
#import "RankManager.h"
#import "FriendController.h"

@implementation CustomFriendInviteCell
{
     FriendSearch *_requestFriend;
    UIButton *_inviteButton;
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
    [self.button setTitle:NSLocalizedString(@"RESPOND", @"Respond to friend request button") forState:UIControlStateNormal];
    
    
    _inviteButton = [[FriendController shared] friendInviteButton];
    [_inviteButton addTarget:self action:@selector(inviteFriend:) forControlEvents:UIControlEventTouchUpInside];
    [self.avatar setUserInteractionEnabled:YES];
    [self.avatar addSubview:_inviteButton];
    [_inviteButton setHidden:YES];
}

-(void)setRequestFriend:(FriendSearch *)requestFriend
{
    [_requestFriend removeObserver:self forKeyPath:@"invited"];
    _requestFriend = requestFriend;
    self.username.text = requestFriend.username;
    self.subtext.text  = [[RankManager shared]getCurrentRankNameWithExperience:requestFriend.experience];
    [self.avatar setDynamicImage:[requestFriend id] avatarId:[requestFriend avatar]];
    [self setInvited];
    [_requestFriend addObserver:self forKeyPath:@"invited" options:NSKeyValueObservingOptionNew context:nil];
    
    if(![[FriendController shared] isFriend:requestFriend.id])
    {
        [_inviteButton setHidden:NO];
    }else{
        [_inviteButton setHidden:YES];
    }
    
}

- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if ([keyPath isEqual:@"invited"]) {
        // do something with the changedName - call a method or update the UI here
        [self setInvited];
    }
}

-(void) setInvited
{
    NSString *title = NSLocalizedString(@"INVITE_FRIENDSHIP", @"Invite a person for a friendship");
    if(_requestFriend.invited)
    {
        title = NSLocalizedString(@"Invited", @"Person is invited for a friendship");
        //[self.button setEnabled:NO];
    }
    //[self.button setTitle:title forState:UIControlStateNormal];
    
    //remove invite button if invited
    if(_inviteButton && (_requestFriend.invited || [[FriendController shared] isFriend:_requestFriend.id]))
    {
        [_inviteButton setHidden:YES];
    }
    
}

- (IBAction)inviteFriend:(id)sender {
    DLog(@"Want to invite!");
    if ([self.delegate respondsToSelector:@selector(customFriendInviteCell:didTouchInviteForFriendRequest:)])
    {
        [self.delegate customFriendInviteCell:self didTouchInviteForFriendRequest:_requestFriend];
    }

}

- (IBAction)inviteForGame:(id)sender {
    if ([self.delegate respondsToSelector:@selector(customFriendInviteCell:didTouchInviteForGame:)])
    {
        [self.delegate customFriendInviteCell:self didTouchInviteForGame:_requestFriend];
    }
}

- (IBAction)replyToFriendInvite:(id)sender;
{
    if ([self.delegate respondsToSelector:@selector(customFriendInviteCell:didTouchToReplyToRequest:)])
    {
        [self.delegate customFriendInviteCell:self didTouchToReplyToRequest:_requestFriend];
    }
}

-(void)dealloc
{
    [_requestFriend removeObserver:self forKeyPath:@"invited"];
}

@end
