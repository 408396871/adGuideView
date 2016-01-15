//
//  adGuideView.h
//  adGuideViewtest
//
//  Created by 董江 on 16/1/13.
//  Copyright © 2016年 greenpoint. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CMAdGuideViewDelegate <NSObject>

@optional
- (void)tapAdImage;
@end

@interface CMAdGuideView : UIView

@property(nonatomic, weak) id<CMAdGuideViewDelegate> delegate;

+(instancetype)createAdGuideView;
-(void)loadAdImageView:(NSString *)imageUrl;
-(void)showAd;
@end
