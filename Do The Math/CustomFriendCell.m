//
// CustomFriendCell.m
// Do The Math
//
// Created by Rogier Slag on 9/20/12.
// Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "CustomFriendCell.h"
#import "Friend+Functions.h"
#import "UIImageView+dynamicLoad.h"
#import "Game+Functions.h"
#import "DifficultyView.h"
#import "RankManager.h"

@interface CustomFriendCell()
{
    Friend *_friend;
    GameInvite *_gameInvite;
}
@property (weak, nonatomic) IBOutlet DifficultyView *difficultyView;

@end

@implementation CustomFriendCell

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
    
     
}


-(void)setFriend:(Friend *)friend{
    _friend = friend;
    [self.button setTitle:NSLocalizedString(@"PLAY", @"Play button") forState:UIControlStateNormal];
    self.username.text = friend.username;
    self.subtext.text  = [[RankManager shared] getCurrentRankNameWithExperience:friend.experience];
    [self.avatar setDynamicImage:[friend id] avatarId:[friend avatar]];
}

/**
 * Set the invite for the game
 */
-(void)setGameInvite:(GameInvite *)gameInvite
{
    _gameInvite = gameInvite;    
    [self.difficultyView setDifficulty:_gameInvite.difficulty withLabel:YES];
    [self setFriend:gameInvite.friend];
    [self.button setTitle:NSLocalizedString(@"RESPOND", @"Respond button") forState:UIControlStateNormal];
}


- (IBAction)inviteForGame:(id)sender {
    if ([self.delegate respondsToSelector:@selector(customFriendCell:didTouchInviteForGame:)])
    {
        [self.delegate customFriendCell:self didTouchInviteForGame:_friend];
    }
}

- (IBAction)replyToGameInvite:(id)sender {
    if ([self.delegate respondsToSelector:@selector(customFriendCell:didTouchToReplyToGameInvite:)])
    {
        [self.delegate customFriendCell:self didTouchToReplyToGameInvite:_gameInvite];
    }
}



@end
