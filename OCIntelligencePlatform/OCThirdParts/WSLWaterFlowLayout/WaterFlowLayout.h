//
//  WaterFlowLayout.h
//  WaterFlowDemo
//
//  Created by yage on 15/9/18.
//  Copyright (c) 2015年 yage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFlowLayout;
@protocol WaterFlowLayoutDelegate <NSObject>

@required
//使用delegate取得每一个Cell的高度
- (CGFloat)waterFlow:(WaterFlowLayout *)layout heightForCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterFlowLayout : UICollectionViewFlowLayout

//声明协议
@property (nonatomic, assign) id <WaterFlowLayoutDelegate> delegate;
//确定列数
@property (nonatomic, assign) NSInteger colum;
//确定内边距
@property (nonatomic, assign) UIEdgeInsets insetSpace;
//确定每个cell之间的距离
@property (nonatomic, assign) NSInteger distance;
//头视图的高度
@property (nonatomic, assign) NSInteger headerSpace;
//尾视图的高度
@property (nonatomic, assign) NSInteger footerSpace;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellWidth;

@end






