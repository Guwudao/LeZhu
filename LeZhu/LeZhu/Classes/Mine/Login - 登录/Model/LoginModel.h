//
//  LoginModel.h
//  LeZhu
//
//  Created by apple on 17/3/1.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "XiaoQuModel.h"
#import "WuYeModel.h"
#import "OwnerModel.h"

@interface LoginModel : NSObject

/** 登录结果 0失败 1成功 */
@property (nonatomic, assign) NSInteger code;

/** 用户基本信息 */
@property (nonatomic, strong) UserInfoModel *info;

/** 小区信息 */
@property (nonatomic, strong) XiaoQuModel *xiaoqu;

/** 物业信息 */
@property (nonatomic, strong) WuYeModel *wuye;

/** 业主信息 */
@property (nonatomic, strong) OwnerModel *owner;

@end
