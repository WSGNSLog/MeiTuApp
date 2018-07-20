//
//  EffectBaseTool.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EffectController.h"
#import "EffectBase.h"


@interface EffectBaseTool : NSObject<EffectDelegate>

@property (nonatomic, strong) EffectBase *selectedEffect;
@property (nonatomic, weak) EffectController *editor;
//@property (nonatomic, weak) CLImageToolInfo *toolInfo;

- (id)initWithImageEditor:(EffectController *)editor;
//             withToolInfo:(CLImageToolInfo*)info;
- (void)setup;
- (void)cleanup;
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;

@end
