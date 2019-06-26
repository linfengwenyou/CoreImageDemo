//
//  CIColorInvert.h
//  CoreImageDemo
//
//  Created by fumi on 2019/6/26.
//  Copyright © 2019 rayor. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface CIColorInvert : CIFilter
@property (nonatomic, strong) CIImage *inputImage;
@end
