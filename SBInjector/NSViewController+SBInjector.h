//
//  NSViewController+SBInjector.h
//  SBInjector
//
//  Created by Mark Lilback on 3/5/17.
//  Copyright © 2017 Mark Lilback. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class InjectorContext;

@interface NSViewController (SBInjector)
@property (copy, nullable) InjectorContext *injectionContext;
@end
