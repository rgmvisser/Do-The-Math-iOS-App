//
//  VersionManager.h
//  dothemath
//
//  Created by Rogier Slag on 04/12/2012.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionManager : NSObject

+(VersionManager *) shared;


-(void) initVersionManager;
-(void) displayError:(NSString*)serverError;

@end
