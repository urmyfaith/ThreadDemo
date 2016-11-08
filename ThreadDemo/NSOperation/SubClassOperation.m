//
//  SubClassOperation.m
//  ThreadDemo
//
//  Created by Dely on 16/11/7.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "SubClassOperation.h"

@implementation SubClassOperation

- (void)main{
    for (int i = 0; i < 5; ++i) {
        NSLog(@"1-----%@",[NSThread currentThread]);
    }
}

@end
