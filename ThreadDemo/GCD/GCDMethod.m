//
//  GCDMethod.m
//  ThreadDemo
//
//  Created by Dely on 16/10/20.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "GCDMethod.h"

static GCDMethod *method = nil;

@implementation GCDMethod

+ (GCDMethod *)shareGCDMethodManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method = [[GCDMethod alloc] init];
    });
    return method;
}

#pragma mark - 串行队列同步和串行队列异步
//串行队列同步
- (void)serialQueueSyncMethod{
    //创建队列
    dispatch_queue_t queue = dispatch_queue_create("serialQueueSyncMethod", DISPATCH_QUEUE_SERIAL);
    //执行任务
    for (int i = 0; i < 6; i++) {
        NSLog(@"mainThread--->%d",i);
        dispatch_sync(queue, ^{
            NSLog(@"Current Thread=%@---->%d-----",[NSThread currentThread],i);
        });
    }
    NSLog(@"串行队列同步end");
}

//串行队列异步
- (void)serialQueueAsyncMethod{
    dispatch_queue_t queue = dispatch_queue_create("serialQueueAsyncMethod", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 6; i++) {
        NSLog(@"mainThread--->%d",i);
        dispatch_async(queue, ^{
            NSLog(@"Current Thread=%@---->%d-----",[NSThread currentThread],i);
        });
    }
    NSLog(@"串行队列异步end");
}

#pragma mark - 并行队列同步和并行队列异步
//并行队列同步
- (void)concurrentQueueSyncMethod{
  dispatch_queue_t queue = dispatch_queue_create("concurrentQueueSyncMethod", DISPATCH_QUEUE_CONCURRENT);

  for (int i = 0; i < 6; i++) {
      dispatch_sync(queue, ^{
          NSLog(@"Current Thread=%@---->%d-----",[NSThread currentThread],i);
      });
  }
  NSLog(@"并行队列同步end");
}

//并行队列异步
- (void)concurrentQueueAsyncMethod{
  dispatch_queue_t queue = dispatch_queue_create("concurrentQueueAsyncMethod", DISPATCH_QUEUE_CONCURRENT);

  for (int i = 0; i < 6; i++) {
      dispatch_async(queue, ^{
          NSLog(@"Current Thread=%@---->%d-----",[NSThread currentThread],i);
      });
  }

  NSLog(@"并行队列异步end");
}


#pragma mark -全局队列同步和全局队列异步(工作表现与并发队列一致)
//全局队列同步
- (void)globalSyncMethod{
    //获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //执行任务
    for (int i = 0; i < 10; ++i) {
        dispatch_sync(queue, ^{
            NSLog(@"global_queue_sync%@---->%d----",[NSThread currentThread],i);
        });
    }
    NSLog(@"global_queue_sync_end");
}

//全局队列异步
- (void)globalAsyncMethod{
    //获取全局队列
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //执行任务
    for (int i = 0; i < 10; ++i) {
        dispatch_async(queue, ^{
            NSLog(@"global_queue_async%@---->%d----",[NSThread currentThread],i);
        });
    }
    NSLog(@"global_queue_async_end");
}

#pragma mark -主队列同步和主队列异步
//主队列同步
- (void)mainSyncMethod{
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //执行任务
    for (int i = 0; i < 10; ++i) {
        dispatch_sync(queue, ^{
            NSLog(@"main_queue_sync%@---->%d----",[NSThread currentThread],i);
        });
    }
    NSLog(@"main_queue_sync_end");
}

//主队列异步
- (void)mainAsyncMethod{
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //执行任务
    for (int i = 0; i < 10; ++i) {
        dispatch_async(queue, ^{
           NSLog(@"main_queue_async%@---->%d----",[NSThread currentThread],i);
        });
    }
    NSLog(@"main_queue_async_end");
}

