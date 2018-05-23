//
//  GYHeaderCollectionViewCell.m
//  LeZhu
//
//  Created by Lean on 2017/3/22.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYHeaderCollectionViewCell.h"

@implementation GYHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 适配4英寸屏幕
    if (iPhone5) {
        self.cellImageH.constant = 40;
        self.cellImageW.constant = 40;
        self.cellLabelH.constant = 10;
        [self.cellLabel setFont:[UIFont systemFontOfSize:11]];
    }else if(iPhone6){
        [self.cellLabel setFont:[UIFont systemFontOfSize:13]];

    }
}

@end
