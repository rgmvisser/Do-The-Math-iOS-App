//
//  AchievementViewController.m
//  dothemath
//
//  Created by Innovattic 1 on 1/23/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "AchievementViewController.h"
#import "HeaderCell.h"
#import "AchievementCell.h"
#import "AchievementManager.h"
#import "UIAlertView+BlockExtensions.h"
#import "Flurry.h"

@interface AchievementViewController () {
    NSArray *_achievements;
    NSDictionary *_earnedAchievements;
    
}
@end

@implementation AchievementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:NSLocalizedString(@"ACHIEVEMENTS", @"Achievements title")];
    
    [Flurry logEvent:@"Achievements opened"];
    
    
    AchievementManager *aManager = [AchievementManager shared];
    if([aManager isLoggedIn]) {
        _achievements = [aManager achievementsList];
        _earnedAchievements = [aManager earndedAchievementList];
    } else {
        [aManager loginGameCenter];
    }
    if(!_achievements) {
        DLog(@"Not yet loaded");
        [self.activityIndicator startAnimating];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementsLoaded:) name:ACHIEVEMENT_DESCRIPTION_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(earnedAchievementsLoaded:) name:ACHIEVEMENT_EARNED_LOADED object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back:) name:NO_GC_LOGIN object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NO_GC_LOGIN object:nil];
}

-(void)achievementsLoaded:(id)sender {
    _achievements = [[AchievementManager shared] achievementsList];
    DLog(@"Achievements reloaded");
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
}

-(void)earnedAchievementsLoaded:(id)sender {
    _earnedAchievements = [[AchievementManager shared] earndedAchievementList];
    DLog(@"Achievements earned reloaded");
    [self.tableView reloadData];
}

/*
 * No sections are used, just the default one
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

/*
 * Returns the number of rows for the table. On redraw, automatically returns the new value
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [_achievements count];
    if(count > 0) {
        count++; //add one for the header
    }
    return count;
}

/*
 * Configure the custom cell with the correct username, avatar
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"achievementCell";
    static NSString *headerCellIdentifier = @"headerCell";
    if(indexPath.row == 0) {
        //header cell
        HeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
        [headerCell setHeader:NSLocalizedString(@"ACHIEVEMENTS", @"Header for cell achievements")];
        return headerCell;
    }
    AchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = (AchievementCell *)[self tableView:tableView isFirstOrLastCell:cell indexPath:indexPath];
    GKAchievementDescription *aDescription = [_achievements objectAtIndex:indexPath.row-1];
    [cell setAchievement:aDescription];
    GKAchievement *achievement = (GKAchievement *)[_earnedAchievements objectForKey:aDescription.identifier];
    if(achievement) {
        if(achievement.percentComplete >= 100.0) {
            [cell setEarned];
        }
    }
    
    return cell;
}


-(void)back:(id)sender {
    [Flurry logEvent:@"Achievements no Game Center"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GAMECENTER", @"Game center")  message:NSLocalizedString(@"NO_ACHIEVEMENTS_WITHOUT_GAMECENTER", @"Achievements are not available if there is no gamecenter account") completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView) {
        [self.navigationController popViewControllerAnimated:YES];
    } cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @"Ok"), nil];
    [alert show];
}

- (void)viewDidUnload {
    [self setActivityIndicator:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}
@end
