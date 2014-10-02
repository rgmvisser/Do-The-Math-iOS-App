//
//  GameMVCProtocol.h
//  Do The Math
//
//  Created by Innovattic 1 on 10/2/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question+Functions.h"

@protocol GameMVCProtocol <NSObject>

//protocol that requires gameviewcontroller to have a function setQuestion

@required
-(void)setQuestion:(Question *)question;

@end
