//
//  AuthEnhanceViewController.m
//  CoreImageDemo
//
//  Created by fumi on 2019/6/26.
//  Copyright © 2019 rayor. All rights reserved.
//

#import "AuthEnhanceViewController.h"

@interface AuthEnhanceViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *enhanceImageView;

@end



@implementation AuthEnhanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图像加强";
    [self enhanceImaveView];
}


- (void)enhanceImaveView {
    
    CIImage *img = [[CIImage alloc] initWithImage:self.enhanceImageView.image];
    
    
    NSArray *adjustment = [img autoAdjustmentFiltersWithOptions:@{kCIImageAutoAdjustRedEye:@false}];
    for(CIFilter *filter in adjustment) {
        [filter setValue:img forKey:kCIInputImageKey];
        img = filter.outputImage;
    }
    self.enhanceImageView.image = [UIImage imageWithCIImage:img];
}

@end
