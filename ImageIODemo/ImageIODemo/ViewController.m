//
//  ViewController.m
//  ImageIODemo
//
//  Created by fumi on 2019/6/26.
//  Copyright © 2019 rayor. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import "CustomMonitor.h"

@interface ViewController (){
	/** 增长 */
	CGImageSourceRef _incrementImageSource;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ImageI/O图片加载";

    
//    NSLog(@"%@",[[CustomMonitor alloc] init]);
//     NSLog(@"%@",[[CustomMonitor alloc] init]);
//     NSLog(@"%@",[[CustomMonitor alloc] init]);
    NSLog(@"%@",[CustomMonitor shareMonitor]);
    NSLog(@"%@",[CustomMonitor new]);
    
    CustomMonitor.shareMonitor.cpuUsageAction = ^(NSString * _Nonnull cpuUsage) {
        NSLog(@"CPU使用情况---: %@",cpuUsage);
    };
    
    CustomMonitor.shareMonitor.memoryUsageAction = ^(NSString * _Nonnull memUsage) {
        NSLog(@"Memory使用情况---: %@",memUsage);
    };
    
    [[CustomMonitor shareMonitor] startMonitor];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    return;
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    //        CGImageRef img = MyCreateCGImageFromFile(@"http://pic37.nipic.com/20140113/8800276_184927469000_2.png");
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            self.imageView.image = [UIImage imageWithCGImage:img];
    //        });
    //    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.mp.itc.cn/upload/20170713/446e5132e87844a6a50fe98ba23320be_th.jpg"]];
        [self testIncraseData:data];
    });
    
    
    /** 加载缩略图 */
    //    CGImageRef img = myCreateThumbnailImageFromData(data, 100);
    //    UIImage *image = [UIImage imageWithCGImage:img];
    //    self.imageView.image = image;
    //    fprintf(stdout, "成功打印");
    
    /** 打印支持UTI */
    //    [self showTypes];
}

- (void)showTypes {
    CFArrayRef mySourceTypes = CGImageSourceCopyTypeIdentifiers();
    NSLog(@"测试信息:");
    CFShow(mySourceTypes);
    CFArrayRef myDestinationTypes = CGImageDestinationCopyTypeIdentifiers();
    NSLog(@"目标对象有哪些: ");
    CFShow(myDestinationTypes);
}


#pragma mark - 从图像源创建图像
CGImageRef MyCreateCGImageFromFile(NSString *path) {
    // 获取传递给函数的路径名的URL
    NSURL *url = [NSURL URLWithString:path];
    
    CGImageRef myImage = NULL;
    CGImageSourceRef myImageSource;
    CFDictionaryRef myOptions = NULL;
    
    CFStringRef myKeys[2];
    CFTypeRef myValues[2];
    
    myKeys[0] = kCGImageSourceShouldCache;
    myKeys[1] = kCGImageSourceShouldAllowFloat;
    
    myValues[0] = (CFTypeRef) kCFBooleanTrue;
    myValues[1] = (CFTypeRef) kCFBooleanTrue;
    
    // 创建字典
    myOptions = CFDictionaryCreate(NULL, (const void **) myKeys, (const void **) myValues, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    // 从URL创建图像源
    myImageSource = CGImageSourceCreateWithURL((CFURLRef) url, myOptions);
    CFRelease(myOptions);
    
    // 在继续之前确保图像源存在
    if (myOptions == NULL) {
        fprintf(stderr, "图像源为NULL。");
        return NULL;
    }
    
    // 从图像源中的第一个项目创建图像。
    myImage = CGImageSourceCreateImageAtIndex(myImageSource, 0, NULL);
    CFRelease(myImageSource);
    
    // 在继续之前确保图像存在
    if (myImage == NULL ) {
        fprintf(stderr, "图像不是从图像源创建");
    }
    
    return myImage;
}


#pragma mark - 创建缩略图对象，imageSize是限制MAX(宽，高)
/** 创建缩略图 */
CGImageRef myCreateThumbnailImageFromData(NSData * data, int imageSize) {
    
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

/** 测试增量图片处理 */
- (void)testIncraseData:(NSData *)data {
    
    _incrementImageSource = CGImageSourceCreateIncremental(NULL);
    
    NSUInteger end = 1000;
    while (end <= data.length) {
        NSData *subData = [data subdataWithRange:NSMakeRange(0, end)];
        [self appendData:subData finished:end==data.length];
        
        if (end == data.length) {
            break;
        }
        
        
        if (data.length - end > 1000) {
            end += 1000;
        } else {
            end = data.length;
        }
        
    }
}

- (void)appendData:(NSData *)data finished:(BOOL)isFinished {
	
	CGImageSourceUpdateData(_incrementImageSource, (CFDataRef)data, isFinished);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementImageSource, 0, NULL);

    if (CGImageSourceGetStatus(_incrementImageSource) == kCGImageStatusComplete) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithCGImage:imageRef];
        });        
    }
    CGImageRelease(imageRef);
}


@end
