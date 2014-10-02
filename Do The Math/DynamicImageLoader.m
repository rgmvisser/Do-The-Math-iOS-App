//
//  DynamicImageLoader.m
//  dothemath
//
//  Created by Innovattic 1 on 10/29/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "DynamicImageLoader.h"
#import <RestKit/RestKit.h>
#import "ImageManipulator.h"

//the singleton
static DynamicImageLoader *loader;

@implementation DynamicImageLoader
{
    NSMutableArray *_imagesLoading; //images which are currently loading
    NSMutableDictionary *_blocksWaiting; //the blocks which are waiting for the image to load
}

- (id)init
{
    if ( self = [super init] )
    {
        _imagesLoading = [[NSMutableArray alloc] init];
        _blocksWaiting = [[NSMutableDictionary alloc] init];
    }
    return self;
    
}

/**
 * Get the singleton 
 */
+ (DynamicImageLoader *)shared
{
    if (!loader)
    {
        // allocate the shared instance, because it hasn't been done yet
        loader = [[DynamicImageLoader alloc] init];
    }
    
    return loader;
}


/**
 * get the avatar image from a user
 */
-(void)getImage:(NSNumber *)user avatarId:(NSNumber *)avatar resultBlock:(void (^)(UIImage* image, BOOL isDownloaded))resultBlock
{
    //trying to get the image out of the directory 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageUrl = [NSString stringWithFormat:@"%d_%d",[user intValue],[avatar intValue]];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:imageUrl];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    if(!image) //no image here, download from server
    {
        if(![_imagesLoading containsObject:imageUrl]) //check if the image is not already loading
        {        
            if([avatar intValue] != 0) // check if an avatar is set
            {
                //add to image is loading
                [_imagesLoading addObject:imageUrl];
                [_blocksWaiting setObject:[[NSMutableArray alloc] init] forKey:imageUrl];
                DLog(@"Image downloading");
                RKClient *client = [RKClient sharedClient];
                resultBlock = [resultBlock copy];
                [client get:[NSString stringWithFormat:@"/user/%d/avatar/%d",[user intValue],[avatar intValue]] usingBlock:^(RKRequest *request) {
                    request.onDidLoadResponse = ^(RKResponse *response) {
                        if(response.statusCode == 200)
                        {
                            UIImage *downloadedImage = [UIImage imageWithData:response.body];
                            [self saveImage:downloadedImage imageName:imageUrl];
                            resultBlock(downloadedImage,YES);
                            [self doneDownloading:downloadedImage forUrl:(NSString *)imageUrl];
                            //DLog(@"Image saved");
                        }
                        else{
                            //DLog(@"Response image not good:%@",response);
                            resultBlock(nil,NO);
                        }
                    };
                    
                    request.onDidFailLoadWithError = ^(NSError *error) {
                        DLog(@"Failed to load image:%@",error);
                        resultBlock(nil,NO);
                    };
                    
                }];
            }else{
                //No avatar yet, no need to download
                resultBlock(nil,NO);
            }
        }else{
            //DLog(@"Image is already downloading");
            [[_blocksWaiting objectForKey:imageUrl] addObject:resultBlock];
            
        }
    }
    else{
        resultBlock(image,NO);
        //DLog(@"Image found");
    }
    
    
    
}

/**
 * Upload a avatar to the server
 */
-(void)uploadAvatarToServer:(UIImage *)avatar
{
    NSData *pngImage = UIImagePNGRepresentation(avatar);
    RKClient *client = [RKClient sharedClient];
    [client post:@"/user/me/avatar/" usingBlock:^(RKRequest *request) {
        RKParams* params = [RKParams params];
        [params setData:pngImage MIMEType:@"image/png" forParam:@"avatar.png"];
        request.params = params;
        request.onDidLoadResponse = ^(RKResponse *response) {
            if(response.statusCode == 200)
            {
                DLog(@"Image uploaded!");
            }
            else{
                //DLog(@"Response uploading image not good:%@",response);
            }
        };
        
        request.onDidFailLoadWithError = ^(NSError *error) {
            DLog(@"Failed to upload image:%@",error);
        };
        
    }];

}

/**
 * Save an image in de directory
 */
- (void)saveImage: (UIImage*)image imageName:(NSString*)imageName
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:imageName];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
    
}

/**
 * Function is called when an image is downloaded, execute the blocks which are waiting
 */
-(void)doneDownloading: (UIImage*)image forUrl:(NSString *)imageUrl
{
    [_imagesLoading removeObject:imageUrl];
    for (id obj in [_blocksWaiting objectForKey:imageUrl]) {
        
        void (^block)(UIImage* , BOOL) = (void(^)(UIImage* image, BOOL isDownloaded))obj;
        //Run the block
        block(image,NO);
        //DLog(@"Loaded downloaded image");
        
    }
    [_blocksWaiting removeObjectForKey:imageUrl];   
    
}

/**
 * Get an image async from a url
 */
- (void)getImageFromUrl:(NSString *)imageUrl resultBlock:(void (^)(UIImage *, BOOL))resultBlock
{
    if(![_imagesLoading containsObject:imageUrl])
    {
        //add to image is loading
        [_imagesLoading addObject:imageUrl];
        [_blocksWaiting setObject:[[NSMutableArray alloc] init] forKey:imageUrl];
        DLog(@"Image downloading");
        RKClient *client = [RKClient sharedClient];
        resultBlock = [resultBlock copy];
        [client get:imageUrl usingBlock:^(RKRequest *request) {
            request.cachePolicy = RKRequestCachePolicyEnabled;
            request.queue = 
            request.onDidLoadResponse = ^(RKResponse *response) {
                if(response.statusCode == 200)
                {
                    DLog(@"Responde body: %@",response.body);
                    UIImage *downloadedImage = [UIImage imageWithData:response.body];
                    UIImage *corneredImage = [ImageManipulator makeRoundCornerImage:downloadedImage :CORNER_SIZE :CORNER_SIZE];
                    resultBlock(corneredImage,YES);
                    [self doneDownloading:corneredImage forUrl:(NSString *)imageUrl];
                    
                }
                else{
                    DLog(@"Response image not good:%@",response);
                    resultBlock(nil,NO);
                }
            };
            
            request.onDidFailLoadWithError = ^(NSError *error) {
                DLog(@"Failed to load image:%@",error);
                resultBlock(nil,NO);
            };
            
        }];
    }else{
        //DLog(@"Image is already downloading");
        [[_blocksWaiting objectForKey:imageUrl] addObject:resultBlock];
        
    }
}






@end
