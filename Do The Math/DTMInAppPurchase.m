//
//  DTMInAppPurchase.m
//  dothemath
//
//  Created by Rogier Slag on 08/01/2013.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "DTMInAppPurchase.h"

@implementation DTMInAppPurchase

+ (DTMInAppPurchase *)sharedInstance {
    static dispatch_once_t once;
    static DTMInAppPurchase * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      PREMIUM,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
