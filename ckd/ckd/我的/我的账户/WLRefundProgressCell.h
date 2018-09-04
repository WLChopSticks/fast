//
//  WLRefundProgressCell.h
//  ckd
//
//  Created by 王磊 on 2018/9/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLRefundProgressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *progressState;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *progressLine;
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@property (nonatomic, assign) BOOL isTickSymbol;

@end
