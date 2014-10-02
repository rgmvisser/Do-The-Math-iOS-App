//
//  BuyPremiumVersion.m
//  dothemath
//
//  Created by Rogier Slag on 09/01/2013.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "BuyPremiumVersion.h"
#import "DTMTableViewController.h"
#import "DTMInAppPurchase.h"
#import "SKProduct+priceAsString.h"
#import "LoadingAlert.h"
#import "Flurry.h"

@implementation BuyPremiumVersion {
    NSArray* _products;
    
}
static LoadingAlert *_contactingAlert;

+ (void) buy {
    [Flurry logEvent:@"Buying process started"];
    
    DLog(@"Buying..");
    
    _contactingAlert = [[LoadingAlert alloc] initWithTitle:NSLocalizedString(@"PLEASE_WAIT", @"Please wait") message:NSLocalizedString(@"CONTACTING_APP_STORE", @"The App Store is being contacted.") delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    
    [_contactingAlert show];
    
    [[DTMInAppPurchase sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            DLog(@"Prod: %@",products);
            [_contactingAlert dismissWithClickedButtonIndex:0 animated:YES];
            [[DTMInAppPurchase sharedInstance] buyProduct:products[0]];
        }
    }];
}

+ (void) restore {
    DLog(@"Restoring..");
    [Flurry logEvent:@"Restoring process started"];
    
    
   
    [[DTMInAppPurchase sharedInstance] restoreProduct];
}

@end
