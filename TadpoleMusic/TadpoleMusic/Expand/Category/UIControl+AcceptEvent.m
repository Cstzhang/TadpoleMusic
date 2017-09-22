//
//  UIControl+AcceptEvent.m
//  HXyxb
//
//  Created by 恒信永利 on 2017/6/2.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "UIControl+AcceptEvent.h"

@implementation UIControl (AcceptEvent)

#pragma mark ——— 关联一个属性，用于记录点击时间，第二次点击的时候用于比较

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

- (NSTimeInterval)acceptEventInterval {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
/** 点击时间 */
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";
/** get方法 */
- (NSTimeInterval)acceptEventTime {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}
/** set方法 */
- (void)setAcceptEventTime:(NSTimeInterval)acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark ——— 替换点击方法
// 在load时执行hook
+ (void)load {
    /** 系统原来的方法 */
    Method before   = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    /** 自定义的方法 */
    Method after    = class_getInstanceMethod(self, @selector(cs_sendAction:to:forEvent:));
    /** 替换 */
    method_exchangeImplementations(before, after);
}

/** 自定义的点击方法 */
- (void)cs_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    /** 判断点击事件是否是在间隔事件内 当前时间-点击响应时间<间隔时间？ */
    if ([NSDate date].timeIntervalSince1970 - self.acceptEventTime < self.acceptEventInterval) {
        return;
    }
    /** 如果可以点击，则记录点击时间 */
    if (self.acceptEventInterval > 0) {
        self.acceptEventTime = [NSDate date].timeIntervalSince1970;
    }
    /** 响应点击 */
    [self cs_sendAction:action to:target forEvent:event];
}

/**
 *  load方法是在objc库中的一个load_images函数中调用的. 先把二进制映像文件中的头信息取出, 再解析和读出各个模块中的类定义信息, 把实现了load方法的类和Category记录下来, 最后统一执行调用. 主类中的load方法的调用时机要早于Category中的load方法.
 *  因此, 我们在Category中的load方法中, 执行runtime的method swizzling, 即可将UIButton的事件响应方法sendAction:to:forEvent:替换为我们自定义的方法cs_sendAction:to:forEvent:.
 */
@end
