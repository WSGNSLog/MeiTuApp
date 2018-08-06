//
//  DrawTool.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawVC.h"

@interface DrawTool : NSObject
@property (nonatomic, weak) DrawVC *editor;


- (id)initWithImageEditor:(DrawVC *)editor;
- (void)setup;
- (void)cleanup;
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;

@end
