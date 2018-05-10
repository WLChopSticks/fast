//
//  WLLoginView.h
//  ckd
//
//  Created by 王磊 on 2018/4/29.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLLoginView;
@protocol LoginviewDelegate<NSObject>

//- (void)LoginView: (WLLoginView *)view checkboxBtnDidclicking: (UIButton *)sender;
- (void)LoginView: (WLLoginView *)view aquireCheckNumBtnDidclicking: (UIButton *)sender;
- (void)LoginView: (WLLoginView *)view loginBtnDidclicking: (UIButton *)sender;
- (void)LoginView: (WLLoginView *)view userAgreementBtnDidclicking: (UIButton *)sender;
- (void)LoginView: (WLLoginView *)view configHostBtnDidclicking: (UIButton *)sender;

@end

@interface WLLoginView : UIView

@property (nonatomic, weak) UITextField *telephoneField;
@property (nonatomic, weak) UITextField *checkNumberField;
@property (nonatomic, weak) id<LoginviewDelegate> delegate;

@end
