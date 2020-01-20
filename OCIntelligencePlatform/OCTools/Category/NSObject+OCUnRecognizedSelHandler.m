//
//  NSObject+OCUnRecognizedSelHandler.m
//  OCElocutionSys_iOS
//
//  Created by Alan on 2019/3/25.
//  Copyright © 2019 OCZHKJ. All rights reserved.
//

#import "NSObject+OCUnRecognizedSelHandler.h"
#import <objc/runtime.h>

//提示框--->UIAlertController
#define ALERT_VIEW(Title,Message,Controller) {UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:Title message:Message preferredStyle:UIAlertControllerStyleAlert];        [alertVc addAction:action];[Controller presentViewController:alertVc animated:YES completion:nil];}

#import "AppDelegate.h"
static NSString *_errorFunctionName;
void dynamicMethodIMP(id self,SEL _cmd){
#ifdef DEBUG
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *currentRootViewController = delegate.window.rootViewController;
    NSString *error = [NSString stringWithFormat:@"errorClass->:%@\n errorFuction->%@\n errorReason->UnRecognized Selector",NSStringFromClass([self class]),_errorFunctionName];
    ALERT_VIEW(@"程序异常",error,currentRootViewController);
#else
    
#endif
    
}
#pragma mark 方法调换
static inline void change_method(Class _originalClass ,SEL _originalSel,Class _newClass ,SEL _newSel){
    Method methodOriginal = class_getInstanceMethod(_originalClass, _originalSel);
    Method methodNew = class_getInstanceMethod(_newClass, _newSel);
    method_exchangeImplementations(methodOriginal, methodNew);
}

@implementation NSObject (UnRecognizedSelHandler)
+ (void)load{
    change_method([self class], @selector(methodSignatureForSelector:), [self class], @selector(OC_methodSignatureForSelector:));
    change_method([self class], @selector(forwardInvocation:), [self class], @selector(OC_forwardInvocation:));
}

- (NSMethodSignature *)OC_methodSignatureForSelector:(SEL)aSelector{
    if (![self respondsToSelector:aSelector]) {
        _errorFunctionName = NSStringFromSelector(aSelector);
        NSMethodSignature *methodSignature = [self OC_methodSignatureForSelector:aSelector];
        if (class_addMethod([self class], aSelector, (IMP)dynamicMethodIMP, "v@:")) {//方法参数的获取存在问题
            WGHLog(@"临时方法添加成功！");
        }
        if (!methodSignature) {
            methodSignature = [self OC_methodSignatureForSelector:aSelector];
        }
        
        return methodSignature;
        
    }else{
        return [self OC_methodSignatureForSelector:aSelector];
    }
}

- (void)OC_forwardInvocation:(NSInvocation *)anInvocation{
    SEL selector = [anInvocation selector];
    if ([self respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:self];
    }else{
        [self OC_forwardInvocation:anInvocation];
    }
}

- (IMP)safeImplementation:(SEL)aSelector {
    IMP imp = imp_implementationWithBlock(^() {
        NSLog(@"PROTECTOR: %@ Done", NSStringFromSelector(aSelector));
    });
    return imp;
}

- (BOOL)isExistSelector: (SEL)aSelector inClass:(Class)currentClass {
    BOOL isExist = NO;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(currentClass, &methodCount);

    for (int i = 0; i < methodCount; i++) {
        Method temp = methods[i];
        SEL sel = method_getName(temp);
        NSString *methodName = NSStringFromSelector(sel);
        if ([methodName isEqualToString:NSStringFromSelector(aSelector)]) {
            isExist = YES;
            break;
        }
    }
    return isExist;
}

- (id)oc_forwardingTargetForSelector:(SEL)aSelector {
    NSString *selectorStr = NSStringFromSelector(aSelector);

    if ([self isKindOfClass: [NSNull class]] || [self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSDictionary class]]) {

        NSLog(@"PROTECTOR: -[%@ %@]", [self class], selectorStr);
        NSLog(@"PROTECTOR: unrecognized selector \"%@\" sent to instance: %p", selectorStr, self);
        // 查看调用栈
        NSLog(@"PROTECTOR: call stack: %@", [NSThread callStackSymbols]);

        // 对保护器插入该方法的实现
        Class protectorCls = NSClassFromString(@"Protector");
        if (!protectorCls) {
            protectorCls = objc_allocateClassPair([NSObject class], "Protector", 0);
            objc_registerClassPair(protectorCls);
        }

        // 检查类中是否存在该方法，不存在则添加
        BOOL isExist = [self isExistSelector:aSelector inClass:[self class]];
        
        if (!isExist) {
            Method exchangeM = class_getInstanceMethod([protectorCls class], aSelector);
            BOOL isAdd = class_addMethod(protectorCls, aSelector, class_getMethodImplementation(protectorCls, aSelector),method_getTypeEncoding(exchangeM));
        }
        unsigned int methodCount = 0;
        Method *methods = class_copyMethodList(protectorCls, &methodCount);
        
        for (int i = 0; i < methodCount; i++) {
            Method temp = methods[i];
            SEL sel = method_getName(temp);
            NSString *methodName = NSStringFromSelector(sel);
            WGHLog(methodName);
        }
        
        Class Protector = [protectorCls class];
        id instance = [[Protector alloc] init];
        WGHLog(@"++++++");
        return instance;
    } else {
        if ([NSStringFromClass([self class]) isEqualToString:@"Protector"]) {
            WGHLog(@"------");
            unsigned int methodCount = 0;
            Method *methods = class_copyMethodList([self class], &methodCount);
            
            for (int i = 0; i < methodCount; i++) {
                Method temp = methods[i];
                SEL sel = method_getName(temp);
                NSString *methodName = NSStringFromSelector(sel);
                WGHLog(methodName);
            }
        }
        return self;
    }
}



@end
