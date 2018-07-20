//
//  EffectBase.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "EffectBase.h"
#import "LocalizableTool.h"

@implementation EffectBase




+ (NSString*)defaultTitle
{
    return [LocalizableTool localizedString:@"CLEffectBase_DefaultTitle" withDefault:@"None"];
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark-

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame
//               toolInfo:(CLImageToolInfo*)info
{
    self = [super init];
    if(self){
//        self.toolInfo = info;
    }
    return self;
}

- (void)cleanup
{
    
}

- (BOOL)needsThumbnailPreview
{
    return YES;
}

- (UIImage*)applyEffect:(UIImage*)image
{
    return image;
}
@end
