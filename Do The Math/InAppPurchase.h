//
//  InAppPurchase.h
//  dothemath
//
//  Created by Rogier Slag on 08/01/2013.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#define IAPHelperProductPurchasedNotification @"IAPHelperProductPurchasedNotification"
#define IAPHelperProductPurchasedFailedNotification @"IAPHelperProductPurchasedFailedNotification"

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);


@interface InAppPurchase : NSObject



- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)restoreProduct;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;

@end
