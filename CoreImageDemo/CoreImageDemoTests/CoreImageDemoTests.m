//
//  CoreImageDemoTests.m
//  CoreImageDemoTests
//
//  Created by fumi on 2019/6/25.
//  Copyright © 2019 rayor. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "FilterViewController.h"

//@testable CoreImageDemo;

@interface CoreImageDemoTests : XCTestCase

@end

@implementation CoreImageDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    FilterViewController *vc = [[FilterViewController alloc] init];
    [self measureBlock:^{
        for (int i = 0; i < 50; i++) {
            [vc getImageFromContext];
        }
    }];
}

@end
