//
//  EffectBase.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class EffectBase;
@protocol EffectDelegate <NSObject>
@required
- (void)effectParameterDidChange:(EffectBase*)effect;
@end

@interface EffectBase : NSObject
@property (nonatomic, weak) id<EffectDelegate> delegate;
//@property (nonatomic, weak) CLImageToolInfo *toolInfo;


- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame;
//               toolInfo:(CLImageToolInfo*)info;
- (void)cleanup;

- (BOOL)needsThumbnailPreview;
- (UIImage*)applyEffect:(UIImage*)image;

@end
