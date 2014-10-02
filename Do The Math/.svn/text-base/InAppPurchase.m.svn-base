//
//  InAppPurchase.m
//  dothemath
//
//  Created by Rogier Slag on 08/01/2013.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "InAppPurchase.h"
#import <StoreKit/StoreKit.h>
#import "LoadingAlert.h"
@interface InAppPurchase () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation InAppPurchase {
    SKProductsRequest * _productsRequest;
    
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}


- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                DLog(@"Previously purchased: %@", productIdentifier);
            } else {
                DLog(@"Not purchased: %@", productIdentifier);
            }
        }
       [[SKPaymentQueue defaultQueue] addTransactionObserver:self]; 
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    _completionHandler = [completionHandler copy];
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    DLog(@"Actually used this one...");
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product{
    DLog(@"Buying1 %@...", product.productIdentifier);

    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)restoreProduct{
    DLog(@"Restoring");

    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
                
            case SKPaymentTransactionStatePurchasing:
                
                //[_loadingAlert show];
                break;
            case SKPaymentTransactionStatePurchased:
                //[_loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //[_loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                //[_loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
                DLog(@"Restore");
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self productPurchased];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self productPurchased];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    DLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        DLog(@"Transaction error: %@", transaction.error.localizedDescription);
        [self inAppPurchaseFailed];
    }else{
        [self inAppPurchaseCanceled];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    

}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    [self inAppPurchaseCanceled];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        DLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    DLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}


- (void) inAppPurchaseFailed {
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedFailedNotification object:nil userInfo:nil];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FAILURE", @"Failure") message:NSLocalizedString(@"APP_PURCHASE_FAIL", @"In app purchase failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    [alert show];
}

- (void) inAppPurchaseCanceled {
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedFailedNotification object:nil userInfo:nil];
}

- (void) productPurchased {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"PURCHASE", @"Purchase") message:NSLocalizedString(@"APP_PURCHASE_SUCCES", @"In app purchase succesful") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    [alert show];

}





@end
