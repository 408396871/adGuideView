//
//  adGuideView.m
//  adGuideViewtest
//
//  Created by 董江 on 16/1/13.
//  Copyright © 2016年 greenpoint. All rights reserved.
//

#import "CMAdGuideView.h"
//#import "UIImageView+AFNetworking.h"

//设备屏幕高度
#ifndef UIScreenHeight
#define UIScreenHeight   [UIScreen mainScreen].bounds.size.height
#endif

//设备屏幕宽度
#ifndef UIScreenWidth
#define UIScreenWidth    [UIScreen mainScreen].bounds.size.width
#endif

#define WEAKSELF typeof(self) __weak weakSelf = self;
//角度转弧度
#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

//动画持续时间
#define   AnimationDuration  0.3

@interface CMAdGuideView()

@property (strong, nonatomic) UIImageView *adShowBtn;
@property (nonatomic, strong) CALayer *mylayer;
@end

@implementation CMAdGuideView
{
    UIImageView *adImageView;
    UIImageView *adShowImg;
    UIButton *closeBt;
    UIView *maskView;
}
+(instancetype)createAdGuideView
{
    
    CMAdGuideView *view = [[CMAdGuideView alloc]initWithFrame:CGRectMake(0, 0,UIScreenWidth, UIScreenHeight)];
    
    
    return view;
}



- (void)tapAdImage {
    
    if ([self.delegate respondsToSelector:@selector(tapAdImage)]) {
        [self.delegate tapAdImage];
    }
}

-(void)removeAd
{
    [self removeAd:self.adShowBtn];
}


-(void)showAd{
    
    
    if (!adShowImg) {
        return;
        
    }
    if (!maskView){
        
        maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,UIScreenWidth, UIScreenHeight)];
        
        UIImage *imageClose=[UIImage imageNamed:@"common_close"];
        closeBt=[[UIButton alloc] initWithFrame:
                 CGRectMake(40, 30, imageClose.size.width+20,
                            imageClose.size.height+10)];
        
        
        
        [closeBt setImage:imageClose forState:UIControlStateNormal];
        [closeBt addTarget:self action:@selector(removeAd:)
          forControlEvents:UIControlEventTouchUpInside];
        
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.5;
        
        
        [self addSubview:maskView];
        [self addSubview:adShowImg];
        [self addSubview:closeBt];
        
        
    }
    self.hidden = NO;
    adShowImg.hidden = YES;
    //开始顺时针旋转closeBtn
    [self rotationWithBtn:closeBt flag:NO];
    
    CALayer *layer = [CALayer layer];
    UIImage *imageTemp=[UIImage imageNamed:@"common_close"];
    //    layer.position = CGPointMake(30+imageTemp.size.width*0.5, 20 + imageTemp.size.height*0.5);
    layer.position = CGPointMake(50+imageTemp.size.width*0.5, 45 + imageTemp.size.height*0.5);
    
    layer.anchorPoint = CGPointMake(0, 0);
    layer.bounds = CGRectMake(0, 0, 1, 0);
    //    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:layer];
    self.mylayer = layer;
    [self testScale];
    //    [CMControllerManager fonctionStatisWithViewController:self info:@"仿滴滴幕帘广告"];
}

- (void)testScale
{
    // 1.创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    // 2.设置动画对象
    // keyPath决定了执行怎样的动画, 调整哪个属性来执行动画
    anim.keyPath = @"bounds";
    //    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 40)];
    anim.duration = 0.3;
    
    /**让图层保持动画执行完毕后的状态**/
    // 动画执行完毕后不要删除动画
    anim.removedOnCompletion = NO;
    // 保持最新的状态
    anim.fillMode = kCAFillModeForwards;
    //代理监听开始或者停止
    anim.delegate = self;
    
    // 3.添加动画
    [self.mylayer addAnimation:anim forKey:@"ScaleLine"];
    
    //        [self.layer addSublayer:self.mylayer];
}
-(void)loadAdImageView:(NSString *)imageUrl{
    
    
    if (!adShowImg) {
        
        [self createadShowImg];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAdImage)];
        
        [adShowImg addGestureRecognizer:ges];
        
        
    }
    
    
    //    [adShowImg setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"test"]];
    
    [adShowImg setImage:[UIImage imageNamed:@"test"]];
    
}

