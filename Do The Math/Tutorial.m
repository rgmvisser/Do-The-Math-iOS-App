//
//  Tutorial.m
//  dothemath
//
//  Created by Innovattic 1 on 3/26/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "Tutorial.h"

@implementation Tutorial


-(id)initWithImages:(NSArray *)images andInfo:(NSArray *)infos
{
    self = [super init];
    if(self)
    {
        self.images = [images mutableCopy];
        self.infos = [infos mutableCopy];
    }
    return self;
}


@end
