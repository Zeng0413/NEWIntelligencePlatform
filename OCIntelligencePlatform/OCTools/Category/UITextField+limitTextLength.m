//
//  UITextField+limitTextLength.m
//  QHPay
//
//  Created by Alan on 2017/12/13.
//  Copyright © 2017年 Luobao. All rights reserved.
//

#import "UITextField+limitTextLength.h"
#import <objc/runtime.h>

@implementation UITextField (limitTextLength)

static void *textMaxKey = &textMaxKey;

static void *pointMaxKey = &pointMaxKey;

- (NSInteger)textMax {
    return [objc_getAssociatedObject(self, &textMaxKey) integerValue];
}

- (void)setTextMax:(NSInteger)textMax {
    NSString * max = [NSString stringWithFormat:@"%ld",(long)textMax];
    objc_setAssociatedObject(self, &textMaxKey,max,OBJC_ASSOCIATION_COPY_NONATOMIC);
	
	[self addNotification];
}

- (void)addNotification {
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSString *toBeString = textField.text;
	
	if (self.textMax) {
		NSInteger kMaxLength = self.textMax;
		NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前
		
		if ([lang isEqualToString:@"zh-Hans"]) {   //中文输入
			UITextRange *selectedRange = [textField markedTextRange];
			//获取高亮文字
			UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
			//若无高亮选择
			if (!position) {
				if (toBeString.length > kMaxLength) {
					textField.text = [toBeString substringToIndex:kMaxLength];
				}
			}
		}else {//其他语言
			if (toBeString.length > kMaxLength) {
				textField.text = [toBeString substringToIndex:kMaxLength];
			}
		}
	}
	
	if (self.pointMax) {
		if (toBeString.length < 1) {
			return;
		}
		
		NSString * currentText = [toBeString safeSubstringFromIndex:toBeString.length - 1];
		if ([toBeString rangeOfString:@"."].length > 0) {
			if ([currentText isEqualToString:@"."]) {
				return ;
			}
			
			NSRange textRange = [toBeString rangeOfString:@"."];
			NSString * string = [toBeString safeSubstringFromIndex:textRange.location];
			
			//输入位数限制
			if (string.length - 1 > self.pointMax) {
				textField.text = [toBeString substringToIndex:toBeString.length - 1];
			}
		}
	}
}


/*****************/

- (NSInteger)pointMax {
	return [objc_getAssociatedObject(self, &pointMaxKey) integerValue];
}

- (void)setPointMax:(NSInteger)pointMax {
	NSString * max = [NSString stringWithFormat:@"%ld",(long)pointMax];
	objc_setAssociatedObject(self, &pointMaxKey,max,OBJC_ASSOCIATION_COPY_NONATOMIC);
	
	[self addNotification];
}

- (void)addPointMaxNotification {
	[self addTarget:self action:@selector(shouldChangeTextInRange:replacementText:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)shouldChangeTextInRange:(UITextRange *)range replacementText:(NSString *)text {
	
	if (kStringIsEmpty(text)) {
		return YES;
	}
	
	if ([self.text rangeOfString:@"."].length > 0) {
		if ([text isEqualToString:@"."]) {
			return NO;
		}
		
		NSRange textRange = [self.text rangeOfString:@"."];
		NSString * string = [self.text safeSubstringFromIndex:textRange.location];
		
		//输入位数限制
		if (string.length > self.pointMax) {
			return NO;
		}else {
			return YES;
		}
	}else {
		return YES;
	}
	return YES;
}



@end