#pragma mark -  延迟执行
- (void)GCDAfterRunMethod{
    // 循环5次
    for (int i =0; i < 10000; i++ ) {
        NSLog(@"let's go %d",i);
        // 设置2秒后执行block
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
        
        dispatch_after(time, dispatch_get_main_queue(), ^{
            NSLog(@"This is my %d number!%@",i,[NSThread currentThread]);
        });
    }
      //等价于下面实现
//    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
//    for (int i = 0; i < 10000; i++) {
//        NSLog(@"let's go %d",i);
//        dispatch_async(queue, ^{
//           dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"This is my %d number!%@",i,[NSThread currentThread]);
//           });
//        });
//    }

}

#pragma mark - 变更优先级  dispatch_queue_create函数生成的queue是与Global Dispatch Queue默认优先级相同的优先级来执行线程的。
- (void)GCDSetTargetQueueMethod{
    
    dispatch_queue_t targetQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_CONCURRENT);
    //更改优先级
    dispatch_set_target_queue(queue1, targetQueue);
    
    for (int i = 0; i < 6; i++) {
        dispatch_async(queue1, ^{
            NSLog(@"queue1-currentThread = %@-->%d",[NSThread currentThread],i);
        });
    }
    for (int i = 0; i < 6; i++) {
        dispatch_async(queue2, ^{
            NSLog(@"queue2-----currentThread = %@----->%d",[NSThread currentThread],i);
        });
    }
    
    
//    dispatch_queue_t targetQueue = dispatch_queue_create("targetQueue", DISPATCH_QUEUE_SERIAL);//目标队列
//    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);//串行队列
//    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_CONCURRENT);//并发队列
//    //设置参考
//    dispatch_set_target_queue(queue1, targetQueue);
//    dispatch_set_target_queue(queue2, targetQueue);
//    
//    for (int i = 0; i < 6; i++) {
//        dispatch_async(queue1, ^{
//            NSLog(@"queue1-currentThread = %@-->%d",[NSThread currentThread],i);
//        });
//    }
//    for (int i = 0; i < 6; i++) {
//        dispatch_async(queue2, ^{
//            NSLog(@"queue2-currentThread = %@-->%d",[NSThread currentThread],i);
//        });
//    }
}

#pragma mark - Dispatch Group
//自动执行任务组
- (void)GCDAutoDispatchGroupMethod{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < 6; i++) {
        
        dispatch_group_async(group, queue, ^{
            NSLog(@"current Thread = %@----->%d",[NSThread currentThread],i);
        });
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"current Thread = %@----->这是最后执行",[NSThread currentThread]);
    });
    
//    //等待group处理结束
////    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*USEC_PER_SEC));//1微秒
//    long result = dispatch_group_wait(group, time);
//    if (result == 0) {
//        //属于Dispatch Group 的block任务全部处理结束
//        NSLog(@"Dispatch Group全部处理完毕");
//
//    }else{
//        //属于Dispatch Group 的block任务还在处理中
//        NSLog(@"Dispatch Group正在处理");
//    }
//    
//    //有个疑问？如果用wait()超时的如何取消线程
//    //简易版的dispatch_group_wait()函数如下：
//    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_sync(queue1, ^{
//        
//        for (int i = 0; i < 5; i++) {
//            NSLog(@"%@ ------>%d",[NSThread currentThread],i);
//        }
//    });
}


//手动执行任务组
- (void)GCDManualDispatchGroupMethod{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < 6; i++) {
        
        dispatch_group_enter(group);//进入队列组
        
        dispatch_async(queue, ^{
            NSLog(@"current Thread = %@----->%d",[NSThread currentThread],i);
            
            dispatch_group_leave(group);//离开队列组
        });
    }
    
    long result = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);//阻塞当前线程，直到所有任务执行完毕才会继续往下执行
    if (result == 0) {
        //属于Dispatch Group 的block任务全部处理结束
        NSLog(@"Dispatch Group全部处理完毕");

    }else{
        //属于Dispatch Group 的block任务还在处理中
        NSLog(@"Dispatch Group正在处理");
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"current Thread = %@----->这是最后执行",[NSThread currentThread]);
    });
}

