//
//  JWNetWorking.m
//
//
//  Created by apple on 17/2/23.
//  Copyright © 2017年 梁家威. All rights reserved.
//

#import "JWNetWorking.h"

@interface JWNetWorking()

@property(nonatomic, strong) AFHTTPSessionManager *afnManager;

@end

@implementation JWNetWorking

static JWNetWorking *jwManager = nil;

// 单例
+ (JWNetWorking *)sharedManager{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        jwManager = [[JWNetWorking alloc] init];
        jwManager.afnManager = [AFHTTPSessionManager manager];
    });
    jwManager.timeOut = 20;
    return jwManager;
}

// GET请求
- (void)getRequestWithUrl:(NSString *)url parameter:(NSDictionary *)parameter successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    // [AFJSONResponseSerializer serializer] : JSON
    // [AFOnoResponseSerializer XMLResponseSerializer] ： XML
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"image/jpeg", @"image/png", @"application/octet-stream",  @"text/json", @"text/javascript",@"text/html",nil];
    self.afnManager.responseSerializer = response;
    [self.afnManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.afnManager.requestSerializer.timeoutInterval = 10.f;
    [self.afnManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [self.afnManager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        if (failureBlock) {
            failureBlock(errorStr);
        }
    }];
}

// POST请求
- (void)postRequestWithUrl:(NSString *)url parameter:(NSDictionary *)parameter successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    self.afnManager.responseSerializer = response;
    
    [self.afnManager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        if (failureBlock) {
            failureBlock(errorStr);
        }
    }];
}



@end
