//
//  JYConcurrenOperation.m
//  ThreadDemo
//
//  Created by Dely on 16/11/7.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "JYConcurrenOperation.h"

@interface JYConcurrenOperation ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;

@end

@implementation JYConcurrenOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (BOOL)isConcurrent{
    return YES;
}

- (void)start{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSURL *url=[NSURL URLWithString:@"http://p1.bpimg.com/524586/79a7a2915b550222.jpg"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    _connection = [[NSURLConnection alloc] initWithRequest:request
                                                  delegate:self];
    if (_connection == nil) [self finish];
}

- (void)finish{
    
    self.connection = nil;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    if (self.comBlock) {
        self.comBlock (_data);
    }
}

#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // to do something...
    self.data       = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // to do something...
    NSLog(@"%ld",data.length);
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self finish];
}



@end
