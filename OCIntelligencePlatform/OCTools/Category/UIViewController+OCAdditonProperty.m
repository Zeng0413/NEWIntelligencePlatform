//
//  UIViewController+OCAdditonProperty.m
//  OCPhoenix
//
//  Created by Alan on 2019/5/14.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "UIViewController+OCAdditonProperty.h"

@implementation UIViewController (OCAdditonProperty)

static void *paramsKey = &paramsKey;

- (NSDictionary *)params {
    return objc_getAssociatedObject(self, &paramsKey);
}

- (void)setParams:(NSDictionary *)params {
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:params];
    objc_setAssociatedObject(self, &paramsKey,dic,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
