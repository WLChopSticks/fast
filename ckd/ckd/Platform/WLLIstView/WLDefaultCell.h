//
//  WLDefaultCell.h
//  ckd
//
//  Created by wanglei on 2018/7/16.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLDefaultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeadingConstraint;


@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIImageView *subImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleTrailingConstraint;

@end