#pragma mark - Dispatch_barrier_async
- (void)GCDBarrierAsyncMethod{
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    void(^blk1_reading)(void) = ^{
         NSLog(@"blk1---reading");
    };
    
    void(^blk2_reading)(void) = ^{
        NSLog(@"blk2---reading");
    };
    void(^blk3_reading)(void) = ^{
        NSLog(@"blk3---reading");
    };
    void(^blk4_reading)(void) = ^{
        NSLog(@"blk4---reading");
    };
    void(^blk_writing)(void) = ^{
        NSLog(@"blk---writing");
    };
    
    dispatch_async(concurrentQueue, blk1_reading);
    dispatch_async(concurrentQueue, blk2_reading);
    
    //添加追加操作,,会等待b1和b2全部执行结束，执行完成追加操作b，才会继续并发执行下面操作
    dispatch_barrier_async(concurrentQueue, blk_writing);
    
    dispatch_async(concurrentQueue, blk3_reading);
    dispatch_async(concurrentQueue, blk4_reading);

}

#pragma mark - Dispatch_apply
- (void)GCDDispatchApplyMethod{
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_apply(10, queue, ^(size_t index){
//        NSLog(@"%zu", index);
//    });
//    
//    NSLog(@"done");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    void(^blk1_reading)(void) = ^{
        NSLog(@"blk1---reading");
    };
    
    void(^blk2_reading)(void) = ^{
        NSLog(@"blk2---reading");
    };
    void(^blk3_reading)(void) = ^{
        NSLog(@"blk3---reading");
    };
    void(^blk_writing)(void) = ^{
        NSLog(@"blk---writing");
    };

    NSMutableArray *array = [NSMutableArray new];
    [array addObject:blk1_reading];
    [array addObject:blk2_reading];
    [array addObject:blk3_reading];
    [array addObject:blk_writing];
    
    dispatch_async(queue, ^{
        dispatch_apply(array.count, queue, ^(size_t index) {
            void (^blk)(void) = [array objectAtIndex:index];
            blk();
            NSLog(@"%zu====%@",index,[array objectAtIndex:index]);
        });
        NSLog(@"全部执行结束");
        dispatch_async(dispatch_get_main_queue(), ^{
            //在main Dispatch queue中执行处理，更新用户界面等待
            NSLog(@"done");
        });
    });

}

#pragma mark -Dispatch_suspend/Dispatch_resume
- (void)GCDDispatch_suspend_resume{
    //系统默认生成的，所以无法调用dispatch_resume()和dispatch_suspend()来控制执行继续或中断。
    
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", 0);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", 0);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_async(queue1, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"%@-------%d",[NSThread currentThread],i);
            sleep(1);
            
        }
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"task2");
    });
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"task1 finished!");
    });
    dispatch_group_async(group, queue2, ^{
        dispatch_suspend(queue1);//挂起
        NSLog(@"task2 finished!挂起queue1");
        [NSThread sleepForTimeInterval:20.0];
        dispatch_resume(queue1);//唤醒队列
        
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    

    
    dispatch_async(queue1, ^{
        NSLog(@"task3");
    });
    dispatch_async(queue2, ^{
        NSLog(@"task4");
    });
}


#pragma mark - 信号量
- (void)GCDDispatchSemaphore{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            
            dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10*NSEC_PER_SEC)));
            
            [array addObject:[NSNumber numberWithInteger:i]];
                                    
            dispatch_semaphore_signal(semaphore);
        });
        
        NSLog(@"%@",array);
    }
}


#pragma mark -获取dispatch_time_t
dispatch_time_t  getDispatchTimeByDate(NSDate *date){
    NSTimeInterval interval;
    double second,subSecond;
    struct timespec time;
    dispatch_time_t milestone;
    
    interval = [date timeIntervalSince1970];
    
    subSecond = modf(interval, &second);
    time.tv_sec = second;
    time.tv_nsec = subSecond * NSEC_PER_SEC;
    
    milestone = dispatch_walltime(&time, 0);
    return milestone;
    
}

//获取格林治时间

NSDate * getDateFromDataString(NSString *dateString){
    //    NSString *string = [formatter stringFromDate:date];
    //    NSLog(@"%@", string);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // HH是24进制，hh是12进制
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    // 返回的格林治时间
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

@end
