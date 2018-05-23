//
//  XiaoQuModel.h
//  LeZhu
//
//  Created by apple on 17/3/1.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiaoQuModel : NSObject

/** 小区id */
@property (nonatomic, assign) NSInteger ID;

/** 物业id */
@property (nonatomic, assign) NSInteger wuyeid;

/** 小区名字 */
@property (nonatomic, copy) NSString *name;

/** 小区图片 */
@property (nonatomic, copy) NSString *pic;

/** 小区地址 */
@property (nonatomic, copy) NSString *address;

/** 小区邮编 */
@property (nonatomic, assign) NSInteger zip;

/** 经度 */
@property (nonatomic, copy) NSString *jd;

/** 纬度 */
@property (nonatomic, copy) NSString *wd;


@end
