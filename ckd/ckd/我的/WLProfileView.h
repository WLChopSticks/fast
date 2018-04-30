//
//  WLProfileView.h
//  ckd
//
//  Created by 王磊 on 2018/4/29.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLProfileView;
@protocol ProfileviewDelegate<NSObject>

//- (void)LoginView: (WLLoginView *)view checkboxBtnDidclicking: (UIButton *)sender;
- (void)ProfileView: (WLProfileView *)view backBtnDidClicking: (UIButton *)sender;
- (void)ProfileView: (WLProfileView *)view userImageBtnDidClicking: (UIButton *)sender;
- (void)ProfileView: (WLProfileView *)view itemTableView: (UITableView *)tableView didSelectItem: (NSDictionary *)item;

@end

@interface WLProfileView : UIView

@property (nonatomic, strong) NSArray *itemsArr;
@property (nonatomic, weak) id<ProfileviewDelegate> delegate;

@end
