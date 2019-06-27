//
//  ImageCacheManager.m
//  ImageIODemo
//
//  Created by fumi on 2019/6/27.
//  Copyright © 2019 rayor. All rights reserved.
//

#import "ImageCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface ImageCacheManager()
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) NSCache *thumbNailImageCache;
@end

@implementation ImageCacheManager

#pragma mark - life cycle

#pragma mark - 初始化
+ (instancetype)shared {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static ImageCacheManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
#pragma mark - private

+ (NSString*)md5WithString:(NSString *)url {
    const char *cStr = [url UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - public

+ (UIImage *)getThumbnailCacheImageWithUrl:(NSString *)url isThumbnail:(BOOL)isThumbnail {
    // 获取缓存
    if (isThumbnail) {
        return [[ImageCacheManager shared].thumbNailImageCache objectForKey:[self md5WithString:url]];
    } else {
        return [[ImageCacheManager shared].imageCache objectForKey:[self md5WithString:url]];
    }
}

+ (void)saveImageCacheImage:(UIImage *)image url:(NSString *)url isThumbnail:(BOOL)isThumbnail {
    // 配置缓存
    if (isThumbnail) {
        [[ImageCacheManager shared].thumbNailImageCache setObject:image forKey:[self md5WithString:url]];
    } else {
        [[ImageCacheManager shared].imageCache setObject:image forKey:[self md5WithString:url]];
    }
}

+ (void)requestForUrl:(NSString *)url isThumbImage:(BOOL)isThumbImage withComplete:(void (^)(UIImage * _Nonnull))completeAction {
    UIImage *image = [self getThumbnailCacheImageWithUrl:url isThumbnail:isThumbImage];
    if (completeAction && image) {
        completeAction(image);
        return;
    }
    
    [self loadImageUrl:url completeAction:completeAction];
}


+ (void)loadImageUrl:(NSString *)url completeAction:(void(^)(UIImage *))completeAction {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        CGImageRef thumbImageRef = createThumbnailImageFromData(data, 200);
        UIImage *thumImage = [UIImage imageWithCGImage:thumbImageRef];
        if (!thumImage || !image) {
            return ;
        }
        [self saveImageCacheImage:image url:url isThumbnail:NO];
        [self saveImageCacheImage:thumImage url:url isThumbnail:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeAction) {
                completeAction(image);
            }
        });
    });
}

#pragma mark - network

/** 创建缩略图 */
CGImageRef createThumbnailImageFromData(NSData * data, int imageSize) {
    
    CGImageRef myThumbnailImage = NULL;
    CGImageSourceRef myImageSource;
    CFDictionaryRef myOptions = NULL;
    
    CFStringRef mykeys[3];
    CFTypeRef myValues[3];
    
    CFNumberRef thumbnailSize;
    
    // 从NSData创建图像源，没有选择。
    myImageSource = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    
    // 在继续之前确保图像源存在
    if (myImageSource == NULL) {
        fprintf(stderr, "图像源为NULL");
        return NULL;
    }
    
    thumbnailSize = CFNumberCreate(NULL , kCFNumberIntType, &imageSize);
    
    // 设置缩略图选项
    mykeys[0] = kCGImageSourceCreateThumbnailWithTransform;
    mykeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    mykeys[2] = kCGImageSourceThumbnailMaxPixelSize;
    
    myValues[0] = (CFTypeRef) kCFBooleanTrue;
    myValues[1] = (CFTypeRef) kCFBooleanTrue;
    myValues[2] = (CFTypeRef) thumbnailSize;
    
    myOptions = CFDictionaryCreate(NULL, (const void **)mykeys, (const void **)myValues, 3, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    // 使用指定的选项创建缩略图图像
    myThumbnailImage = CGImageSourceCreateThumbnailAtIndex(myImageSource, 0, myOptions);
    
    // 释放选项字典和图像源
    CFRelease(thumbnailSize);
    CFRelease(myOptions);
    CFRelease(myImageSource);
    
    if (myThumbnailImage == NULL) {
        fprintf(stderr, "缩略图不是从图像源创建的。");
        return NULL;
    }
    
    return myThumbnailImage;
    
}

#pragma mark - event

#pragma mark - delegate

#pragma mark - setter

#pragma mark - getter


- (NSCache *)imageCache {
    if (!_imageCache) {
        _imageCache = [[NSCache alloc] init];
    }
    return _imageCache;
}


- (NSCache *)thumbNailImageCache {
    if (!_thumbNailImageCache) {
        _thumbNailImageCache = [[NSCache alloc] init];
    }
    return _thumbNailImageCache;
}
@end
