//
//  main.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/11/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Additions_568.h"
#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [UIImage patchImageNamedToSupport568Resources];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
