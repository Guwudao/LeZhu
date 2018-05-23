//
//  JWNetWorking.h
//
//
//  Created by apple on 17/2/23.
//  Copyright © 2017年 梁家威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface JWNetWorking : NSObject

/**  请求成功Block */
typedef void(^SuccessBlock)(id responseBody);

/**  请求失败Block */
typedef void(^FailureBlock)(NSString *error);

/**  超时时间 */
@property (assign, nonatomic) CGFloat timeOut;



/**
 *  获取网络请求管理者单例
 *  @return 网络请求管理者单例
 */
+ (JWNetWorking *)sharedManager;



/**
 *  发送GET请求
 *  @param url          请求路径
 *  @param parameter    请求参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 */
- (void)getRequestWithUrl:(NSString *)url parameter:(NSDictionary *)parameter successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;



/**
 *  发送POST请求
 *  @param url          请求路径
 *  @param parameter    请求参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 */
- (void)postRequestWithUrl:(NSString *)url parameter:(NSDictionary *)parameter successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;


@end
