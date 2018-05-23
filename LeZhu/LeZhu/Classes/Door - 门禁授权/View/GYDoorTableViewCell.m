//
//  GYDoorTableViewCell.m
//  LeZhu
//
//  Created by apple on 17/3/2.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYDoorTableViewCell.h"

@interface GYDoorTableViewCell()

@end

@implementation GYDoorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.certificateL.layer.cornerRadius = 2;
    
    [self adaptScreen];
    
}

- (void)adaptScreen{
    if (iPhone5) {
        self.xiaoquNameL.font = [UIFont systemFontOfSize:15];
    }else if (iPhone6){
        self.xiaoquNameL.font = [UIFont systemFontOfSize:16];
    }else{
        self.xiaoquNameL.font = [UIFont systemFontOfSize:17];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
