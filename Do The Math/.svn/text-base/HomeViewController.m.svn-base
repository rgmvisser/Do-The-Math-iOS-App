//
//  HomeViewController.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/13/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "User+Functions.h"
#import "FriendSearch.h"
#import "Game+Functions.h"
#import "Friend+Functions.h"
#import "GameResultViewController.h"
#import "UIImageView+dynamicLoad.h"
#import "CustomGameCell.h"
#import "CustomFriendCell.h"
#import "CustomFriendInviteCell.h"
#import "GameInvite.h"
#import "BadgeManager.h"
#import "HeaderCell.h"
#import "ButtonCell.h"
#import "Flurry.h"
#import "AchievementManager.h"
#import "UIAlertView+BlockExtensions.h"
#import "FriendController.h"
#import "PremiumVersionViewController.h"
typedef enum {
    startSection = 0,
    friendInviteSection,
    gameInviteSection,
    turnSection,
    waitSection,
    completeSection
} Sections;


static int _numberOfGames;

@interface HomeViewController () <CustomFriendInviteCellDelegate,CustomFriendCellDelegate>
{
    NSMutableArray *_friendRequestList;
    NSMutableArray *_gameRequestList;
    NSMutableArray *_turnGameList;
    NSMutableArray *_waitGameList;
    NSMutableArray *_completeGameList;
    NSMutableArray *_contents;
    
    
    FriendSearch *_currentFriendRequest;
    GameInvite *_currentGameInvite;
    BOOL _first;
    int _reloadStatus;
    NSDate *_lastTimeRefresh;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *achievementButton;
@end

@implementation HomeViewController

+(BOOL)canPlayGame
{
    return ((_numberOfGames < MAX_NUM_GAMES) || [[User currentUser] isPremium]) ;
}

#pragma mark - LifeCycle methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _numberOfGames = 0;
    [self.tableView setTableFooterView:nil];
    //[self.achievementButton setTitle:NSLocalizedString(@"ACHIEVEMENTS", @"Achievements button")];
    //create all the lists
    _friendRequestList = [[NSMutableArray alloc] init];
    _gameRequestList = [[NSMutableArray alloc] init];
    _turnGameList = [[NSMutableArray alloc] init];
    _waitGameList = [[NSMutableArray alloc] init];
    _completeGameList = [[NSMutableArray alloc] init];
    _contents = [NSMutableArray arrayWithObjects:_friendRequestList,_gameRequestList,_turnGameList,_waitGameList,_completeGameList ,nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needToRefresh) name:@"needToRefresh" object:nil];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    if(![User currentUser]) {
        // if user is not logged in.
        DLog(@"Login needed");
        [self performSegueWithIdentifier:@"loginFirst" sender:self];
    }    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DLog(@"Did apper");
    if(![User currentUser]) {
        // if user is not logged in.
        DLog(@"Login needed");
        [self performSegueWithIdentifier:@"loginFirst" sender:self];
    } else {
        //DLog(@"Time interval: %f",[_lastTimeRefresh timeIntervalSinceNow]);
        if(!_lastTimeRefresh || [_lastTimeRefresh timeIntervalSinceNow] < -30)
        {
            [self refresh];
        }
        
        // Flurry dingen
        [Flurry setUserID:[NSString stringWithFormat:@"%@",[User currentUser].id] ];
        if ( [User currentUser].age != nil) {
            [Flurry setAge:[[User currentUser].age intValue]];
        }
        if ( [User currentUser].gender != nil) {
            [Flurry setGender:[User currentUser].gender];
        }
        
    }
    
    [self refreshList];
}

-(void)refreshList{
        
    // Get the games with status turn and wait
    NSFetchRequest *gameFetch = [Game fetchRequest];
    //dont get the deleted games
    NSPredicate *predicateResult = [NSPredicate predicateWithFormat:@"result != %@ || (result = nil) ",@"declined"];
    NSPredicate *predicateDeleted = [NSPredicate predicateWithFormat:@"deleted != 1"];
    NSArray *subPredicates = [NSArray arrayWithObjects:predicateResult, predicateDeleted, nil];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
    
    [gameFetch setPredicate:predicate];
    //sort the game on last action
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"lastAction"
                                        ascending:YES];
    
    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [gameFetch setSortDescriptors:descriptors];
    
    NSArray* games = [Game objectsWithFetchRequest:gameFetch];
    //DLog(@"Games: %@",games);
    [_turnGameList removeAllObjects];
    [_waitGameList removeAllObjects];
    [games enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Game *game = (Game *) obj;
        if([game.status isEqualToString:_TURN]) {
            [_turnGameList addObject:game];
        } else if ([game.status isEqualToString:_WAIT]) {
            [_waitGameList addObject:game];
        }
    }];
    
    // Get the game with status complete
    
    gameFetch = [Game fetchRequest];
    //sort the game on last action
    sortDescriptor = [[NSSortDescriptor alloc] 
                                        initWithKey:@"lastAction"
                                        ascending:NO];
    
    
    
    
    [gameFetch setPredicate:predicate];
    descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [gameFetch setSortDescriptors:descriptors];
    
    games = [Game objectsWithFetchRequest:gameFetch];
    [_completeGameList removeAllObjects];
    [games enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Game *game = (Game *) obj;
        if ([game.status isEqualToString:_COMPLETE]) {
            [_completeGameList addObject:game];
        }
    }];
    
    [self calculateNumberOfGames];
    [self.tableView reloadData];
}


