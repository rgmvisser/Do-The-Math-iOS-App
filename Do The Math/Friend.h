//
//  Friend.h
//  dothemath
//
//  Created by Innovattic 1 on 12/11/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic, retain) NSNumber * avatar;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * experience;

@end
