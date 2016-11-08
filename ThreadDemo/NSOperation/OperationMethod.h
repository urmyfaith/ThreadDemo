//
//  OperationMethod.h
//  ThreadDemo
//
//  Created by Dely on 16/11/7.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationMethod : NSObject

+ (OperationMethod *)shareOperationManager;

#pragma mark --------NSoperation任务
//operation创建方式invocationOperation
- (void)invocationOperation;

//operation创建方式blockOperation
- (void)blockOperation;

//blockoperation添加任务
- (void)blockOperationAddTask;

//子类任务
- (void)subClassOperation;

#pragma mark --------任务加入NSoperation队列
//添加operationToQueue
- (void)addOperationToQueue;

- (void)addOperationWithBlockToQueue;

//操作依赖
- (void)operateDependency;


@end
