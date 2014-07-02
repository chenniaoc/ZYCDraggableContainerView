//
//  ZYCDraggableView.m
//  HelloDrag
//
//  Created by YuchenZhang on 6/30/14.
//  Copyright (c) 2014 com.yuchen. All rights reserved.
//

#import "ZYCDraggableContainerView.h"

#define ANIMATION_DURATION 0.3// (arc4random() % 5 * 0.1)

static char * const kZYCDAnimationQueue = "com.yuchen.ZYCDraggableView.animation.queue";

static dispatch_queue_t kZYCAnimationQueue;

@interface ZYCDraggableContainerView ()

/// 元素的宽度
@property (nonatomic, assign) CGFloat elementWidth;

/// 元素的高度
@property (nonatomic, assign) CGFloat elementHeight;

/// 元素与元素之前的垂直间距
@property (nonatomic, assign) CGFloat elementVerticalMargin;
/// 元素与元素之前的水平间距
@property (nonatomic, assign) CGFloat elementHorizontalMargin;
/// 记录移动之前的postion 是个center，做还原位置用
@property (nonatomic, assign) CGPoint originPosition;
/// 被移动的图标起始序列 (index 0~N)
@property (nonatomic, assign) NSInteger startIndex;
/// 被移动的图标目标序列 (index 0~N)
@property (nonatomic, assign) NSInteger distIndex;
/// 存放需要排列Views的数组，可以动态修改里面的元素
@property (nonatomic, strong)NSMutableArray *elements;



@end

@implementation ZYCDraggableContainerView

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kZYCAnimationQueue = dispatch_queue_create(kZYCDAnimationQueue, NULL);
    });
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        _elements = [NSMutableArray array];
        
        //dummy
        _elementVerticalMargin = 5;
        _elementHorizontalMargin = 5;
        
        // dummy
        _elementWidth = 20;
        _elementHeight = 40;
//        CGFloat x = _elementHorizontalMargin;
//        CGFloat y = _elementVerticalMargin;
//        NSInteger colCount = NSIntegerMax;
//        NSArray *tis = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"png" subdirectory:@"Resource"];
//        
//        
//        
//        for (int i = 0 ; i < tis.count; i++) {
//            
//            UIButton *e = [UIButton buttonWithType:UIButtonTypeCustom];;
//            NSURL *imageUrl = [tis objectAtIndex:i];
//            UIImage *iconImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];[NSData dataWithContentsOfURL:imageUrl];
//            
//            _elementWidth = iconImg.size.width /2;
//            _elementHeight = iconImg.size.height / 2;
//            
//            [e setImage:iconImg forState:UIControlStateNormal];
//            
//            UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self
//                                                                                                action:@selector(longPressed:)];
//            [e addGestureRecognizer:longG];
//            
//            if (x + _elementHorizontalMargin * 3 + _elementWidth > self.bounds.size.width) {
//                y += _elementVerticalMargin + _elementHeight;
//                x = _elementHorizontalMargin;
//                if (colCount == NSIntegerMax) {
//                    colCount = i;
//                }
//            } else {
//                x = (_elementWidth + _elementHorizontalMargin) * (i % colCount) + _elementHorizontalMargin;
//            }
//            
//            e.frame = CGRectMake(x , y, _elementWidth, _elementHeight);
//            
//            [_elements addObject:e];
//            [self addSubview:e];
//            
//            
//        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andViews:(NSArray *)views
{
    self = [self initWithFrame:frame];
    if (self) {
        [_elements addObjectsFromArray:views];
    }
    return self;
}


- (void)drawElements
{
    
    CGFloat x = _elementHorizontalMargin;
    CGFloat y = _elementVerticalMargin;
    NSInteger colCount = NSIntegerMax;
    for (int i = 0 ; i < _elements.count; i++) {
        
//        UIButton *e = [UIButton buttonWithType:UIButtonTypeCustom];;
//        NSURL *imageUrl = [tis objectAtIndex:i];
//        UIImage *iconImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];[NSData dataWithContentsOfURL:imageUrl];
//        
//        _elementWidth = iconImg.size.width / 2;
//        _elementHeight = iconImg.size.height/ 2;
//        
//        [e setImage:iconImg forState:UIControlStateNormal];
        UIView *e = _elements[i];
        
        
        UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(longPressed:)];
        [e addGestureRecognizer:longG];
        
        if (x + _elementHorizontalMargin * 3 + _elementWidth > self.bounds.size.width) {
            y += _elementVerticalMargin + _elementHeight;
            x = _elementHorizontalMargin;
            if (colCount == NSIntegerMax) {
                colCount = i;
            }
        } else {
            x = (_elementWidth + _elementHorizontalMargin) * (i % colCount) + _elementHorizontalMargin;
        }
        
        e.frame = CGRectMake(x , y, _elementWidth, _elementHeight);
    
        [self addSubview:e];
        
        
    }
}



