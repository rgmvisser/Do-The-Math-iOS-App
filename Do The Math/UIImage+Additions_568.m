//
//  UIImage+Additions_568.m
//  Qurate
//
//  Created by Igor Fedorov on 10/13/12.
//  Copyright (c) 2012 Igor Fedorov. All rights reserved.
//

#import "UIImage+Additions_568.h"
#import <objc/runtime.h>

#define kTallSuffix @"-568h@2x"

@implementation UIImage (Additions_568)

static BOOL mayUseTallerImages;

+ (void)load
{
    mayUseTallerImages = CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size);
}

/**
 * Check if there is an image for the iphone 5
 */
+ (UIImage *)imageNamed_patched:(NSString *)name {
    
     if (mayUseTallerImages && [name length] > 0  && [name rangeOfString:kTallSuffix].location == NSNotFound)
    {
        //Check if is there a path extension or not
        NSString *testName = name;
        if (testName.pathExtension.length > 0) {
            testName = [[[testName stringByDeletingPathExtension] stringByAppendingString:kTallSuffix] stringByAppendingPathExtension:[name pathExtension]];
        } else {
            testName = [testName stringByAppendingString:kTallSuffix @".png"];
        }
        UIImage *image = [UIImage imageNamed_patched:testName];
        if (image) {
            //DLog(@"Image found!");
            return [self imageWithCGImage:image.CGImage scale:2.0f orientation:image.imageOrientation];
        }
    }
    return [self imageNamed_patched:name];
    
}
/** 
 * Replace the current image function with ours
 */
+ (void)patchImageNamedToSupport568Resources
{
    Method origMethod = class_getClassMethod([UIImage class], @selector(imageNamed:));
    Method newMethod = class_getClassMethod([UIImage class], @selector(imageNamed_patched:));
    method_exchangeImplementations(origMethod, newMethod);
}

@end
