//
//  CIColorInvert.m
//  CoreImageDemo
//
//  Created by fumi on 2019/6/26.
//  Copyright © 2019 rayor. All rights reserved.
//

#import "CIColorInvert.h"

@implementation CIColorInvert
/** 注意事项:
* 1. 参数属性，需要为每个输入参数名称添加input, 例如inputImage.
* 2. setDefaults如有必要，覆盖该方法
* 3. 覆盖该outputImage方法
 */

- (CIImage *)outputImage {
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMatrix" withInputParameters:@{
                                                                                       kCIInputImageKey:self.inputImage,
                                                                                       @"inputRVector":[CIVector vectorWithX:-1 Y:0 Z:0],
                                                                                       @"inputGVector":[CIVector vectorWithX:0 Y:-1 Z:0],
                                                                                       @"inputBVector":[CIVector vectorWithX:0 Y:0 Z:-1],
                                                                                       @"inputBiasVector":[CIVector vectorWithX:1 Y:1 Z:1],
                                                                                       }];
    
    return filter.outputImage;
}


@end
