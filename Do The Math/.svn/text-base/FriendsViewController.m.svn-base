//
//  FriendsViewController.m
//  Do The Math
//
//  Created by Rogier Slag on 9/18/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "FriendsViewController.h"
#import "Friend.h"
#import "Friend+Functions.h"
#import "FriendSearch.h"
#import "CustomFriendCell.h"
#import "Game+Functions.h"
#import "HeaderCell.h"
#import "AppDelegate.h"
#import "Flurry.h"
#import "User+Functions.h"
#import <iAd/iAd.h>
#import "FriendController.h"
#import "AchievementManager.h"

@interface FriendsViewController () <CustomFriendCellDelegate,ADBannerViewDelegate>
{
    NSArray *_friendList;
    Friend *_currentFriend;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ADBannerView *bannerView;
@end

@implementation FriendsViewController

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

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //check for any updates on the server
    [self setTitle:NSLocalizedString(@"FRIENDS", @"Friends title")];
    
    //fetch friend list from core data
    /*NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"username" ascending:YES];
    NSFetchRequest *friendFetch = [Friend fetchRequest];
    [friendFetch setSortDescriptors:[NSArray arrayWithObject:nameSort]];
    _friendList = [Friend objectsWithFetchRequest:friendFetch];
    [self.tableView reloadData];*/
    [Flurry logEvent:@"New game Friends"];
    
    if ( ! [User currentUser].premium) {
        _bannerView = [[ADBannerView alloc]
                   initWithFrame:CGRectZero];
    
        _bannerView.delegate = self;
    }
    
    /*NSFetchRequest *friendDeleteFetch = [Friend fetchRequest];
    NSArray *friends = [Friend objectsWithFetchRequest:friendDeleteFetch];
    [friends enumerateObjectsUsingBlock:^(id friend,NSUInteger idx,BOOL *stop) {
        [[NSManagedObjectContext contextForCurrentThread] deleteObject:friend];
    }];*/
    
    _friendList = [[FriendController shared] getFriendsWithdelegate:self];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 * If the reload of data was successfull, save the new data to the view and force a reload of the table
 */
- (void) objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    _friendList = objects;
    [[FriendController shared] setFriends:[objects mutableCopy]];
    [[AchievementManager shared] friends:[_friendList count]];
    [self.tableView reloadData];
}

- (void) objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    DLog(@"Friend fetching fail: %@",error.localizedDescription);
}





/*
 * No sections are used, just the default one
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

/*
 * Returns the number of rows for the table. On redraw, automatically returns the new value
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_friendList count];
    if(count > 0)
    {
        count++; //add one for the header
    }
    return count;
}

/*
 * Configure the custom cell with the correct username, avatar
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendCell";
    static NSString *headerCellIdentifier = @"headerCell";
    if(indexPath.row == 0) //header cell
    {
        HeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
        [headerCell setHeader:NSLocalizedString(@"FRIENDS", @"Header for cell friends")];
        return headerCell;
    }    
    CustomFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setFriend:(Friend *)[_friendList objectAtIndex:indexPath.row-1]];
    cell.delegate = self;
    cell = (CustomFriendCell *)[self tableView:tableView isFirstOrLastCell:cell indexPath:indexPath];
    return cell;
}

- (void)customFriendCell:(CustomFriendCell *)cell didTouchInviteForGame:(Friend *)friend
{
    [[FriendController shared] inviteForGame:friend.id InViewController:self withCompletion:^{
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }];
}

#pragma iAd delegates
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    self.tableView.tableFooterView = _bannerView;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    DLog(@"banner error %@",error.localizedDescription);
    self.tableView.tableFooterView = nil;
}
@end



