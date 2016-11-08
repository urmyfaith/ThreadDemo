//
//  JYConcurrentOperation2.h
//  ThreadDemo
//
//  Created by Dely on 16/11/7.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JYCompletionBlock)(NSData *imageData);

@interface JYConcurrentOperation2 : NSOperation

@property (nonatomic, copy) JYCompletionBlock comBlock;

@end
