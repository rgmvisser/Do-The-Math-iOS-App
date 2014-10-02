//
//  FriendSearchViewController.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/20/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "FriendSearchViewController.h"
#import "FriendSearch.h"
#import "HeaderCell.h"
#import "CustomFriendInviteCell.h"
#import "SBJson.h"
#import "Flurry.h"
#import "FriendController.h"

@interface FriendSearchViewController () 

@property (nonatomic) BOOL noResult;
@property (retain,nonatomic) NSArray *users;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation FriendSearchViewController

@synthesize noResult = _noResult;
@synthesize users = _users;
@synthesize searchBar = _searchBar;

#pragma mark Inits

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
    }
    return self;
}

/**
 * Lazy initialization of the user object
 */
-(NSArray *) users
{
    if(!_users)
    {
        _users = [[NSArray alloc] init];
    }
    return _users;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"SEARCH_FRIENDS", @"Search for friends title")];
    [self.searchBar setPlaceholder:NSLocalizedString(@"TYPE_IN_USERNAME", @"Type in username.. placaholder")];
    
    self.noResult = NO;
    //style the searchbar
    for (UIView *view in [self.searchBar subviews])
    {
        if ([view isKindOfClass:NSClassFromString
             (@"UISearchBarBackground")])
        {
            [view removeFromSuperview];
        }
        //if subview is textfield, style it
        if([view isKindOfClass:NSClassFromString(@"UITextField")])
        {
            UITextField *textField = (UITextField *)view;
            [Appearance setTextFieldFont:textField];
        }

    }
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

/**
 * No sections are used, therefore only display the default one
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*
 * Number of rows, is equal to the count of users, if there are no users, show on row 3 no results (count is 3)
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [self.users count];
    if(self.noResult)
    {
        count = 3; //no results, show on the third row
    }
    else if(count > 0)
    {
        count++;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCellIdentifier = @"inviteCell";
    static NSString *noResultCellIdentifier = @"noResult";    
    
    UITableViewCell *cell;
    if(!self.noResult) //check if there are any results
    {
        if(indexPath.row == 0)
        {
            HeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
            [headerCell setHeader:NSLocalizedString(@"SEARCH_RESULT", @"Header for cell results from friend search")];
            return headerCell;
        }
        CustomFriendInviteCell *customInviteCell = [tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
        [customInviteCell.button setTitle:NSLocalizedString(@"PLAY", @"Play a game") forState:UIControlStateNormal];
        [customInviteCell.button setEnabled:YES];
        FriendSearch *friend = (FriendSearch*)[self.users objectAtIndex:indexPath.row-1];
        [customInviteCell setRequestFriend:friend];
        customInviteCell.delegate = self;
        customInviteCell = (CustomFriendInviteCell *)[self tableView:tableView isFirstOrLastCell:customInviteCell indexPath:indexPath];
        return customInviteCell;
    }
    else //no results, display "no result in third row"
    {
        cell = [tableView dequeueReusableCellWithIdentifier:noResultCellIdentifier];
        if(indexPath.row == 2)
        {
            [cell.textLabel setFont:[UIFont fontWithName:cell.textLabel.font.fontName size:20]];
            [Appearance setLabelFont:cell.textLabel];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
            cell.textLabel.text = NSLocalizedString(@"NO_RESULTS", "No friends found, no result");
        }
        else{
            cell.textLabel.text = @""; //only thrid row should display text
        }
        return cell;
    }
    
}



/**
 * Search for username
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //searchBar.text
    [self searchUsername:searchBar.text];
    
    [searchBar resignFirstResponder];
    
}
/**
 * send request to server for username
 */
- (void) searchUsername:(NSString *) username
{
    [[FriendController shared] searchUsernames:username delegate:self];
}


/**
 * Request to server failed
 */
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    self.users = [[NSArray alloc] init];
    DLog(@"Friend search fetching fail: %@",error.localizedDescription);
}

/**
 * Request to server success
 */
-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    self.users = objects;
    if([objects count] == 0) //no results
    {
        self.noResult = YES;
        
    }else{
        self.noResult = NO;
    }
    
    [self.tableView reloadData];
    
}

#pragma mark friend delegates


- (void) customFriendInviteCell:(CustomFriendInviteCell *)cell didTouchInviteForFriendRequest:(FriendSearch *)requestFriend
{
    [[FriendController shared] inviteForFriendRequest:requestFriend];
}

- (void) customFriendInviteCell:(CustomFriendInviteCell *)cell didTouchInviteForGame:(FriendSearch *)requestFriend
{
    [[FriendController shared] inviteForGame:requestFriend.id InViewController:self withCompletion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}


@end
