//
//  NSThreadViewController.m
//  ThreadDemo
//
//  Created by Dely on 16/10/17.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "NSThreadViewController.h"
#import "SellTicketsViewController.h"

@interface NSThreadViewController ()

@end

@implementation NSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSThread";
    
}

- (IBAction)downloadAction:(UIButton *)sender {
//    [self categoryNSthreadMethod];
//    [self classNSthreadMethod];
//    [self objectNSthreadMethod];
    
    //去卖票
    SellTicketsViewController *vc = [[SellTicketsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//通过NSObject的分类方法开辟线程
- (void)categoryNSthreadMethod{
    [self performSelectorInBackground:@selector(downloadImage) withObject:nil];
}

//通过NSThread类方法开辟线程
- (void)classNSthreadMethod{
    //异步1
//    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
    
    //异步方式2
    [NSThread detachNewThreadWithBlock:^{
        [self downloadImage];
    }];
}

//通过NSThread对象方法去下载图片
- (void)objectNSthreadMethod{
    //创建一个程序去下载图片
    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(downloadImage) object:nil];
    //开启线程
    [thread start];
    thread.name = @"imageThread";
}

//下载图片
- (void)downloadImage{
    NSURL *url = [NSURL URLWithString:@"https://p1.bpimg.com/524586/475bc82ff016054ds.jpg"];
    
    //线程延迟10s
    [NSThread sleepForTimeInterval:5.0];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSLog(@"downLoadImage:%@",[NSThread currentThread]);//在子线程中下载图片
    //在主线程更新UI
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];

}

//更新imageView
- (void)updateImage:(NSData *)data{
    NSLog(@"updateImage:%@",[NSThread currentThread]);//在主线程中更新UI
    //将二进制数据转换为图片
    UIImage *image=[UIImage imageWithData:data];
    //设置image
    self.imageView.image=image;
}




//点击屏幕调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan开始执行");
    //同步调用
//    [self start];
    
    //异步调用
    sleep(2);
    [self performSelectorInBackground:@selector(start) withObject:nil];
    NSLog(@"touchesBegan执行结束");
}

//开始执行
- (void)start{
    NSLog(@"start开始执行");
    NSLog(@"start当前线程:%@",[NSThread currentThread]);
    //延迟5秒调用
    [NSThread sleepForTimeInterval:5];
    NSLog(@"start执行完毕");
}

- (void)dealloc{
    NSLog(@"NSThread dealloc");
}

@end