- (void)longPressed:(UILongPressGestureRecognizer *)gesture
{
    NSLog(@"long pressed");
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 手势刚刚开始时，记录被选中图片的原始位置（center）
        UIButton *targetButton = (UIButton *)gesture.view;
        _originPosition = targetButton.center;
        // 确保显示在最上层
        [self bringSubviewToFront:targetButton];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged ) {
        CGPoint location = [gesture locationInView:self];
        
        UIButton *targetButton = (UIButton *)gesture.view;
        // 跟随手势移动图标位置
        targetButton.center = location;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        UIButton *targetButton = (UIButton *)gesture.view;
        targetButton.tag = 1000;
        // 判断当前移动后的图标位置是否处于需要重新排列的序列
        NSInteger occuredIndex = [self occuredIndexByPoint:targetButton.center];
        if (occuredIndex >= 0) {
            
            _startIndex = [_elements indexOfObject:targetButton];
            _distIndex = occuredIndex;
            NSLog(@"%d", occuredIndex);
            // 根据起始位置，截止位置 重新layout
            [self relayoutAllElementsWithNewElement:targetButton];
        } else {
            // 不需要重新排列layout，复位之前的位置。
            [UIView animateWithDuration:0.2f animations:^{
                targetButton.center = _originPosition;
            }];
            targetButton.tag = 0;
            _originPosition = CGPointZero;
        }
    }
    
}

- (void)relayoutAllElementsWithNewElement:(UIView *)newElement
{
    
    
    UIView *distView = [_elements objectAtIndex:_distIndex];
    
    
//    dispatch_async(kZYCAnimationQueue, ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //(arc4random() % 5) * 0.1;
//            
//            [UIView animateWithDuration:(arc4random() % 5) animations:^{
//                newElement.frame = distView.frame;
//                //distView.center = _originPosition;
//            }];
//        });
//    });
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        newElement.frame = distView.frame;
    }];
    
    
    
//    [UIView animateWithDuration:0.3 animations:^{
//        newElement.frame = distView.frame;
//        //distView.center = _originPosition;
//    }];
    [_elements removeObjectAtIndex:_startIndex];
    
    [_elements insertObject:newElement
                    atIndex:_distIndex];
    
    CGPoint previousCenter = CGPointZero;
    
    
    // 如果起始index > 截至index ，说明是往前移动了icon
    if (_startIndex > _distIndex ) {
        
        for (int i = _startIndex; i > _distIndex - 1; i--) {
            UIView *element = [_elements objectAtIndex:i];
            if (i == _startIndex) {
                previousCenter = element.center;
                
//                dispatch_sync(kZYCAnimationQueue, ^{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [UIView animateWithDuration:0.3 animations:^{
//                            element.center = _originPosition;
//                        }];
//                    });
//                });
                
                
                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                    element.center = _originPosition;
                }];
            } else {
                CGPoint tempPoint = element.center;
//                dispatch_sync(kZYCAnimationQueue, ^{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [UIView animateWithDuration:0.3 animations:^{
//                            element.center = previousCenter;
//                        }];
//                    });
//                });
                
                
                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                    element.center = previousCenter;
                }];
                
                previousCenter = tempPoint;
            }
        }
        
    } else {
        for (int i = _startIndex; i <= _distIndex - 1; i++) {
            UIView *element = [_elements objectAtIndex:i];
            if (i == _startIndex) {
                previousCenter = element.center;
                
//                dispatch_sync(kZYCAnimationQueue, ^{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [UIView animateWithDuration:0.3 animations:^{
//                            element.center = _originPosition;
//                        }];
//                    });
//                });
                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                    element.center = _originPosition;
                }];
                
                
            
            } else {
                CGPoint tempPoint = element.center;
                
//                dispatch_sync(kZYCAnimationQueue, ^{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [UIView animateWithDuration:0.3 animations:^{
//                            element.center = previousCenter;
//                        }];
//                    });
//                });
                
                
                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                    element.center = previousCenter;
                }];
                
                previousCenter = tempPoint;
                
            }
        }
    }
    

    
    newElement.tag = 0;
}


- (NSInteger)occuredIndexByPoint:(CGPoint)point
{
    __block NSInteger index = -1;
    
    [_elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIView *element = (UIView *)obj;
        CGRect frame = element.frame;
        if (CGRectContainsPoint(frame, point) && element.tag != 1000) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

@end
