//
//  ViewController.m
//  adGuideViewtest
//
//  Created by 董江 on 16/1/13.
//  Copyright © 2016年 greenpoint. All rights reserved.
//

#import "ViewController.h"
#import "CMAdGuideView.h"

@interface ViewController ()<CMAdGuideViewDelegate>

@end

@implementation ViewController
{
    CMAdGuideView *myview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    myview = [CMAdGuideView createAdGuideView];
    myview.delegate = self;
    [myview loadAdImageView:@"test"];
    [myview showAd];
    
    [self.navigationController.view addSubview:myview];
//    [myview loadAdImageView:@""];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [myview showAd];
}

- (void)tapAdImage{
    
}

@end
