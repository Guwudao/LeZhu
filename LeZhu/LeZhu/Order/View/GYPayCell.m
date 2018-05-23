//
//  GYPayCell.m
//  LeZhu
//
//  Created by Lean on 2017/3/24.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYPayCell.h"

@interface GYPayCell()


@end

@implementation GYPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.payBtn.layer.cornerRadius = 4;
    self.cancelBtn.layer.cornerRadius = 4;
}

-(void)setFrame:(CGRect)frame{
    frame.size.height -= 10;
    frame.origin.y += 10;
    
    [super setFrame:frame];
}

// 点击确认付款
- (IBAction)payConfirmBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(payBtnClick:)]) {
        [self.delegate payBtnClick:self];
    }
}

// 点击取消订单
- (IBAction)cancelOrderBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelOrderBtnClick:)]) {
        [self.delegate cancelOrderBtnClick:self];
    }
}

@end
