//
//  GYMainCollectionViewCell.h
//  LeZhu
//
//  Created by apple on 17/2/21.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYMainCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@end
