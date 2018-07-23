//
//  DrawTool.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawController.h"

@interface DrawTool : NSObject
@property (nonatomic, weak) DrawController *editor;


- (id)initWithImageEditor:(DrawController *)editor;
- (void)setup;
- (void)cleanup;
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;

@end
