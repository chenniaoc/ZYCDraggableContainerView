//
//  ZYCDraggableView.h
//  HelloDrag
//
//  Created by YuchenZhang on 6/30/14.
//  Copyright (c) 2014 com.yuchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYCDraggableContainerView : UIView

- (instancetype)initWithFrame:(CGRect)frame andViews:(NSArray *)views;

- (void)drawElements;

@end
