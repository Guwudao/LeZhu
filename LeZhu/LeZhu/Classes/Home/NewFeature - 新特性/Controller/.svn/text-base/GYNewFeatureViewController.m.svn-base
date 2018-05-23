//
//  GYNewFeatureViewController.m
//  LeZhu
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 guanyue. All rights reserved.
//

#import "GYNewFeatureViewController.h"
#import "GYNewFeatureCell.h"


static NSString * const reuseIdentifier = @"Cell";

#define GYItemCount 3

@interface GYNewFeatureViewController ()

@end

@implementation GYNewFeatureViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (instancetype)init{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    return [super initWithCollectionViewLayout:flowLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[GYNewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return GYItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GYNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"门禁启动页%ld",indexPath.item + 1];
    
    cell.image = [UIImage imageNamed:imageName];
    [cell setIndexPath:indexPath cellCount:GYItemCount];
    
    return cell;
}

@end
