//
//  MappingManager.h
//  dothemath
//
//  Created by Innovattic 1 on 11/21/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RKManagedObjectStore;
@interface MappingManager : NSObject

+(void)setObjectMapping:(RKManagedObjectStore *)store;
+(void)setRouting;

@end
