//
//  BaseImgAndLabelCell.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "BaseImgAndLabelCell.h"
@interface BaseImgAndLabelCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint;

@end
@implementation BaseImgAndLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    if (self.hideLabel) {
        self.labelHeightConstraint = 0;
    }
}

@end
