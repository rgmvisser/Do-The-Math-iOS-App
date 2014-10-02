//
//  UIImageView+dynamicLoad.m
//  dothemath
//
//  Created by Innovattic 1 on 10/29/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "UIImageView+dynamicLoad.h"
#import "DynamicImageLoader.h"

@implementation UIImageView (dynamicLoad)


/**
 * Set an avatar dynamic, load it from the server if the image is not yet saved local
 */
-(void)setDynamicImage:(NSNumber *)userId avatarId:(NSNumber *)avatarId
{
    
    DynamicImageLoader *dynamicLoader = [DynamicImageLoader shared];
    [self loadDefaultImage]; //load the default image, till the avatar is downloaded
    if(userId != nil && avatarId != nil) // 
    {
        [dynamicLoader getImage:userId avatarId:avatarId resultBlock:^(UIImage *image, BOOL isDownloaded) {
            //if an image is found, set the image when it is loaded
            if(image)
            {
                [self setImage:image];
            }
        }];
    }
}
/**
 * Set dynamic image, load it in cache if not already downloaded
 */
-(void)setDynamicImageFromUrl:(NSString *)url
{
    DynamicImageLoader *dynamicLoader = [DynamicImageLoader shared];
    [self loadDefaultImage]; //load the default image, till the avatar is downloaded
    if(url != nil) 
    {
        [dynamicLoader getImageFromUrl:url resultBlock:^(UIImage *image, BOOL isDownloaded) {
            //if an image is found, set the image when it is loaded
            if(image)
            {
                [self setImage:image];
            }
        }];
    }
}

/**
 * Loading the default image
 * @TODO: make default image
 */
-(void)loadDefaultImage
{
    [self setImage:[UIImage imageNamed:@"default_avatar.png"]];
}


@end
