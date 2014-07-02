//
//  ZYCViewController.m
//  HelloDrag
//
//  Created by YuchenZhang on 6/30/14.
//  Copyright (c) 2014 com.yuchen. All rights reserved.
//

#import "ZYCViewController.h"
#import "ZYCDraggableContainerView.h"

@interface ZYCViewController ()

@end

@implementation ZYCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *a = [NSMutableArray array];
    for (int i =0 ; i< 100; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.backgroundColor = [UIColor redColor];
        [a addObject:view];
        
    }
    
    ZYCDraggableContainerView * view = [[ZYCDraggableContainerView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 800) andViews:a];
    
    [view drawElements];
    
    [self.view addSubview:view];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
