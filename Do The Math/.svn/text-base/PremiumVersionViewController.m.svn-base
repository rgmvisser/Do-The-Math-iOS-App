//
//  PremiumVersionViewController.m
//  dothemath
//
//  Created by Rogier Slag on 08/01/2013.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "PremiumVersionViewController.h"
#import "InAppPurchase.h"
#import "Appearance.h"
#import "DTMInAppPurchase.h"
#import "Flurry.h"

static NSArray *_products;

@interface PremiumVersionViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UILabel *tiredOf;
@property (weak, nonatomic) IBOutlet UILabel *buyDTMLabel;
@property (weak, nonatomic) IBOutlet UILabel *noAdsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noWaiting;
@property (weak, nonatomic) IBOutlet UILabel *noGameRistriction;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UILabel *restoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;


@end

@implementation PremiumVersionViewController {
    NSTimer* _timer;
    int _sec;
    BOOL _goingOffScreen;
}

+(void) getProducts{
    [[DTMInAppPurchase sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {

            _products = products;
        }
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:NSLocalizedString(@"BUY_PREMIUM", @"Buy premium title")];
    [Appearance setLabelFont:self.tiredOf];
    [Appearance setLabelFont:self.buyDTMLabel];
    [Appearance setLabelFont:self.noAdsLabel];
    [Appearance setLabelFont:self.noGameRistriction];
    [Appearance setLabelFont:self.noWaiting];
    [Appearance setLabelFont:self.restoreLabel];
    [Appearance setStyleButton:self.buyButton];
    [Appearance setStyleButton:self.restoreButton];

    
    [self.tiredOf setText:NSLocalizedString(@"TIRED_OF_ADS", @"Helemaal klaar met reclames? Wil je ook een onbeperkt aantal spellen spelen?")];
    [self.buyDTMLabel setText:NSLocalizedString(@"UPGRADE_TO_PREMIUM_LIST", @"Upgrade naar Do The Math Premium:")];
    [self.noAdsLabel setText:NSLocalizedString(@"NO_ADS", @"Geen reclames")];
    [self.noWaiting setText:NSLocalizedString(@"NO_WAITING", @"Geen wachttijden")];
    [self.noGameRistriction setText:NSLocalizedString(@"UNLIMITED_GAMES", @"Onbeperkt aantal spellen")];
    [self.restoreLabel setText:NSLocalizedString(@"ALL_BOUGHT", @"Heb je Do The Math al een keer gekocht, activeer dan je vorige aankoop")];
 
    [self setButtonText];
    
    
    
    
    
    [self.background setImage:[UIImage imageNamed:@"result_background_2.jpg"]];
    
    
    if(!self.withTimer)
    {
        _sec = 0;
        self.backButton.title = [NSString stringWithFormat:NSLocalizedString(@"CLOSE", @"Sluit")];
    }else{
       [self.backButton setEnabled:NO];
        _sec = 3;
        self.backButton.title = [NSString stringWithFormat:@"%d",_sec];
    }
    if (self.isNotModal) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    _goingOffScreen = NO;
    _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(increaseCount) userInfo:nil repeats:YES];
}

-(void)setButtonText{
    
    NSString *stringPrice = @"";
    if(_products){
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:((SKProduct *)[_products objectAtIndex:0]).priceLocale];
        stringPrice = [numberFormatter stringFromNumber:((SKProduct *)[_products objectAtIndex:0]).price];
        stringPrice = [NSString stringWithFormat:@" (%@)",stringPrice];
    }
    
    
    [self.buyButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"UPGRADEN", @"Upgraden%@"),stringPrice] forState:UIControlStateNormal];
    [self.restoreButton setTitle:NSLocalizedString(@"RESTORE", @"Herstellen") forState:UIControlStateNormal];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelf:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedTransaction:) name:IAPHelperProductPurchasedFailedNotification object:nil];
    if (self.navigationItem.rightBarButtonItem) {
        [self startTimer];
    } 
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) increaseCount {
    if ( _sec <= 0 ) {
        [self.backButton setEnabled:YES];
        self.backButton.title = [NSString stringWithFormat:NSLocalizedString(@"CLOSE", @"Sluit")];
    } else {
        _sec--;
        self.backButton.title = [NSString stringWithFormat:@"%d",_sec];
    }
}

- (void) startTimer {
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma Lifecycle Events

- (IBAction)dismissSelf:(id)sender {

    [_timer invalidate];
    if ( !_goingOffScreen ) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        if(self.delegate)
        {
            DLog(@"Continuing to results");
            [self.delegate continueToResults];
        }
        _goingOffScreen = YES;
    } else {
        DLog(@"Double call to dismissSelf");
    }
}

- (IBAction) buy:(id)sender {
    [Flurry logEvent:@"Buying process started"];    
    DLog(@"Buying..");
    
    
    [self.buyButton setEnabled:NO];
    [self.restoreButton setEnabled:NO];
    [self.buyButton setTitle:NSLocalizedString(@"BUYING_APP", "Purchasing premium in app alert title") forState:UIControlStateNormal];
    if(_products){ // al een keer opgehaald
        [[DTMInAppPurchase sharedInstance] buyProduct:_products[0]];
    }else{// nog niet, nog een keer ophalen    
        [[DTMInAppPurchase sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if (success) {
                _products = products;
                [[DTMInAppPurchase sharedInstance] buyProduct:products[0]];
            }
        }];
    }
}

- (IBAction) restore:(id)sender {
    DLog(@"Restoring..");
    
    [self.buyButton setEnabled:NO];
    [self.restoreButton setEnabled:NO];
    [self.restoreButton setTitle:NSLocalizedString(@"RESTORING_APP", "Restoring premium in app alert title") forState:UIControlStateNormal];
    [Flurry logEvent:@"Restoring process started"];
    [[DTMInAppPurchase sharedInstance] restoreProduct];
}


- (void)failedTransaction:(id)sender{
    
    [self.buyButton setEnabled:YES];
    [self.restoreButton setEnabled:YES];
    [self setButtonText];
    
}


- (void)viewDidUnload {
    [self setTiredOf:nil];
    [self setBuyDTMLabel:nil];
    [self setNoAdsLabel:nil];
    [self setNoWaiting:nil];
    [self setNoGameRistriction:nil];
    [self setBuyButton:nil];
    [self setBackButton:nil];
    [self setRestoreLabel:nil];
    [self setRestoreButton:nil];
    [super viewDidUnload];
}

@end
