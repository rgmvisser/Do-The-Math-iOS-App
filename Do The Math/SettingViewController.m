//
//  SettingViewController.m
//  dothemath
//
//  Created by Innovattic 1 on 12/19/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "SettingViewController.h"
#import "UserCell.h"
#import "HeaderCell.h"
#import "ButtonCell.h"
#import "DTMCell.h"
#import "Appearance.h"
#import "User+Functions.h"
#import "Game+Functions.h"
#import "Friend+Functions.h"
#import <RestKit/RestKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PremiumVersionViewController.h"
#import "SoundController.h"
#import "SwitchCell.h"
#import "Flurry.h"


@interface SettingViewController () 

@end

@implementation SettingViewController

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
    [self setTitle:NSLocalizedString(@"SETTINGS", @"Settings title")];
   
    [Flurry logEvent:@"Settings opened"];
}

/**
 * User switched the soundeffect switch
 */
- (IBAction)soundEffectSwitched:(id)sender {
    UISwitch *soundSwitcher = (UISwitch *)sender;
    if(soundSwitcher.on)
    {
        DLog(@"Effects On");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SOUND_EFFECT];
    }
    else
    {
        DLog(@"Effects Off");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SOUND_EFFECT];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    
    return 1; //buy button

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([[User currentUser] isPremium])
    {
        return 5-1;
    }
    return 6-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *headerIndentifier = @"headerCell";
    static NSString *profileIdentifier = @"profileCell";
    static NSString *tutorialIdentifier = @"tutorialCell";
    static NSString *creditIdentifier = @"creditCell";
    static NSString *buyIdentifier = @"buyCell";
    static NSString *soundEffectIdentifier = @"soundEffectsCell";
    
    UserCell *cell;
    HeaderCell *headerCell;
    SwitchCell *switchCell;
    if(indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
                headerCell = [tableView dequeueReusableCellWithIdentifier:headerIndentifier];
                [headerCell setHeader:NSLocalizedString(@"SETTINGS", @"Header for cell settings")];
                return headerCell;
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:profileIdentifier];
                [cell.username setText:NSLocalizedString(@"PROFILE", @"Settings - profile")];
                return [self tableView:tableView isFirstOrLastCell:cell indexPath:indexPath];
                break;
            /*case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:tutorialIdentifier];
                [cell.username setText:NSLocalizedString(@"TUTORIAL", @"Settings - tutorial")];
                return [self tableView:tableView isFirstOrLastCell:cell indexPath:indexPath];
                break;*/
            case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:creditIdentifier];
                [cell.username setText:NSLocalizedString(@"CREDITS", @"Settings - credits")];
                return [self tableView:tableView isFirstOrLastCell:cell indexPath:indexPath];
                break;
            case 3:
                switchCell = [tableView dequeueReusableCellWithIdentifier:soundEffectIdentifier];
                [switchCell.soundEffectLabel setText:NSLocalizedString(@"SOUND_EFFECTS", @"Settings - sound effects")];
                DLog(@"Setting sound: %@",[[NSUserDefaults standardUserDefaults] objectForKey:SOUND_EFFECT]);
                if([[NSUserDefaults standardUserDefaults] objectForKey:SOUND_EFFECT])
                {
                    [switchCell.soundEffectSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:SOUND_EFFECT]];
                }
                return  [self tableView:tableView isFirstOrLastCell:switchCell indexPath:indexPath];
                break;
            case 4:
                cell = [tableView dequeueReusableCellWithIdentifier:buyIdentifier];
                [cell.username setText:NSLocalizedString(@"BUY_PREMIUM", @"Settings - buy")];
                return [self tableView:tableView isFirstOrLastCell:cell indexPath:indexPath];
                break;
            
            
        }
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:profileIdentifier];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"buySegue"]){
        ((PremiumVersionViewController *)segue.destinationViewController).isNotModal = YES;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"Indexpath %d", indexPath.row);
    /*if(indexPath.row == 2)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NOT_YET_AVAILABLE",@"Tuts are not yet availble") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }*/
}

- (void)viewDidUnload {

    [super viewDidUnload];
}


@end
