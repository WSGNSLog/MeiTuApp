//
//  FilterCell.m
//  MyCamera
//
//  Created by shiguang on 2018/6/15.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "FunctionOptionCell.h"

@implementation FunctionOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

@end
