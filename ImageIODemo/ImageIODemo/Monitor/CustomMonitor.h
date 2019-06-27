//
//  CustomMonitor.h
//  ImageIODemo
//
//  Created by fumi on 2019/6/27.
//  Copyright © 2019 rayor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomMonitor : NSObject


/** 禁用掉事件, 这种写法不好，还是从根源处理AllocWithZone更便捷，否则，new，initWithParam这些方法都要做个处理，不统一 */
- (instancetype)init __attribute__((unavailable));

/** CPU使用情况 */
@property (nonatomic, copy) void(^cpuUsageAction)(NSString *cpuUsage);

/** 内存使用情况 */
@property (nonatomic, copy) void(^memoryUsageAction)(NSString *memUsage);

+ (instancetype)shareMonitor;

/** 监听状态是否开启 */
@property (nonatomic, assign, readonly, getter=isMonitorStateOn) BOOL monitorState;

/** 开始监控 */
- (void)startMonitor;
- (void)stopMonitor;
@end

NS_ASSUME_NONNULL_END
