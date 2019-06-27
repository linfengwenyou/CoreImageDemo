//
//  ImagesCollectionViewCell.m
//  ImageIODemo
//
//  Created by fumi on 2019/6/27.
//  Copyright © 2019 rayor. All rights reserved.
//

#import "ImagesCollectionViewCell.h"
#import "ImageCacheManager.h"

@interface ImagesCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation ImagesCollectionViewCell

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    // 处理展示效果
    self.imgView.image = nil;
    
    [ImageCacheManager requestForUrl:_imageUrl isThumbImage:NO withComplete:^(UIImage * image) {
        self.imgView.image = image;
    }];
    
//    [ImageCacheManager requestForUrl:_imageUrl withComplete:^(UIImage * _Nonnull image) {
//        self.imgView.image = image;
//    }];
    
}

@end
