//
//  ViewController+SBInjector.m
//  SBInjector
//
//  Created by Mark Lilback on 3/5/17.
//  Copyright © 2017 Mark Lilback. All rights reserved.
//

//#import "ViewController+SBInjector.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define ViewControllerType UIViewController
#else
#import <Cocoa/Cocoa.h>
#define ViewControllerType NSViewController
#endif

#import <SBInjector/SBInjector-Swift.h>
#import <objc/runtime.h>

static UInt8 injectIdentKey = 0;

@interface ViewControllerType (SBInjectorProps)
@property (copy, nullable) InjectorContext *injectionContext;
@end

@implementation ViewControllerType (SBInjector)
+ (void) load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		SEL originalSel = @selector(viewDidLoad);
		SEL swizzledSel = @selector(sbjinject_viewDidLoad);
		
		Method origMethod = class_getInstanceMethod(class, originalSel);
		Method swizzledMethod = class_getInstanceMethod(class, swizzledSel);
		
		method_exchangeImplementations(origMethod, swizzledMethod);
	});
}

- (void) sbjinject_viewDidLoad
{
	//call original implementation
	[self sbjinject_viewDidLoad];
	if (self.storyboard == nil) return;
	[self.storyboard.injectionContext injectInto: self];
}

- (InjectorContext *) injectionContext
{
	return objc_getAssociatedObject(self, &injectIdentKey);
}

- (void) setInjectionContext:(InjectorContext *)context
{
	objc_setAssociatedObject(self, &injectIdentKey, context, OBJC_ASSOCIATION_COPY);
}
@end
