//
//  ImagesCollectionViewCell.h
//  ImageIODemo
//
//  Created by fumi on 2019/6/27.
//  Copyright © 2019 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagesCollectionViewCell : UICollectionViewCell
/** 图片地址 */
@property (nonatomic, copy) NSString *imageUrl;
@end

NS_ASSUME_NONNULL_END
