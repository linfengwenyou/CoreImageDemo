//
//  ImageCacheManager.h
//  ImageIODemo
//
//  Created by fumi on 2019/6/27.
//  Copyright © 2019 rayor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCacheManager : NSObject

+ (void)requestForUrl:(NSString *)url isThumbImage:(BOOL)isThumbImage withComplete:(void(^)(UIImage *))completeAction;


@end

NS_ASSUME_NONNULL_END
