//
//  ViewController.m
//  ThreadDemo
//
//  Created by Dely on 16/10/13.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "ViewController.h"
#import "NSThreadViewController.h"
#import "OperationViewController.h"
#import "GCDViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"多线程";
    

}

- (IBAction)NSThreadAction:(UIButton *)sender {
    NSThreadViewController *TVC = [[NSThreadViewController alloc] init];
    [self.navigationController pushViewController:TVC animated:YES];
}


- (IBAction)GCDAction:(UIButton *)sender {
    GCDViewController *GCDVC = [[GCDViewController alloc] init];
    [self.navigationController pushViewController:GCDVC animated:YES];
}

- (IBAction)OperationAction:(UIButton *)sender {
    OperationViewController *OVC = [[OperationViewController alloc] init];
    [self.navigationController pushViewController:OVC animated:YES];
}



@end
