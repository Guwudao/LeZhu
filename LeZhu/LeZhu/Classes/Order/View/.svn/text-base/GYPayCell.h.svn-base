//
//  GYPayCell.h
//  LeZhu
//
//  Created by Lean on 2017/3/24.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义协议, 让外界处理两个按钮的点击事件
@class GYPayCell;

@protocol GYPayCellProtocol <NSObject>

@optional

/**
 *   点击确认付款
 */
- (void)payBtnClick:(GYPayCell *)payCell;

/**
 *   点击取消订单
 */
- (void)cancelOrderBtnClick:(GYPayCell *)payCell;

@end

@interface GYPayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serveTypeL;// 服务类型
@property (weak, nonatomic) IBOutlet UILabel *payStatusL;// 支付状态
@property (weak, nonatomic) IBOutlet UILabel *locationL; // 地点
@property (weak, nonatomic) IBOutlet UILabel *dateL;     // 日期时间
@property (weak, nonatomic) IBOutlet UILabel *priceL;    // 价格

@property (weak, nonatomic) IBOutlet UIButton *payBtn;   // 确认付款
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;// 取消订单

@property (weak, nonatomic) id<GYPayCellProtocol> delegate;// 代理

@end
