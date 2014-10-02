//
//  NewGameViewController.m
//  dothemath
//
//  Created by Innovattic 1 on 10/9/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "NewGameViewController.h"
#import "User+Functions.h"
#import "HeaderCell.h"
#import "DTMTableViewController.h"
#import "Appearance.h"
#import "Game+Functions.h"
#import <RestKit/RestKit.h>
#import "Flurry.h"
#import "UserCell.h"
#import "TwitterController.h"
#import "HomeViewController.h"
#import "UIAlertView+BlockExtensions.h"

enum ROWS {
    HEADER = 0,
    FRIENDS = 1,
    FACEBOOK = 2,
    TWITTER = 3,
    RANDOM = 4,
    EMAIL = 5
    };

@interface NewGameViewController ()

@end

@implementation NewGameViewController

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
    [self setTitle:NSLocalizedString(@"NEW_GAME", @"New game title")];
    
    [Flurry logEvent:@"New game"];
    
    //Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *friendInviteIdentifier = @"friendCell";
    static NSString *facebookIdentifier = @"facebookCell";
    static NSString *twitterIdentifier = @"twitterCell";
    //static NSString *emailIdentifier = @"emailCell";
    static NSString *randomIdentifier = @"randomCell";
    static NSString *headerIndentifier = @"headerCell";
    UserCell *cell;
    HeaderCell *headerCell;
    switch (indexPath.row) {
        case HEADER:
            headerCell = [tableView dequeueReusableCellWithIdentifier:headerIndentifier];
            [headerCell setHeader:NSLocalizedString(@"NEW_GAME", @"Header for cell new game")];
            return headerCell;
            break;
        case FRIENDS:
            cell = [tableView dequeueReusableCellWithIdentifier:friendInviteIdentifier];
            [cell.username setText:NSLocalizedString(@"FRIENDS", @"Friends cell")];
            [Appearance setCellLabel:cell.username];
            return [self tableView:tableView isFirstOrLastCell:cell indexPath:indexPath];;
            break;
        case FACEBOOK:
            cell = [tableView dequeueReusableCellWithIdentifier:facebookIdentifier];
            [cell.username setText:NSLocalizedString(@"FACEBOOK", @"Facebook cell")];
            [Appearance setCellLabel:cell.username];
            return [self tableView:tableView isFirstOrLastCell:cell indexPath:indexPath];
            break;
        case TWITTER:
             cell = [tableView dequeueReusableCellWithIdentifier:twitterIdentifier];
             [cell.username setText:NSLocalizedString(@"TWITTER", @"Twitter cell")];
             [Appearance setCellLabel:cell.username];
             return [self tableView:tableView isFirstOrLastCell:cell indexPath:indexPath];;
             break;
        /*case EMAIL:
            cell = [tableView dequeueReusableCellWithIdentifier:emailIdentifier];
            [cell.username setText:NSLocalizedString(@"EMAIL_INVITE", @"EMAIL cell")];
            [Appearance setCellLabel:cell.username];
            return [self tableView:tableView isFirstOrLastCell:cell indexPath:indexPath];;
            break;*/
        case RANDOM:
            cell = [tableView dequeueReusableCellWithIdentifier:randomIdentifier];
            [cell.username setText:NSLocalizedString(@"RANDOM", @"Random player cell")];
            [Appearance setCellLabel:cell.username];
            return [self tableView:tableView isFirstOrLastCell:cell indexPath:indexPath];;
            break;
        default:
          break;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:friendInviteIdentifier];
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == FRIENDS)
    {
        DLog(@"Friend");
    }
    if(indexPath.row == FACEBOOK)
    {
        if([[User currentUser] isFacebookUser])
        {
            [self performSegueWithIdentifier:@"searchFacebookFriend" sender:self];
        }else{
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"NO_FACEBOOK_USER", @"Current user is not a facebook user, please connect") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
            [alert show];

        }
    }
    if(indexPath.row == EMAIL)
    {
        DLog(@"E-mail someone");
        [self performSegueWithIdentifier:@"emailFriend" sender:self];
    }
    if(indexPath.row == RANDOM)
    {
        DLog(@"Random opponent");
        [self inviteRandom];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    if(indexPath.row == TWITTER)
    {
        DLog(@"Twitter");
        [[TwitterController shared] tweetFrom:self tweet:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    
}

-(void)inviteRandom
{
    if([HomeViewController canPlayGame])
    {
        UIActionSheet *difficultyActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"SELECT_DIFFICULTY", @"Select the difficulty of a game")
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel invite for game")
                                                             destructiveButtonTitle:nil
                                                                  otherButtonTitles:_DIFFICULTY_1,_DIFFICULTY_2,_DIFFICULTY_3,_DIFFICULTY_4,nil];
        [difficultyActionSheet showInView:self.view];
    }else{    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPGRADE_TO_PREMIUM", @"Upgrade to premium account") message:NSLocalizedString(@"MAX_GAMES_REACHED", @"U can only play x games in the free verion, please upgrade for more features and a ad free game.") completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView) {
            if(buttonIndex == 1)
            {                
                [self performSegueWithIdentifier:@"showOwnAd" sender:self];
            }
        } cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:NSLocalizedString(@"BUY", "Koop"),nil];
        [alertView show];
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int difficulty = 1;
    if(buttonIndex == 0) //easy selected
    {
        difficulty = 1;
        [Flurry logEvent:@"Random game invite easy"];
    }
    if(buttonIndex == 1) //medium selected
    {
        difficulty = 2;
        [Flurry logEvent:@"Random game invite medium"];
    }
    if(buttonIndex == 2) //hard selected
    {
        difficulty = 3;
        [Flurry logEvent:@"Random game invite hard"];
    }
    if(buttonIndex == 3) //evil selected
    {
        difficulty = 4;
        [Flurry logEvent:@"Random game invite evil"];
    }
    if(buttonIndex != 4) //cancel
    {
        [self sendRandomInvite:difficulty];
    }
}

-(void) sendRandomInvite:(int) difficulty
{
    RKClient *client = [RKClient sharedClient];
    [client post:[NSString stringWithFormat:@"/match/invite/random/difficulty/%d",difficulty] usingBlock:^(RKRequest *request) {
        request.onDidLoadResponse = ^(RKResponse *response) {
            if(response.statusCode == 200)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"RANDOM_GAME_INVITE_SEND", @"Random game invite send") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
                [alert show];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            else{
                DLog(@"Failed to random invite for game:%@",response);
            }
        };
        
        request.onDidFailLoadWithError = ^(NSError *error) {
            DLog(@"Request failed to random invite for game:%@",error);
        };
        
    }];
}




@end
