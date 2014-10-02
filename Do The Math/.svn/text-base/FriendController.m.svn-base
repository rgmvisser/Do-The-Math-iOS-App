//
//  FriendController.m
//  dothemath
//
//  Created by Innovattic 1 on 1/11/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "FriendController.h"
#import "Friend+Functions.h"
#import "Game+Functions.h"
#import "FriendSearch.h"
#import "CustomFriendInviteCell.h"
#import <RestKit/RestKit.h>
#import "Flurry.h"
#import "UIActionSheet+BlockExtensions.h"
#import "UIAlertView+BlockExtensions.h"
#import "HomeViewController.h"
#import "AchievementManager.h"
#import "PremiumVersionViewController.h"



@interface FriendController() <RKObjectLoaderDelegate>{
    NSMutableArray *_invitedFriends;
    NSMutableArray *_friends;
}

@end
@implementation FriendController

static FriendController *_friendController;

+ (FriendController *) shared {
    if(!_friendController) {
        _friendController = [[FriendController alloc] init];
        [_friendController getFriendsWithdelegate:_friendController];
    }
    return _friendController;
}

- (id) init{
    self = [super init];
    if(self) {
        _invitedFriends = [[NSMutableArray alloc] init];
        if([[NSUserDefaults standardUserDefaults] objectForKey:FRIEND_INVITES])
        {
            _invitedFriends = [[NSUserDefaults standardUserDefaults] objectForKey:FRIEND_INVITES];
        }
        
        _friends = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

/**
 * Friend invite button is pressed, send a request to the server to invite friend.
 */
- (void) inviteForFriendRequest:(FriendSearch *)requestFriend {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADD_FRIEND_TITLE", @"Title if you want to add a friend") message:NSLocalizedString(@"DO_YOU_WANT_FRIEND",@"Do you want to add as a friend") completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView) {
            if(buttonIndex == 1) {
                RKClient *client = [RKClient sharedClient];
                
                //user id is saved in the tag of the button
                [client post:[NSString stringWithFormat:@"/friend/invite/%@",[NSString stringWithFormat:@"%@",requestFriend.id]]  usingBlock:^(RKRequest *request) {
                    request.onDidLoadResponse = ^(RKResponse *response) {
                        if(response.statusCode == 200) {
                            requestFriend.invited = YES;
                            [_invitedFriends addObject:requestFriend.id];
                            [[NSUserDefaults standardUserDefaults] setObject:_invitedFriends forKey:FRIEND_INVITES];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"FRIEND_INVITED", @"Friend invite send") completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView) { } cancelButtonTitle:NSLocalizedString(@"OK", @"Ok") otherButtonTitles:nil];
                            [alert show];
                            [Flurry logEvent:@"Friend invite"];
                            
                        } else {
                            DLog(@"Failed to invite:%@",[response description]);
                        }
                    };
                    
                    request.onDidFailLoadWithError = ^(NSError *error) {
                        DLog(@"Request failed:%@",error);
                    };
                    
                }];
                
            }
        } cancelButtonTitle:NSLocalizedString(@"NO", @"No") otherButtonTitles:NSLocalizedString(@"YES", @"Yes"),nil];
    [alert show];
}

