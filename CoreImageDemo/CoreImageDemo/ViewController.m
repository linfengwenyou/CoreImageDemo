//
//  ViewController.m
//  CoreImageDemo
//
//  Created by fumi on 2019/6/25.
//  Copyright © 2019 rayor. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tmpImageView;
@property (nonatomic, copy) NSArray *filters;
@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shotImageView;
@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.filters = [CIFilter filterNamesInCategory:nil].reverseObjectEnumerator.allObjects;
    // 配置Imag信息
    [self startTimeUpdate];
    
}

int i = 0;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    i ++;
}


- (void)startTimeUpdate {
    [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (i % 2 == 1) {
            [self filterEnter];
        } else {
            self.tmpImageView.image = [UIImage imageNamed:@"3296617.jpg"];
        }
    }];
}

int number = 0;
- (void)filterEnter {
    number ++;
    CIImage *ciImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"3296617.jpg"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSString *filterName = self.filters[number];
        if (!filterName || number == self.filters.count) {
            NSString *title = @"所有图片构建完毕";
            NSLog(@"%@ 共%d张",title,self.filters.count);
            return ;
        }
        
        // 根据滤镜名创建滤镜
        CIFilter *filter;
        @try {
            filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey,ciImage, nil];
            [filter setDefaults];
        } @catch (NSException *exception) {
            return;
        }
        
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIImage *outputImage = [filter outputImage];
        CGImageRef cgRef = [context createCGImage:outputImage fromRect:outputImage.extent];
        UIImage *image = [UIImage imageWithCGImage:cgRef];
        CGImageRelease(cgRef);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tmpImageView.image = image;
            self.filterNameLabel.text = filterName;
            [self saveScreenImage];
        });
    });
  
}

int serialNumber = 100000;
- (void)saveScreenImage {
    UIGraphicsBeginImageContext(UIScreen.mainScreen.bounds.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:ref];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 图片保存到本地
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *fileName = [NSString stringWithFormat:@"%d.jpg",serialNumber];
    path = [path stringByAppendingPathComponent:fileName];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error;
    BOOL success = [UIImageJPEGRepresentation(img, 0.5) writeToURL:url options:NSDataWritingFileProtectionNone error:&error];
    if (success) {
        NSLog(@"写入本地数据成功");
    } else {
        NSLog(@"写入本地数据失败");
    }
    
    serialNumber ++;
    
}


@end
