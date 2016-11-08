//
//  JYConcurrenOperation.h
//  ThreadDemo
//
//  Created by Dely on 16/11/7.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JYCompletionBlock)(NSData *imageData);

@interface JYConcurrenOperation : NSOperation

@property (nonatomic, copy) JYCompletionBlock comBlock;

@end
