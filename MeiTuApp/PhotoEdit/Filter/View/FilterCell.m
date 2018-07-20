//
//  FilterCell.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/18.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.layer.cornerRadius = 5;
    self.imageView.clipsToBounds = YES;
}

@end
