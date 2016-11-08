//
//  OperationMethod.m
//  ThreadDemo
//
//  Created by Dely on 16/11/7.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "OperationMethod.h"
#import "SubClassOperation.h"

static OperationMethod *share = nil;

@implementation OperationMethod

+ (OperationMethod *)shareOperationManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[OperationMethod alloc] init];
    });
    return share;
}

#pragma mark --------NSoperation任务
//operation创建方式invocationOperation
- (void)invocationOperation{
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    op.completionBlock = ^{
        NSLog(@"任务完成后回调block");
    };
    
    [op start];
}

//operation创建方式blockOperation
- (void)blockOperation{
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"------%@", [NSThread currentThread]);
    }];
    [op start];
}

//blockoperation添加任务
- (void)blockOperationAddTask{
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"------%@", [NSThread currentThread]);
    }];
    for (int i = 0; i < 5; i++) {
        [op addExecutionBlock:^{
            NSLog(@"%d------%@", i,[NSThread currentThread]);
        }];
    }
    
    [op start];
}

//NSoperation子类
- (void)subClassOperation{
    SubClassOperation *sop = [[SubClassOperation alloc] init];
    [sop start];
}

- (void)run{
    NSLog(@"------%@", [NSThread currentThread]);
}

#pragma mark --------任务加入NSoperation队列
- (void)addOperationToQueue{
    
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2. 创建操作
    // 创建NSInvocationOperation
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run2) object:nil];
    // 创建NSBlockOperation
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"op2---->%d-----%@", i,[NSThread currentThread]);
        }
    }];
    
    // 3. 添加操作到队列中：addOperation:
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
}

- (void)run2{
    for (int i = 0; i < 5; i++) {
        NSLog(@"op1---->%d-----%@",i, [NSThread currentThread]);
    }
}

- (void)addOperationWithBlockToQueue{
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 设置最大并发操作数
    //    queue.maxConcurrentOperationCount = 1;// 就变成了串行队列
    queue.maxConcurrentOperationCount = 5;

    for (int i = 0; i < 5; i++) {
        [queue addOperationWithBlock:^{
            NSLog(@"%d-----%@",i, [NSThread currentThread]);
        }];
    }
    
}


#pragma mark --------------操作依赖
- (void)operateDependency{

    NSMutableArray *array = [NSMutableArray array];
    
    //创建任务
    for (int i = 0; i < 10; i++) {
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"________第%d个任务%@____",i,[NSThread currentThread]);
        }];
        op.name = [NSString stringWithFormat:@"op%d",i];
        
        [array addObject:op];
    }
    
    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.name = @"queue";
    
    //设置依赖 可以跨队列依赖。
    for (int i = 0; i < array.count - 1; i++) {
        //依次依赖,下面相当于同步执行了
        NSBlockOperation *op1 = [array objectAtIndex:i];
        NSBlockOperation *op2 = [array objectAtIndex:i+1];
        [op2 addDependency:op1];
        
//        //修改 Operation 在队列中的优先级
//        if (i == 6) {
//            [op1 setQueuePriority:NSOperationQueuePriorityVeryHigh];
//        }
//
//        if (i > 4) {
//            //删除依赖
//            [op2 removeDependency:op1];
//        }
    }
    
//    //需求：第5个任务完成后取消队列任务
//    NSBlockOperation *op1 = [array objectAtIndex:4];
//    op1.completionBlock = ^{
//        //取消队列中未执行的所有任务
//        [queue cancelAllOperations];
//    };
    
    //添加任务到队列中
    [queue addOperations:array waitUntilFinished:NO];
    
}




@end
