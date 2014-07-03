//
//  ZYCDraggableView.h
//  HelloDrag
//
//  Created by YuchenZhang on 6/30/14.
//  Copyright (c) 2014 com.yuchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYCDraggableContainerView : UIView

/// 元素的宽度
@property (nonatomic, assign) CGFloat elementWidth;
/// 元素的高度
@property (nonatomic, assign) CGFloat elementHeight;
/// 元素与元素之前的垂直间距
@property (nonatomic, assign) CGFloat elementVerticalMargin;
/// 元素与元素之前的水平间距
@property (nonatomic, assign) CGFloat elementHorizontalMargin;


- (instancetype)initWithFrame:(CGRect)frame andViews:(NSArray *)views;

- (void)drawElements;

@end