#pragma mark - Events

/**
 *  Refreshes the current games and invites
 *  If the amount of loads is changed, also change the value in checkToStopLoading
 */
- (void) refresh {
    DLog(@"Refreshing");
    
    _lastTimeRefresh = [[NSDate alloc] init];
    _reloadStatus = 0;
    //DLog(@"Refresh them all!");
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/friend/invites/" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            //DLog(@"friend invites: %@",objects);
            [_friendRequestList removeAllObjects]; //empty array otherwise there will be duplicates
            [_friendRequestList addObjectsFromArray:objects];            
            [self checkToStopLoading];
        };
        
        loader.onDidFailWithError = ^(NSError *error){
            [self checkToStopLoading];
            DLog(@"Error failed to load friend invites:%@",error.localizedDescription);
        };
        
    }];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/match/invites/" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects){
            //DLog(@"game invites: %@",objects);
            [_gameRequestList removeAllObjects]; //empty array otherwise there will be duplicates
            [_gameRequestList addObjectsFromArray:objects];
            //DLog(@"Objects: %@",objects);
            [self checkToStopLoading];
        };
        
        loader.onDidFailWithError = ^(NSError *error){
            [self checkToStopLoading];
            DLog(@"Error failed to load game invites:%@",error.localizedDescription);
        };
        
    }];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/match/status/all" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects){
            //DLog(@"Games: %@",objects);
            [self checkToStopLoading];
            
        };
        
        loader.onDidFailWithError = ^(NSError *error){
            [self checkToStopLoading];
            DLog(@"Error failed to load game invites:%@",error.localizedDescription);
        };
        
    }];    
}

/**
 * if something in the app requires a refresh, like a game invite, the controller refreshes no matter the lasttimeupdate
 */
- (void) needToRefresh{
    DLog(@"Need to refresh");
    [self refresh];
}

/**
 * Check if the loader has to stop spinning
 * There are 3 loaders, so if 3 or more are loaded, stop the loader
 */
- (void) checkToStopLoading {
    _reloadStatus++;
    if ( _reloadStatus >= 3 ) {
        [self stopLoading];
        [self refreshList];
        [[BadgeManager shared] calculate:[NSArray arrayWithObjects:_friendRequestList,_turnGameList,_gameRequestList, nil]];
        [self calculateNumberOfGames];
        
    }
}

-(void)calculateNumberOfGames
{
    _numberOfGames = [_turnGameList count] + [_waitGameList count];
}



/*
 * Respond to a game request, if accepted, there will be made a game
*/
-(void)customFriendCell:(CustomFriendCell *)cell didTouchToReplyToGameInvite:(GameInvite *)gameInvite {
    
   
   _currentGameInvite = gameInvite;
   UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile")
                                                      message:NSLocalizedString(@"ACCEPT_GAME", @"Do you want to accept game")
                                                     completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView) {
                                                         if(buttonIndex == 0) {
                                                             [self declineGameInvite];
                                                         } else {
                                                             [self acceptGameInvite];
                                                         }
                                                     }
                                            cancelButtonTitle:NSLocalizedString(@"DECLINE",@"Decline game request")
                                            otherButtonTitles:NSLocalizedString(@"ACCEPT",@"Accept game request"),nil ];
    [message show];
  
}

