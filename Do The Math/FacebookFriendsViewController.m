//
//  FacebookFriendsViewController.m
//  dothemath
//
//  Created by Innovattic 1 on 10/25/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "FacebookFriendsViewController.h"
#import "FriendSearchViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <RestKit/RestKit.h>
#import "CustomFaceBookFriendCell.h"
#import "CustomFriendInviteCell.h"
#import "FriendSearch.h"
#import "HeaderCell.h"
#import "SBJson.h"
#import "Flurry.h"
#import "FriendController.h"
#import "User+Functions.h"
#import "PostToFacebookViewController.h"

@interface FacebookFriendsViewController () <CustomFriendInviteCellDelegate>
{
    NSArray *_facebookFriends;
    NSArray *_noFacebookFriends;
    NSMutableDictionary *_allFriends;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation FacebookFriendsViewController

#pragma mark Inits

@synthesize loadingIndicator = _loadingIndicator;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"FACEBOOK", @"Facebook title")];
    //init al the lists
    _facebookFriends = [[NSArray alloc] init];
    _noFacebookFriends = [[NSArray alloc] init];
    _allFriends = [[NSMutableDictionary alloc] init];
    
    //get all friends via the Facebook api
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        
        NSArray* friends = [result objectForKey:@"data"];
        NSMutableArray *friendIds = [[NSMutableArray alloc] init];
        for (NSDictionary<FBGraphUser>* friend in friends) {
            [friendIds addObject:friend.id];
            [_allFriends setObject:friend forKey:friend.id];
        }
        //get all the do the math players whom are the users friend
        [[RKClient sharedClient] post:@"/friend/facebook/" usingBlock:^(RKRequest *request) {
                       
          
            [request setHTTPBodyString:[friendIds JSONRepresentation]];
            request.onDidLoadResponse = ^(RKResponse *response){
                if(response.statusCode == 200)
                {
                    NSError *error;
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:response.body options:kNilOptions error:&error];
                    //set the lists
                    _facebookFriends = [dictionary objectForKey:@"facebook_friends"];
                    _noFacebookFriends = (NSArray *)[dictionary objectForKey:@"no_facebook_friends"];

                    _noFacebookFriends = [_noFacebookFriends sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        NSDictionary<FBGraphUser>* firstPerson = [_allFriends objectForKey:[NSString stringWithFormat:@"%@",obj1]];
                        NSDictionary<FBGraphUser>* secondPerson = [_allFriends objectForKey:[NSString stringWithFormat:@"%@",obj2]];
                        return [firstPerson.first_name caseInsensitiveCompare:secondPerson.first_name];
                        
                    }];
                    [self.loadingIndicator stopAnimating];
                    
                    [self.tableView reloadData];
                }
                else{
                    
                }
            };
                        
            request.onDidFailLoadWithError = ^(NSError *error){
                DLog(@"Failed to send facebook friends, error:%@",error);
            };
        }];
        
        
    }];
    [Flurry logEvent:@"New game Facebookfriends"];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.

    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    switch (section) {
        case 0: //friends who play dtm
            count = [_facebookFriends count];
            break;
        case 1: // friends who not yet play dtm
            count = [_noFacebookFriends count];
        default:
            break;
    }
    if(count > 0)
    {
        count++;
    }
    
    // Return the number of rows in the section.
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *facebookCellIdentifier = @"facebookFriendCell";
    static NSString *inviteCellIdentifier = @"inviteCell";
    CustomFriendInviteCell *customFriendInviteCell;
    CustomFaceBookFriendCell *faceBookFriendCell;
    //first cell is header
    if(indexPath.row == 0)
    {
        HeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        if(indexPath.section == 0)
        {
            [headerCell setHeader:NSLocalizedString(@"DOTHEMATH_PLAYERS", @"Header for cell facebook friends who already play Do The Math")];
        }
        else
        {
            [headerCell setHeader:NSLocalizedString(@"FACEBOOK_FRIENDS", @"Header for cell facebook friends who not yet play Do The Math")];
        }
        return headerCell;
    }
    //init the table cells
    switch (indexPath.section) {
        case 0:
        {
            customFriendInviteCell = (CustomFriendInviteCell *)[tableView dequeueReusableCellWithIdentifier:inviteCellIdentifier forIndexPath:indexPath];
            FriendSearch *friendSearch = [[FriendSearch alloc] init];
            friendSearch.username = [[_facebookFriends objectAtIndex:indexPath.row-1]  valueForKey:@"username"];
            friendSearch.avatar = [[_facebookFriends objectAtIndex:indexPath.row-1]  valueForKey:@"avatar"];
            friendSearch.id = [[_facebookFriends objectAtIndex:indexPath.row-1] valueForKey:@"id"];
            friendSearch.experience = [[[NSNumberFormatter alloc] init] numberFromString:[[_facebookFriends objectAtIndex:indexPath.row-1] valueForKey:@"experience"]];
            [customFriendInviteCell.button setTitle:NSLocalizedString(@"PLAY", @"Play a game") forState:UIControlStateNormal];
            [customFriendInviteCell setRequestFriend:friendSearch];
            customFriendInviteCell.delegate = self;
            customFriendInviteCell = (CustomFriendInviteCell *)[self tableView:tableView isFirstOrLastCell:customFriendInviteCell indexPath:indexPath];
            return customFriendInviteCell;
            break;
        }
        case 1:
        {
            faceBookFriendCell = (CustomFaceBookFriendCell *)[tableView dequeueReusableCellWithIdentifier:facebookCellIdentifier forIndexPath:indexPath];
             //faceBookFriendCell.avatar
            NSDictionary<FBGraphUser>* friend = [_allFriends objectForKey:[NSString stringWithFormat:@"%@",[_noFacebookFriends objectAtIndex:indexPath.row-1]]];
            
            [faceBookFriendCell setFaceBookFriend:friend];
            faceBookFriendCell.delegate = self;
            faceBookFriendCell = (CustomFaceBookFriendCell *)[self tableView:tableView isFirstOrLastCell:faceBookFriendCell indexPath:indexPath];

            return faceBookFriendCell;
            break;
        }
        default:
            return [[UITableViewCell alloc] init];
            break;
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - Table view delegate




/*
 * User did touch button to post on facebook wall
 */
-(void)facebookFriendCell:(CustomFaceBookFriendCell *)cell didTouchToInviteByFacebook:(NSDictionary<FBGraphUser> *)facebookFriend
{
    [Flurry logEvent:@"Invite friend with Facebook wall post"];
    [PostToFacebookViewController inviteFBFriend:facebookFriend sender:self];

}

- (void)customFriendInviteCell:(CustomFriendInviteCell *)cell didTouchInviteForFriendRequest:(FriendSearch *)requestFriend
{
    [Flurry logEvent:@"Facebook friend invite"];
    [[FriendController shared] inviteForFriendRequest:requestFriend];
}

- (void) customFriendInviteCell:(CustomFriendInviteCell *)cell didTouchInviteForGame:(FriendSearch *)requestFriend
{
    [[FriendController shared] inviteForGame:requestFriend.id InViewController:self withCompletion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}


/**
 * A function for parsing URL parameters.
 */
/* Not used anymore (we think)
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

// Handle the publish feed call back
- (void)dialogCompleteWithUrl:(NSURL *)url {
    NSDictionary *params = [self parseURLParams:[url query]];
    NSString *msg = [NSString stringWithFormat:
                     @"Posted story, id: %@",
                     [params valueForKey:@"post_id"]];
    DLog(@"%@", msg);
    // Show the result in an alert
    [[[UIAlertView alloc] initWithTitle:@"Result"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
}*/


- (void)viewDidUnload {
    [self setLoadingIndicator:nil];
    [super viewDidUnload];
}




@end
