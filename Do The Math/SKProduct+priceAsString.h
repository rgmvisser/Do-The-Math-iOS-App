//
//  SKProduct+priceAsString.h
//  dothemath
//
//  Created by Rogier Slag on 09/01/2013.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (priceAsString)
@property (nonatomic, readonly) NSString *priceAsString;
@end
