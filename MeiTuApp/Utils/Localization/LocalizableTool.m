//
//  LocalizableToll.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/18.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "LocalizableTool.h"
#import "BundleTool.h"
@implementation LocalizableTool
+ (NSString*)localizedString:(NSString*)key withDefault:defaultValue
{
    NSString *str = NSLocalizedString(key, @"");
    if(![str isEqualToString:key]){ return str; }
    
    NSBundle *bundle = [BundleTool getPhotoEditorBundle];
    return NSLocalizedStringWithDefaultValue(key, nil, bundle, defaultValue, @"");
}

@end
