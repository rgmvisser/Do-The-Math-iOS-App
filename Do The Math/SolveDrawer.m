//
//  SolveDrawer.m
//  dothemath
//
//  Created by Rogier Slag on 27/11/2012.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "SolveDrawer.h"

@interface SolveDrawer()

@end

@implementation SolveDrawer

@synthesize drawView = _drawView;
@synthesize expression = _expression;

- (void) setExpression:(NSString *)expression
{
    _expression = expression;
    [self drawExpression];
}

- (NSString*) expression
{
    return _expression;
}

- (void) drawExpression
{
    
}

@end
