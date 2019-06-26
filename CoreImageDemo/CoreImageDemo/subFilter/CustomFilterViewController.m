//
//  CustomFilterViewController.m
//  CoreImageDemo
//
//  Created by fumi on 2019/6/26.
//  Copyright © 2019 rayor. All rights reserved.
//

#import "CustomFilterViewController.h"
#import "CIColorInvert.h"

@interface CustomFilterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *filterImageView;

@end

@implementation CustomFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义滤镜效果";
    [self testFilterImageView];
}

- (void)testFilterImageView {
    
    CIColorInvert *filter = [[CIColorInvert alloc] init];
    
    CIImage *img = [[CIImage alloc] initWithImage:self.filterImageView.image];
    filter.inputImage = img;
    self.filterImageView.image = [[UIImage alloc] initWithCIImage:filter.outputImage];
}

@end
