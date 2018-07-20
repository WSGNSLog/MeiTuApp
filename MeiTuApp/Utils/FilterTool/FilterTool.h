//
//  FilterTool.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FilterTool : NSObject

+ (UIImage*)applyFilter:(UIImage *)image withFilterName:(NSString*)filterName;

@end