-(void)acceptGameInvite {
    if([HomeViewController canPlayGame])
    {
        RKClient *client = [RKClient sharedClient];
        [client post:[NSString stringWithFormat:@"/match/invite/accept/%@",_currentGameInvite.id] usingBlock:^(RKRequest *request) {
            request.onDidLoadResponse = ^(RKResponse *response) {
                if(response.statusCode == 200) {
                    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"ACCEPTED", @"Game accepted") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
                    //[alert show];
                    [_gameRequestList removeObject:_currentGameInvite];
                    [self refresh];
                    [self.tableView reloadData];
                } else {
                    DLog(@"Failed to accept:%@",response);
                }
            };
            
            request.onDidFailLoadWithError = ^(NSError *error) {
                DLog(@"Accept Request failed:%@",error);
            };
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPGRADE_TO_PREMIUM", @"Upgrade to premium account") message:NSLocalizedString(@"MAX_GAMES_REACHED", @"U can only play x games in the free verion, please upgrade for more features and a ad free game.") completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView) {
            if(buttonIndex == 1)
            {
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
                
                PremiumVersionViewController *controller = (PremiumVersionViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"buyNavigation"];
                [self presentModalViewController:controller animated:YES];
            }
        } cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:NSLocalizedString(@"BUY", "Koop"),nil] show];
    }
}

-(void)declineGameInvite {
    RKClient *client = [RKClient sharedClient];
    [client post:[NSString stringWithFormat:@"/match/invite/decline/%@",_currentGameInvite.id] usingBlock:^(RKRequest *request) {
        request.onDidLoadResponse = ^(RKResponse *response) {
            if(response.statusCode == 200) {
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"DECLINED", @"Game decline") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
                //[alert show];
                [_gameRequestList removeObject:_currentGameInvite];
                [self refresh];
                [self.tableView reloadData];
            } else {
                DLog(@"Failed to decline:%@",response);
            }
        };
        
        request.onDidFailLoadWithError = ^(NSError *error) {
            DLog(@"Decline Request failed:%@",error);
        };
    }];

}

/*
 * Respond to a friend request, show a alert box if the user wants to be friends.
 */
-(void)customFriendInviteCell:(CustomFriendInviteCell *)cell didTouchToReplyToRequest:(FriendSearch *)requestFriend {
    _currentFriendRequest = requestFriend;
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile")
                                                      message:NSLocalizedString(@"FRIEND_INVITE", @"Do you want to confirm friend invite")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"DECLINE",@"Decline friend request")
                                            otherButtonTitles:NSLocalizedString(@"ACCEPT",@"Accept friend request"),nil];
    [message show];   
}