- (void)createadShowImg
{
    // 幕帘广告图距离左右的距离
    CGFloat marginX = 40.0f;
    // 幕帘广告图的宽度
    CGFloat width = UIScreenWidth - 2*marginX;
    // 幕帘广告图的高度，0.74是后台提供的宽高比例
    CGFloat height = width / 0.74;
    
    
    if (adShowImg) {
        adShowImg.frame = CGRectMake(marginX, 94,width,height);
    }else{
        adShowImg = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, 94,width,height)];
        //        adShowImg.backgroundColor = [UIColor redColor];
    }
    
    
    //    NSLog(@"%@",NSStringFromCGRect(adShowImg.frame));
    adShowImg.userInteractionEnabled = YES;
    
}
-(void)removeAd:(UIButton *)button{
    //广告收缩
    
    //开始逆时针旋转closeBtn
    [self rotationWithBtn:button flag:YES];
    
    // 把线收回来
    [self shrinkLine];
    
    [UIView transitionWithView:adShowImg duration:0.4 options:0 animations:^{
        //        [self.mylayer removeFromSuperlayer];
        adShowImg.frame = CGRectMake(adShowImg.frame.origin.x, 64, adShowImg.frame.size.width, 0);
    } completion:^(BOOL finished) {
        
        //        [self removeFromSuperview];
        self.hidden = YES;
        
        [self createadShowImg];
        
    }];
    
    
}


- (void)shrinkLine
{
    // 1.创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    // 2.设置动画对象
    // keyPath决定了执行怎样的动画, 调整哪个属性来执行动画
    anim.keyPath = @"bounds";
    //    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 0)];
    anim.duration = AnimationDuration;
    
    /**让图层保持动画执行完毕后的状态**/
    // 动画执行完毕后不要删除动画
    anim.removedOnCompletion = NO;
    // 保持最新的状态
    anim.fillMode = kCAFillModeForwards;
    //代理监听开始或者停止
    anim.delegate = self;
    
    // 3.添加动画
    [self.mylayer addAnimation:anim forKey:@"shrinkLine"];
}


//旋转 closebtn ，flag为yes为逆时针，no为顺时针
- (void)rotationWithBtn:(UIButton *)button flag:(BOOL)flag
{
    
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    if (flag) {
        rotationAnimation.toValue = [NSNumber numberWithFloat:-M_PI];
    }
    
    rotationAnimation.duration = AnimationDuration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    [button.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
    //    // 1.创建动画对象
    //    CABasicAnimation *anim = [CABasicAnimation animation];
    //
    //    // 2.设置动画对象
    //    // keyPath决定了执行怎样的动画, 调整哪个属性来执行动画
    //    anim.keyPath = @"transform";
    //    //    anim.fromValue = [NSNumber numberWithFloat:0];
    //    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI,0, 0,1.0)];
    //    if (!flag) {//flag
    //        //总是按最短路径来选择，当顺时针和逆时针的路径相同时，使用逆时针,这里乘以181是让它顺时针,同事z轴改为-1
    //        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(181),0, 0,-1.0)];
    //    }
    //
    //    anim.duration = 0.3;
    //
    //    /**让图层保持动画执行完毕后的状态**/
    //    // 动画执行完毕后不要删除动画
    //    anim.removedOnCompletion = NO;
    //    // 保持最新的状态
    //    anim.fillMode = kCAFillModeForwards;
    //
    //
    //    // 3.添加动画
    //    [button.layer addAnimation:anim forKey:@"rotation"];
    
    //    [self.mylayer add];
}


- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animationDidStart");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animationDidStop");
    adShowImg.hidden = NO;
    
}
@end
