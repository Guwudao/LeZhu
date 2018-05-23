//
//  GYLineView.m
//  LeZhu
//
//  Created by apple on 17/2/21.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYLineView.h"

@interface GYLineView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTitleH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTitleW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLineW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLineW;

@end

@implementation GYLineView

+ (instancetype)lineView{
    return [[[NSBundle mainBundle] loadNibNamed:@"GYLineView" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    // 适配屏幕
    if (iPhone5) {
        _headerTitleH.constant = _headerTitleH.constant - 5;
        _headerTitleW.constant = _headerTitleW.constant - 20;
        _leftLineW.constant = _leftLineW.constant - 30;
        _rightLineW.constant = _rightLineW.constant  - 30;
        
    }else if (iPhone6P){
        _headerTitleH.constant = _headerTitleH.constant * scale6p;
        _headerTitleW.constant = _headerTitleW.constant * scale6p;
        _leftLineW.constant = _leftLineW.constant * scale6p + 20;
        _rightLineW.constant = _rightLineW.constant  * scale6p + 20;
    }
    
}
@end
