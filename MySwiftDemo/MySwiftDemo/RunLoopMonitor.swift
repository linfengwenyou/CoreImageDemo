//
//  RunLoopMonitor.swift
//  MySwiftDemo
//
//  Created by fumi on 2019/7/1.
//  Copyright © 2019 rayor. All rights reserved.
//

import Foundation

func runloopMonitor() {
    let loop = CFRunLoopGetCurrent()
    let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0) { (observer,activity) in
        switch activity {
        case .entry:
            print("--------------- runloop 即将进入循环")
            break
        case .beforeTimers:
            print("--------------- runloop 即将执行计时器")
            break
        case .beforeSources:
            print("--------------- runloop 即将执行source事件")
            break
        case .beforeWaiting:
            print("--------------- runloop 即将进入休眠等待")
            break
        case .afterWaiting:
            print("--------------- runloop 即将唤醒")
            break
        case .exit:
            print("--------------- runloop 即将退出")
            break
        default:
            print("--")
        }
    }
    
    CFRunLoopAddObserver(loop, observer, CFRunLoopMode.commonModes)
    
}

