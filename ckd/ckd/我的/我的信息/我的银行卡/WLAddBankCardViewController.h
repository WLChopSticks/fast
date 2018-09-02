//
//  WLAddBankCardViewController.h
//  ckd
//
//  Created by 王磊 on 2018/9/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLBaseUIViewController.h"
#import "WLMyExistingBankCardModel.h"

@interface WLAddBankCardViewController : WLBaseUIViewController

@property (nonatomic, strong) WLBankCardModel *bankCardInfo;
@property (nonatomic, strong) NSString *defaultCardPara;

@end