- (void) inviteForGame:(NSNumber *)friendId InViewController:(UIViewController *)vc withCompletion:(void (^)())completion {
    if([HomeViewController canPlayGame])
    {
        UIActionSheet *inviteSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"SELECT_DIFFICULTY", @"Select the difficulty of a game")
                                                                 completionBlock:^(NSUInteger buttonIndex, UIActionSheet *actionSheet) {
                                                                     int difficulty = 1;
                                                                     if(buttonIndex == 0 || buttonIndex == 1 || buttonIndex == 2 || buttonIndex == 3 ) //invite to game
                                                                     {
                                                                         //DLog(@"bttonindex:%d",buttonIndex);
                                                                         if(buttonIndex == 0) //easy selected
                                                                         {
                                                                             difficulty = 1;
                                                                             [Flurry logEvent:@"Game invite easy"];
                                                                         }
                                                                         if(buttonIndex == 1) //medium selected
                                                                         {
                                                                             difficulty = 2;
                                                                             [Flurry logEvent:@"Game invite medium"];
                                                                         }
                                                                         if(buttonIndex == 2) //hard selected
                                                                         {
                                                                             difficulty = 3;
                                                                             [Flurry logEvent:@"Game invite hard"];
                                                                         }
                                                                         if(buttonIndex == 3) //evil selected
                                                                         {
                                                                             difficulty = 4;
                                                                             [Flurry logEvent:@"Game invite evil"];
                                                                         }
                                                                         [self inviteFriendforGame:friendId WithDifficulty:difficulty WithCompletion:completion];
                                                                     }
     
                                                                 }
                                                        cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel invite for game")
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:_DIFFICULTY_1,_DIFFICULTY_2,_DIFFICULTY_3,_DIFFICULTY_4, nil];
        [inviteSheet showInView:vc.view];
    }else{
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPGRADE_TO_PREMIUM", @"Upgrade to premium account") message:NSLocalizedString(@"MAX_GAMES_REACHED", @"U can only play x games in the free verion, please upgrade for more features and a ad free game.") completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView) {
            if(buttonIndex == 1)
            {
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
                
                PremiumVersionViewController *controller = (PremiumVersionViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"buyNavigation"];
                [vc presentModalViewController:controller animated:YES];
                
                
                //[BuyPremiumVersion buy]; @TODO buy screen from here
            }
        } cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:NSLocalizedString(@"BUY", "Koop"),nil];
        [alertview show];
    }
}

/**
 * handle the action of the user when the game invite button is pressed
 */
- (void) inviteFriendforGame:(NSNumber *)friendId WithDifficulty:(int)difficulty WithCompletion:(void (^)())completion {
            
    RKClient *client = [RKClient sharedClient];
    [client post:[NSString stringWithFormat:@"/match/invite/%@/difficulty/%d",friendId,difficulty] usingBlock:^(RKRequest *request) {
        request.onDidLoadResponse = ^(RKResponse *response) {
            if(response.statusCode == 200) {
                /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"GAME_INVITE_SEND", @"Game invite send") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
                [alert show];*/
                [[NSNotificationCenter defaultCenter] postNotificationName:@"needToRefresh" object:self];
                completion();
            } else {
                DLog(@"Failed to invite for game:%@",response);
            }
        };
        
        request.onDidFailLoadWithError = ^(NSError *error) {
            DLog(@"Request failed to invite for game:%@",error);
        };
    }];
}


/**
 * Search on usernames
 */
- (void) searchUsernames:(NSString *)username delegate:(id)delegate {
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/friend/search/%@",[username stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]] delegate:delegate];
}

/**
 * Load all friends from server
 */
- (NSMutableArray *) getFriendsWithdelegate:(id)delegate {
    if(!delegate)
    {
        delegate = self;
    }
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/friend" delegate:delegate];
    return _friends;
}

- (BOOL) isFriend:(NSNumber *)friendId {

    NSFetchRequest *friendFetch = [Friend fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@",friendId];
    [friendFetch setPredicate:predicate];

    NSArray* friends = [Friend objectsWithFetchRequest:friendFetch];
    
    
    for(NSNumber *num in _invitedFriends)
    {
        if([num intValue] == [friendId intValue])
        {
            return YES;
        }
    }
    if([friends count] > 0 )
    {
        return YES;
    } else {
        return NO;
    }
}

-(UIButton *)friendInviteButton {

    UIButton *inviteButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [inviteButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [inviteButton setImage:[UIImage imageNamed:@"Button_addfriend.png"] forState:UIControlStateNormal];
    [inviteButton setFrame:CGRectMake(0, 0, 50, 50)];

    return inviteButton;
}

/**
 * If the reload of data was successfull, save the new data to the view and force a reload of the table
 */
- (void) objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    _friends = [objects mutableCopy];
    [[AchievementManager shared] friends:[_friends count]];
}

- (void) objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    DLog(@"Friend fetching fail: %@",error.localizedDescription);
}

-(void)setFriends:(NSMutableArray *)friends
{
    _friends = friends;
}


@end
