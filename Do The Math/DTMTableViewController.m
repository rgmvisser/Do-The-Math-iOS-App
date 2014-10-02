//
//  DTMTableViewController.m
//  dothemath
//
//  Created by Innovattic 1 on 11/12/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "DTMTableViewController.h"
#import "DTMCell.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADAdSize.h"
#import "InAppPurchase.h"
#import "User+Functions.h"



@interface DTMTableViewController () <GADBannerViewDelegate> {
    GADBannerView* _admob;
    BOOL _didReceiveAd;
}

@end

@implementation DTMTableViewController

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
    //self.tableView.rowHeight = 57;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_background.jpg"]];
    [backgroundImage setFrame:self.tableView.frame];    
    self.tableView.backgroundView = backgroundImage;
    
    _didReceiveAd = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAds) name:IAPHelperProductPurchasedNotification object:nil];
    
    [self checkAds];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) checkAds {

    if ( ![[User currentUser] isPremium]) {
        
        
        DLog(@"Loading ads");
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, kGADAdSizeBanner.size.height+15, 0.0f);
        if(_admob)
        {
            [_admob removeFromSuperview];
        }
        _admob = [[GADBannerView alloc]
                  initWithFrame:CGRectMake(0.0f,
                                           self.tableView.frame.size.height - kGADAdSizeBanner.size.height,
                                           kGADAdSizeBanner.size.width,
                                           kGADAdSizeBanner.size.height)];
        
        _admob.adUnitID = AdMob_ID;
        _admob.rootViewController = self;
        [_admob setDelegate:self];
        [self.tableView addSubview:_admob];
        
        
        GADRequest *r = [[GADRequest alloc] init];
        [_admob loadRequest:r];
        [self updateAdBounds];
    } else {
        DLog(@"No ads");
        [_admob removeFromSuperview];
        _admob.frame = CGRectMake(0, 0, 0, 0);
        [self updateAdBounds];
        //_admob = nil;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateAdBounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}




/*
 * Check if the cell is the first, last or both cell. The background image should be different
 */
-(DTMCell *)tableView:(UITableView *)tableView isFirstOrLastCell:(DTMCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if([tableView numberOfRowsInSection:indexPath.section] == 2 && indexPath.row == 1)
    {
        //DLog(@"FirstandLast");
        [cell isFirstAndLastCell];
    }else{
        if(indexPath.row == 1)
        {
            //DLog(@"First cell");
            [cell isFirstCell];
        }
        else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
        {
            //DLog(@"Last cell");
            [cell isLastCell];
        }
        else
        {
            //DLog(@"Normal cell");
            [cell isNormalCell];
        }
    }
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section] == 1)
    {
        //height startgame cell
        return 71;
    }
    if(indexPath.row == 0)
    {
        //DLog(@"height: 26");
        return 50; //header
        
    }
    if(indexPath.row == 1 && ([tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section] == 2))
    {
        //DLog(@"height: 65");
        return 65; //single
    }else{
        if(indexPath.row == 1)
        {
            //DLog(@"height: 57");
            return 58; //top
        }
        if([tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section]-1 == indexPath.row)
        {
            //DLog(@"height: 64");
            return 64; //last
        }
    }
    //DLog(@"height: 57");
    return 57; //middle
}

#pragma AdMob methods

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateAdBounds];
}

-(void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    _didReceiveAd = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, kGADAdSizeBanner.size.height+15, 0.0f);
    _admob.backgroundColor = [UIColor blackColor];
    _admob.hidden = NO;
    [self updateAdBounds];
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{
    _didReceiveAd = NO;
    _admob.hidden = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (void) updateAdBounds
{
    if ( _didReceiveAd ) {
        CGRect tableBounds = self.tableView.bounds;
        _admob.frame = CGRectMake(tableBounds.origin.x,
                                  tableBounds.origin.y + CGRectGetHeight(tableBounds) - CGRectGetHeight(_admob.frame),
                                  tableBounds.size.width,
                                  _admob.frame.size.height);
    }
}


@end
