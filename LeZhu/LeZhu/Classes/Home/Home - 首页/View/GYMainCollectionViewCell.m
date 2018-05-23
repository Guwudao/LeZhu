//
//  GYMainCollectionViewCell.m
//  LeZhu
//
//  Created by apple on 17/2/21.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYMainCollectionViewCell.h"

@interface GYMainCollectionViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellImageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellImageW;

@end

@implementation GYMainCollectionViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    
    if (iPhone5) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.subtitleLabel.font = [UIFont systemFontOfSize:10];
        self.cellImageH.constant = 45;
        self.cellImageW.constant = 45;
    }else if(iPhone6){
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.subtitleLabel.font = [UIFont systemFontOfSize:11];
    }
}

@end
