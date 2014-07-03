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
    NSArray *paths = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"png" subdirectory:@"Resource"];
    
    for (NSURL *url in paths) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *img = [UIImage imageWithData:data scale:2];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:img];
        
        [a addObject:iv];
        
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
