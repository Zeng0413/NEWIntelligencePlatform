//
//  NSArray+preventCrash.m
//  OCElocutionSys_iOS
//
//  Created by Alan on 2019/2/12.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "NSArray+preventCrash.h"
#import <objc/runtime.h>

@implementation NSArray (preventCrash)

/**
 *  对系统方法进行替换
 *
 *  @param systemSelector 被替换的方法
 *  @param swizzledSelector 实际使用的方法
 *  @param error            替换过程中出现的错误消息
 *
 *  @return 是否替换成功
 */
+ (BOOL)systemSelector:(SEL)systemSelector customSelector:(SEL)swizzledSelector error:(NSError *)error{
    Method systemMethod = class_getInstanceMethod(self, systemSelector);
    if (!systemMethod) {
        return NO;
    }
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (!swizzledMethod) {
        return NO;
    }
    if (class_addMethod([self class], systemSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod([self class], swizzledSelector, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }
    else{
        method_exchangeImplementations(systemMethod, swizzledMethod);
    }
    return YES;
}

/**
 NSArray 是一个类簇
 */
+(void)load{
    [super load];
    // 越界：初始化的空数组
    [objc_getClass("__NSArray0") systemSelector:@selector(objectAtIndex:)
                                 customSelector:@selector(emptyObjectIndex:)
                                          error:nil];
    // 越界：初始化的非空不可变数组
    [objc_getClass("__NSSingleObjectArrayI") systemSelector:@selector(objectAtIndex:)
                                             customSelector:@selector(singleObjectIndex:)
                                                      error:nil];
    // 越界：初始化的非空不可变数组
    [objc_getClass("__NSArrayI") systemSelector:@selector(objectAtIndex:)
                                 customSelector:@selector(safe_arrObjectIndex:)
                                          error:nil];
    // 越界：初始化的可变数组
    [objc_getClass("__NSArrayM") systemSelector:@selector(objectAtIndex:)
                                 customSelector:@selector(safeObjectIndex:)
                                          error:nil];
    // 越界：未初始化的可变数组和未初始化不可变数组
    [objc_getClass("__NSPlaceholderArray") systemSelector:@selector(objectAtIndex:)
                                           customSelector:@selector(uninitIIndex:)
                                                    error:nil];
    // 越界：可变数组
    [objc_getClass("__NSArrayM") systemSelector:@selector(objectAtIndexedSubscript:)
                                 customSelector:@selector(mutableArray_safe_objectAtIndexedSubscript:)
                                          error:nil];
    // 越界vs插入：可变数插入nil，或者插入的位置越界
    [objc_getClass("__NSArrayM") systemSelector:@selector(insertObject:atIndex:)
                                 customSelector:@selector(safeInsertObject:atIndex:)
                                          error:nil];
    // 插入：可变数插入nil
    [objc_getClass("__NSArrayM") systemSelector:@selector(addObject:)
                                 customSelector:@selector(safeAddObject:)
                                          error:nil];
}
- (id)safe_arrObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        WGHLog(@"崩溃啦！！！！\nthis is crash, [__NSArrayI] check index (objectAtIndex:)")
        NSLog(@"this is crash, [__NSArrayI] check index (objectAtIndex:)") ;
        return nil;
    }
    return [self safe_arrObjectIndex:index];
}
- (id)mutableArray_safe_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
        WGHLog(@"崩溃啦！！！！\nthis is crash, [__NSArrayM] check index (objectAtIndexedSubscript:)");
        NSLog(@"this is crash, [__NSArrayM] check index (objectAtIndexedSubscript:)") ;
        return nil;
    }
    return [self mutableArray_safe_objectAtIndexedSubscript:index];
}
- (id)singleObjectIndex:(NSUInteger)idx{
    if (idx >= self.count) {
        WGHLog(@"崩溃啦！！！！\nthis is crash, [__NSSingleObjectArrayI] check index (objectAtIndex:)");
        NSLog(@"this is crash, [__NSSingleObjectArrayI] check index (objectAtIndex:)") ;
        return nil;
    }
    return [self singleObjectIndex:idx];
}
- (id)uninitIIndex:(NSUInteger)idx{
    if ([self isKindOfClass:objc_getClass("__NSPlaceholderArray")]) {
        WGHLog(@"崩溃啦！！！！\nthis is crash, [__NSPlaceholderArray] check index (objectAtIndex:)");
        NSLog(@"this is crash, [__NSPlaceholderArray] check index (objectAtIndex:)") ;
        return nil;
    }
    return [self uninitIIndex:idx];
}
- (id)safeObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        WGHLog(@"崩溃啦！！！！\nthis is crash, [__NSArrayM] check index (objectAtIndex:)");
        NSLog(@"this is crash, [__NSArrayM] check index (objectAtIndex:)") ;
        return nil;
    }
    return [self safeObjectIndex:index];
}
- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index{
    if (index > self.count) {
        WGHLog(@"崩溃啦！！！！\nthis is crash, [__NSArrayM] check index (insertObject:atIndex:)");
        NSLog(@"this is crash, [__NSArrayM] check index (insertObject:atIndex:)") ;
        return ;
    }
    if (object == nil) {
        WGHLog(@"崩溃啦！！！！\nthis is crash, [__NSArrayM] check object == nil (insertObject:atIndex:)");
        NSLog(@"this is crash, [__NSArrayM] check object == nil (insertObject:atIndex:)") ;
        return ;
    }
    [self safeInsertObject:object atIndex:index];
}
- (void)safeAddObject:(id)object {
    if (object == nil) {
        WGHLog(@"崩溃啦！！！！\nthis is crash, [__NSArrayM] check index (addObject:)");
        NSLog(@"this is crash, [__NSArrayM] check index (addObject:)") ;
        return ;
    }
    [self safeAddObject:object];
}
- (id)emptyObjectIndex:(NSInteger)index {
    WGHLog(@"崩溃啦！！！！\nthis is crash, [__NSArray0] check index (objectAtIndex:)");
    NSLog(@"this is crash, [__NSArray0] check index (objectAtIndex:)") ;
    return nil;
}

@end
