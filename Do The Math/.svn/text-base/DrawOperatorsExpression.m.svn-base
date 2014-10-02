//
//  DrawOperatorsExpression.m
//  dothemath
//
//  Created by Rogier Slag on 28/11/2012.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "DrawOperatorsExpression.h"
#import "Appearance.h"
#import <Foundation/NSNull.h>


@interface DrawOperatorsExpression()
{
    NSMutableArray *_operators; //the operators currently clicked
    NSMutableArray *_placeholders; //the placeholder, which can hold operatorts
    UIView *_innerView; //used to align the view
}

@end

@implementation DrawOperatorsExpression

@synthesize drawView = _drawView;
@synthesize expression = _expression;

/**
 * Overide the init method to set the default properties
 */
-(id)initWithView:(UIView *)view
{
    self = [super init];
    if(self)
    {
        self.drawView = view;
        _operators = [[NSMutableArray alloc] init];
        _placeholders = [[NSMutableArray alloc] init];
    }
    return self;
}

/**
 * Set the expression
 * Reset the view and draw the expression again
 */
- (void) setExpression:(NSString *)expression
{
    _expression = expression;
    [[self.drawView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *subview = (UIView *)obj;
        [subview removeFromSuperview];
    }];
    _operators = [[NSMutableArray alloc] init];
    _placeholders = [[NSMutableArray alloc] init];
    [self drawExpression];
}

/**
 * Get the current expression
 */
- (NSString*) expression
{
    return _expression;
}


/**
 * Draw the expression
 */
- (void) drawExpression
{
    if(self.drawView) //if there is a view to draw in
    {
        _innerView = [[UIView alloc] init];
        CGRect innerFrame = self.drawView.frame;
        innerFrame.origin.x = 0;
        innerFrame.origin.y = 0;
        _innerView.frame = innerFrame;
        [_innerView setBackgroundColor:[UIColor clearColor]];
        [self.drawView addSubview:_innerView]; //add innerview to align the view
        //get the different parts of the expression
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@".="];
        NSArray *splitString = [self.expression componentsSeparatedByCharactersInSet:set];
        
        
        UIFont *font = [UIFont fontWithName:[Appearance getFont] size:45];
        __block int x = 0;
        __block int y = 5;
        //after each part has to be a placeholder
        [splitString enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *stringPart = (NSString *)obj;
            CGSize labelframe = [stringPart sizeWithFont:font forWidth:320 lineBreakMode:NSLineBreakByClipping]; //get the size of a label
            UILabel *label;
            if((int)idx == [splitString count]-1) // treat the answer different
            {
                //this is the answer part
                stringPart = [NSString stringWithFormat:@"=%@",stringPart];
                y = y + labelframe.height; //set the = on the next line
                label = [[UILabel alloc] initWithFrame:CGRectMake(0 , labelframe.height, x , labelframe.height)];
                label.textAlignment = UITextAlignmentCenter;
                label.adjustsFontSizeToFitWidth = YES;
            }
            else{
                //this is a normal part of the expression
                label = [[UILabel alloc] initWithFrame:CGRectMake(x , y, labelframe.width, labelframe.height)];
                x = x + labelframe.width;
            }
            //style the label and add it to the view
            [Appearance setLabelFont:label];
            [label setTextColor:[UIColor blackColor]];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:stringPart];
            [label setFont:font];            
            [_innerView addSubview:label];
            
            if((int)idx < [splitString count]-2) // no placeholder at the end
            {
                //create a placeholer
                UIImageView *operatorPlaceholder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vakje.png"]];
                CGRect placeholderFrame = CGRectMake(x, 0, 37, 45);
                operatorPlaceholder.frame = placeholderFrame;
                operatorPlaceholder.clipsToBounds = NO;
                x = x + operatorPlaceholder.frame.size.width;
                [_innerView addSubview:operatorPlaceholder];
                //add the placeholder to the placeholders, also reserve a place in the operators array
                [_placeholders addObject:operatorPlaceholder];
                [_operators addObject:[[NSNull alloc] init]];
            }          
            
        }];
        //place the frame in the middle
        CGRect frame = self.drawView.frame;        
        CGFloat left = (float)(frame.size.width - x)/2;
        frame.origin.x = left;
        frame.size.width = x;
        _innerView.frame = frame;

    }else{
        DLog(@"No draw view!: %@",self.drawView);
    }
}


/**
 * add a operator to the expression
 */
-(void)addOperator:(NSString *)op
{
    for (int i = 0; i < [_placeholders count]; i++) {
        
        if([[_operators objectAtIndex:i] isKindOfClass:[NSNull class]]) //find a empty spot
        {
            //add the operator to the view
            [_operators setObject:op atIndexedSubscript:i];
            UIButton *opButton = [self buttonForOperator:op];
            UIImageView *placeholder = [_placeholders objectAtIndex:i];
            opButton.frame = placeholder.frame;
            opButton.tag = i;
            [opButton addTarget:self action:@selector(removeOperator:) forControlEvents:UIControlEventTouchUpInside];
            [_innerView addSubview:opButton];
            return;
        }
    }
}

/**
 * Return an button for the accessory operator name
 */
-(UIButton *)buttonForOperator:(NSString *)operator
{
    UIButton *operatorButton = [[UIButton alloc] init];
    if([operator isEqualToString:@"+"])
    {
        [operatorButton setImage:[UIImage imageNamed:@"invullen +.png"] forState:UIControlStateNormal];
    }
    if([operator isEqualToString:@"-"])
    {
        [operatorButton setImage:[UIImage imageNamed:@"invullen -.png"] forState:UIControlStateNormal];
    }
    if([operator isEqualToString:@"/"])
    {
        [operatorButton setImage:[UIImage imageNamed:@"invullen gedeelddoor.png"] forState:UIControlStateNormal];
    }
    if([operator isEqualToString:@"*"])
    {
        [operatorButton setImage:[UIImage imageNamed:@"invullen x.png"] forState:UIControlStateNormal];
    }
    return operatorButton;
}

/**
 * Remove an operator from the expression if the operator in the expression is clicked
 */
-(void)removeOperator:(UIButton *)sender
{
    [_operators setObject:[[NSNull alloc] init] atIndexedSubscript:sender.tag];
    [sender removeFromSuperview];
}

/**
 * Returns the array with operators which are currently chosen
 */
-(NSMutableArray *)getCurrentSolution
{
    return _operators;
}

@end
