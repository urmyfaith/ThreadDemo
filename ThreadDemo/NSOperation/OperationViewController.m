//
//  OperationViewController.m
//  ThreadDemo
//
//  Created by Dely on 16/10/17.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "OperationViewController.h"
#import "OperationMethod.h"
#import "JYSerialOperation.h"
#import "JYConcurrenOperation.h"
#import "JYConcurrentOperation2.h"

@interface OperationViewController ()

@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSOperation";
}

#pragma mark --------创建任务
- (IBAction)invocationOperation:(UIButton *)sender {
    [[OperationMethod shareOperationManager] invocationOperation];
}

- (IBAction)blockOperation:(UIButton *)sender {
    [[OperationMethod shareOperationManager] blockOperation];
}

- (IBAction)addExecutionBlock:(UIButton *)sender {
    [[OperationMethod shareOperationManager] blockOperationAddTask];
    
}

- (IBAction)subClassOperation:(UIButton *)sender {
    [[OperationMethod shareOperationManager] subClassOperation];
}

- (IBAction)addOperationToQueue:(UIButton *)sender {
    [[OperationMethod shareOperationManager] addOperationToQueue];
}


- (IBAction)addOperationWithBlockToQueue:(UIButton *)sender {
    [[OperationMethod shareOperationManager] addOperationWithBlockToQueue];
   
}

- (IBAction)operateDependency:(UIButton *)sender {
    [[OperationMethod shareOperationManager] operateDependency];
}

- (IBAction)studyNSOperation:(UIButton *)sender {
//    [self studyNSOperation1];
//    [self studyNSOperation2];
//    [self studyNSOperation3];
    [self studyNSOperation4];
}

- (void)studyNSOperation1{
    //实例1
    JYSerialOperation *op = [[JYSerialOperation alloc] init];
    [op start];
    
    op.comBlock = ^(NSData *imageData){
        UIImage *image = [UIImage imageWithData:imageData];
        self.imageView.image = image;
    };
}

- (void)studyNSOperation2{
    //主线程运行
    JYConcurrenOperation *op = [[JYConcurrenOperation alloc] init];
    [op start];
    
    op.comBlock = ^(NSData *data){
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
    };
}

- (void)studyNSOperation3{
    //子线程运行 NSURLConnection代理不走
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"========current NSthread = %@",[NSThread currentThread]);
        JYConcurrenOperation *op = [[JYConcurrenOperation alloc] init];
        [op start];
        
        op.comBlock = ^(NSData *data){
            UIImage *image = [UIImage imageWithData:data];
            self.imageView.image = image;
        };
    });
}

- (void)studyNSOperation4{
    //子线程运行
    JYConcurrentOperation2 *op = [[JYConcurrentOperation2 alloc] init];

    op.comBlock = ^(NSData *data){
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
    };
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:op];

    
}

//异步下载图片
- (IBAction)aysncDownloadImageAction:(UIButton *)sender {
    //创建队列
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc]init];
    //创建任务
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downLoadImage) object:nil];
    //将任务添加到队列中
    [operationQueue addOperation:operation];
    
}

//子线程中下载图片
- (void)downLoadImage{
    //创建url
    NSURL *url=[NSURL URLWithString:@"https://p1.bpimg.com/524586/475bc82ff016054ds.jpg"];
    //将资源转换为二进制
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSLog(@"2--->%@",[NSThread currentThread]);
    //将二进制转化为tup
    UIImage *image=[UIImage imageWithData:data];
    
    //主队列中更新UI
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"3--->%@",[NSThread currentThread]);
        self.imageView.image=image;
    }];
    
}

- (IBAction)operationSubClassAction:(UIButton *)sender {
//    //创建任务1  不加入队列中默认在主线程中执行
      //默认情况下，调用了start方法后并不会开一条新线程去执行操作，而是在当前线程同步执行操作
      // 只有将NSOperation放到一个NSOperationQueue中，才会异步执行操作
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downLoadImage) object:nil];
//    [operation start];
    
    
    //创建任务2 只要NSBlockOperation封装的操作数 > 1，就会异步执行操作,等于1的时候默认是同步的
     NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self downLoadImage];
    }];
    
    //加入的任务会开启一条新的线程
    [operation addExecutionBlock:^{
        NSLog(@"2222222%@",[NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"3333333%@",[NSThread currentThread]);
    }];
    
    [operation start];
    
}





- (void)dealloc{
    NSLog(@"NSOperation dealloc");
}


@end