/**
 * Delegate function for the friend request, handles the choice of the user, if accepted, the players will be friends.
 */
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    FriendSearch *friend = _currentFriendRequest;
    if(buttonIndex == 1) {
        //accept friend request
        RKClient *client = [RKClient sharedClient];
        [client post:[NSString stringWithFormat:@"/friend/invite/%@/accept",friend.id] usingBlock:^(RKRequest *request) {
            request.onDidLoadResponse = ^(RKResponse *response) {
                if(response.statusCode == 200) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"ADDED", @"Friend added") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
                    [alert show];
                    [_friendRequestList removeObjectAtIndex:alertView.tag];
                    [[FriendController shared] getFriendsWithdelegate:nil];
                    [self.tableView reloadData];
                } else {
                    DLog(@"Failed to added:%@",response);
                }
            };
            
            request.onDidFailLoadWithError = ^(NSError *error) {
                DLog(@"Accept Request failed:%@",error);
            };
            
        }];
    } else {
        //decline friend request
        RKClient *client = [RKClient sharedClient];
        [client post:[NSString stringWithFormat:@"/friend/invite/%@/decline",friend.id] usingBlock:^(RKRequest *request) {
            request.onDidLoadResponse = ^(RKResponse *response) {
                if(response.statusCode == 200)
                {
                    DLog(@"Friend request declined! :%@",response);
                    
                    [_friendRequestList removeObjectAtIndex:alertView.tag];
                    [self.tableView reloadData];
                } else {
                    DLog(@"Failed to deciline:%@",response);
                }
            };
            
            request.onDidFailLoadWithError = ^(NSError *error) {
                DLog(@"Decline Request failed:%@",error);
            };
            
        }];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_contents count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    if(section == 0) {
        return 1;
    }    
    int count = [[_contents objectAtIndex:section-1] count];
    if(count != 0) {
        count++;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //define the cell identifiers.
    static NSString *newGamendetifier = @"startGameCell";
    static NSString *friendInviteIdentifier = @"friendInviteCell";
    static NSString *gameInviteIdentifier = @"gameInviteCell";
    static NSString *playGameIdentifier = @"playGameCell";
    static NSString *headerCellIndentifier = @"customHeaderCell";
    //DLog(@"Section: %d, Row:%d",indexPath.section,indexPath.row);
    UITableViewCell *cell;
    
    if(indexPath.section == startSection) {
        ButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:newGamendetifier];
        [buttonCell.button setTitle:NSLocalizedString(@"START_NEW_GAME", @"Start new game button") forState:UIControlStateNormal];
        return buttonCell;
    }
    
    
    if(indexPath.row == 0) {
        HeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:headerCellIndentifier];
        [headerCell setHeader:[self tableView:tableView titleForHeaderInSection:indexPath.section]];
        return headerCell;
    }
    
    
    
    switch ([indexPath section]) {
        case friendInviteSection: // Section 0 is friendInvite
        {
            CustomFriendInviteCell *customFriendInviteCell = [tableView dequeueReusableCellWithIdentifier:friendInviteIdentifier];
            FriendSearch *friendInvite = [[_contents objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row-1];
            [customFriendInviteCell setRequestFriend:friendInvite];
            customFriendInviteCell.delegate = self;
            
            return [self tableView:tableView isFirstOrLastCell:customFriendInviteCell indexPath:indexPath];;
            break;
        }
        case gameInviteSection: // Section 1 is gameInvite
        {
            CustomFriendCell *customFriendCell = [tableView dequeueReusableCellWithIdentifier:gameInviteIdentifier];
            GameInvite *gameInvite = [[_contents objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row-1];
            
            [customFriendCell setGameInvite:gameInvite];
            customFriendCell.delegate = self;
            return [self tableView:tableView isFirstOrLastCell:customFriendCell indexPath:indexPath];;
            break;
        }
        case turnSection: case waitSection: case completeSection: // Section 2,3,4 Different game sections
        {
            CustomGameCell *customGameCell = [tableView dequeueReusableCellWithIdentifier:playGameIdentifier];
            Game *game = [[_contents objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row-1];
            [customGameCell setGame:game];            
            /*UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
            [label setText:@"test"];
            [label setBackgroundColor:[UIColor blackColor]];
            customGameCell.editingAccessoryView = label;*/
            
            
            return [self tableView:tableView isFirstOrLastCell:customGameCell indexPath:indexPath];
            break;
        }
    }
    return cell;
}

/**
 * Give the sections of the table a correct header
 */
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if([[_contents objectAtIndex:section-1] count]) {
        switch (section) {
            case friendInviteSection: 
                return NSLocalizedString(@"FRIEND_INVITES" ,@"Friend invites");
                break;
            case gameInviteSection: 
                return NSLocalizedString(@"GAME_INVITES" ,@"Game invites");                
                break;
            case turnSection: 
                return NSLocalizedString(@"GAME_TURN" ,@"Turn game");
                break;
            case waitSection: 
                return NSLocalizedString(@"GAME_WAIT" ,@"Wait game");
                break;
            case completeSection:
                return NSLocalizedString(@"GAME_COMPLETE" ,@"Complete game");
                break;
        }
    }
    return @"";
}


/**
 * User did select row, seque if it is a game
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section-1 > 1 && indexPath.row != 0) {
        Game *game = [[_contents objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row-1];
        [Game setCurrentGame:game];
        
        [self performSegueWithIdentifier:@"goToGameResults" sender:self];
    }
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //DLog(@"Indexpath: %@",indexPath);
    if(indexPath.row == 0) {
        return NO; //never allow a header to be edited
    }
    switch (indexPath.section) {
        case friendInviteSection:
        case gameInviteSection:
        case turnSection:
        case waitSection:
            return NO;
            break;
        case completeSection:
            return YES;
            break;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete your data item here
        // Animate the deletion from the table.
        Game *gameToDelete;
        if ([indexPath section] == completeSection) {
            gameToDelete = [[_contents objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row-1];
            //[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",gameToDelete] message:@"test" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                
            [[_contents objectAtIndex:indexPath.section-1] removeObjectAtIndex:indexPath.row-1];
        }
        
        //This should send to the server
        DLog(@"/match/%d",[gameToDelete.gameId intValue]);
        RKClient *client = [RKClient sharedClient];
        [client delete:[NSString stringWithFormat:@"/match/%d",[gameToDelete.gameId intValue]] usingBlock:^(RKRequest *request) {
            request.onDidLoadResponse = ^(RKResponse *response) {
                if(response.statusCode == 200) {
                    DLog(@"Removed completed game :%@",gameToDelete);
                    [self.tableView reloadData];
                } else {
                    DLog(@"Failed to remove:%@",response);
                }
            };
            
            request.onDidFailLoadWithError = ^(NSError *error) {
                DLog(@"Remove failed:%@",error);
            };
        }];

        gameToDelete.deleted = [NSNumber numberWithInt:1];
        NSError *error;
        [[gameToDelete managedObjectContext] save:&error];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload {
    [self setAchievementButton:nil];
    [super viewDidUnload];
}
@end
