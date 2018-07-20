//
//  AjustmentTool.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AjustController.h"
@interface AjustmentTool : NSObject

@property (nonatomic, weak) AjustController *editor;


- (id)initWithImageEditor:(AjustController *)editor;
- (void)setup;
- (void)cleanup;
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;
@end
