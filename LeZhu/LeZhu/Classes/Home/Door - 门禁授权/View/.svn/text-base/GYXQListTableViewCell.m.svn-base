//
//  GYXQListTableViewCell.m
//  LeZhu
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYXQListTableViewCell.h"

@implementation GYXQListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self adaptScreen];
}

- (void)adaptScreen{
    if (iPhone5) {
        self.xqnameL.font = [UIFont systemFontOfSize:15];
    }else if (iPhone6){
        self.xqnameL.font = [UIFont systemFontOfSize:16];
    }else{
        self.xqnameL.font = [UIFont systemFontOfSize:17];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
