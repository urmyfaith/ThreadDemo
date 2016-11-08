//
//  GCDViewController.m
//  ThreadDemo
//
//  Created by Dely on 16/10/17.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "GCDViewController.h"
#import "GCDMethod.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD";
    // Do any additional setup after loading the view from its nib.
    
}


#pragma mark - 1.异步下载图片
- (IBAction)downLoadAction:(UIButton *)sender {
    self.imageView.image = nil;
    //获取全局队列
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //异步下载图片
        NSURL *url=[NSURL URLWithString:@"https://p1.bpimg.com/524586/475bc82ff016054ds.jpg"];
        //将资源转换为二进制
        NSData *data=[NSData dataWithContentsOfURL:url];
        //将二进制转化为图片
        UIImage *image=[UIImage imageWithData:data];
        
        //获取主队列,更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            //给图片控件赋值
            self.imageView.image=image;
        });
    });
}

//串行队列同步
- (IBAction)serialQueueSyncMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] serialQueueSyncMethod];
}

//串行队列异步
- (IBAction)serialQueueAsyncMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] serialQueueAsyncMethod];
}

//并发队列异步
- (IBAction)concurrentQueueSyncMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] concurrentQueueSyncMethod];
}

//并发队列异步
- (IBAction)concurrentQueueAsyncMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] concurrentQueueAsyncMethod];
}

//全局队列同步
- (IBAction)globalSyncMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] globalSyncMethod];
}

//全局队列异步
- (IBAction)globalAsyncMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] globalAsyncMethod];
}


//主队列同步
- (IBAction)mainSyncMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] mainSyncMethod];
}

//主队列异步
- (IBAction)mainAsyncMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] mainAsyncMethod];
}

//延迟执行
- (IBAction)GCDAfterRunMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] GCDAfterRunMethod];
}

//修改优先级
- (IBAction)GCDSetTargetQueueMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] GCDSetTargetQueueMethod];
}

//自动执行任务组
- (IBAction)GCDAutoDispatchGroupMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] GCDAutoDispatchGroupMethod];
}

//手动执行任务组
- (IBAction)GCDManualDispatchGroupMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] GCDManualDispatchGroupMethod];
}

//添加栅栏任务
- (IBAction)GCDBarrierAsyncMethod:(UIButton *)sender {
   [[GCDMethod shareGCDMethodManager] GCDBarrierAsyncMethod];
}

//循环执行任务
- (IBAction)GCDDispatchApplyMethod:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] GCDDispatchApplyMethod];
}

//队列的挂起和唤醒
- (IBAction)GCDDispatch_suspend_resume:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] GCDDispatch_suspend_resume];
}

//信号量
- (IBAction)GCDDispatchSemaphore:(UIButton *)sender {
    [[GCDMethod shareGCDMethodManager] GCDDispatchSemaphore];
    
}

//队列IO操作
- (IBAction)GCDDispatch_IO:(UIButton *)sender {
    NSLog(@"后面再补充");
}

- (void)dealloc{
    NSLog(@"GCD dealloc");
}

@end
