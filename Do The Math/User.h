//
//  User.h
//  dothemath
//
//  Created by Innovattic 1 on 3/12/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * avatar;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSString * facebook_id;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSNumber * losses;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * premium;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * wins;
@property (nonatomic, retain) NSNumber * draws;

@end
