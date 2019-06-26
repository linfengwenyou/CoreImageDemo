//
//  DetectorViewController.m
//  CoreImageDemo
//
//  Created by fumi on 2019/6/26.
//  Copyright © 2019 rayor. All rights reserved.
//

#import "DetectorViewController.h"

@interface DetectorViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@end

@implementation DetectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"特征值检测";
    /** 只能用来检测面部信息 */
//    [self detectorFilter];
//    [self detectorRectangle];
//    [self detectorQRCode];
    [self detectorText];
}


#pragma mark - 其他验证
/** CORE_IMAGE_EXPORT NSString* const CIDetectorTypeFace NS_AVAILABLE(10_7, 5_0);
CORE_IMAGE_EXPORT NSString* const CIDetectorTypeRectangle NS_AVAILABLE(10_10, 8_0);
CORE_IMAGE_EXPORT NSString* const CIDetectorTypeQRCode NS_AVAILABLE(10_10, 8_0);
#if __OBJC2__
CORE_IMAGE_EXPORT NSString* const CIDetectorTypeText NS_AVAILABLE(10_11, 9_0);
*/

/** 查找矩形 */
- (void)detectorRectangle {
    
    self.myImageView.image = [UIImage imageNamed:@"rectangle.jpg"];
    
//    CIDetectorTypeRectangle
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:[CIContext context] options:@{CIDetectorAccuracy:CIDetectorAccuracyLow}];
    CIImage *img = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"rectangle.jpg"]];
    NSArray *features = [detector featuresInImage:img];
    [self flagFaceArea: features];
    
    
}

/** 查找二维码 */
- (void)detectorQRCode {
    self.myImageView.image = [UIImage imageNamed:@"qrcode2"];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext context] options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *img = [[CIImage alloc] initWithImage:self.myImageView.image];
    NSArray *features = [detector featuresInImage:img];
    [self flagFaceArea:features];
    [features enumerateObjectsUsingBlock:^(CIQRCodeFeature  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj.messageString);         // 二维码识别结果
    }];
    NSLog(@"%@",features);
}

/** 查找文本区域，但，并不执行光学文字字符识别 */
- (void)detectorText {
    self.myImageView.image = [UIImage imageNamed:@"text"];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeText context:[CIContext context] options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *img = [[CIImage alloc] initWithImage:self.myImageView.image];
    NSArray *feature = [detector featuresInImage:img];
    [feature enumerateObjectsUsingBlock:^(CITextFeature *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj.subFeatures);
    }];
    [self flagFaceArea:feature];
    NSLog(@"%@",feature);
}

#pragma mark - 面部特征验证
/** 面部特征检测 */
- (void)detectorFilter {
    CIContext *context = [CIContext context];
    NSDictionary *opts = @{CIDetectorAccuracy:CIDetectorAccuracyHigh};
    CIDetector *detector  = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
    
    CIImage *img = [[CIImage alloc] initWithImage:self.myImageView.image];
    
//    opts = @{CIDetectorImageOrientation:[[img properties] valueForKey:kCGImagePropertyOrientation]};
    NSArray *features  = [detector featuresInImage:img options:nil];
    [self flagFaceArea:features];
    NSLog(@"%@",features);
}

- (void)flagFaceArea:(NSArray *)faces {
    
    UIGraphicsBeginImageContext(self.myImageView.image.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    // 绘制的头像方向会倒转，所以需要反转方向
    {   // 处理反转不会导致选框位置变换
        CGContextTranslateCTM(ref, 0, self.myImageView.image.size.height);
        CGContextScaleCTM(ref, 1.0, -1.0);
    }
    
    {   // 可以处理反转信息，但是会导致位置变换
        //            UIGraphicsPushContext(ref);
        //            [self.myImageView.image drawInRect:CGRectMake(0, 0, self.myImageView.image.size.width, self.myImageView.image.size.height)];
        //            UIGraphicsPopContext();
    }
    CGContextDrawImage(ref, CGRectMake(0, 0, self.myImageView.image.size.width, self.myImageView.image.size.height), self.myImageView.image.CGImage);
    
    CGContextSetStrokeColorWithColor(ref, UIColor.redColor.CGColor);
//    CGContextSetLineWidth(ref, 5);
    
    for (CIFaceFeature *face in faces) {
        CGContextAddRect(ref, face.bounds);
        CGContextStrokePath(ref);
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.myImageView.image = newImage;
}

@end
