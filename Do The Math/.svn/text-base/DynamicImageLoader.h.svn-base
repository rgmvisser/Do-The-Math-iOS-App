//
//  DynamicImageLoader.h
//  dothemath
//
//  Created by Innovattic 1 on 10/29/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicImageLoader : NSObject

+ (DynamicImageLoader *)shared;
-(void)getImage:(NSNumber *)user avatarId:(NSNumber *)avatar resultBlock:(void (^)(UIImage* image, BOOL isDownloaded))resultBlock;
-(void)getImageFromUrl:(NSString *)url resultBlock:(void (^)(UIImage* image, BOOL isDownloaded))resultBlock;
- (void)saveImage: (UIImage*)image imageName:(NSString*)imageName;
-(void)uploadAvatarToServer:(UIImage *)avatar;
@end
