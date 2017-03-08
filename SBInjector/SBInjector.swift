//
//  SBInjector.swift
//
//  Created by Mark Lilback on 3/5/17.
//  Copyright © 2017 Mark Lilback. All rights reserved.
//

#if os(OSX)
	import Cocoa
	public typealias ViewControllerType = NSViewController
#elseif os(iOS)
	import UIKit
	public typealias ViewControllerType = UIViewController
#endif

protocol Injector {
	func inject(object: ViewControllerType)
}

public struct InjectorWrapper<T: ViewControllerType>: Injector {
	let block: (T) -> Void
	
	func inject(object: ViewControllerType) {
		if let val = object as? T {
			block(val)
		}
	}
}

/// object that contains blocks to run on each object of T, including subclasses
@objc public class InjectorContext: NSObject {
	private var injectors = [Injector]()
	private var alreadyInjected = Set<String>()
	
	/// registers a block to be called when an object of a specific type is loaded
	///
	/// - Parameters:
	///   - objType: The type of object(s) of interest
	///   - block: block to execute for each instance of objType that is loaded
	public func register<T: ViewControllerType>(_ objType: T.Type, block: @escaping (T) -> Void)
	{
		let wrapper = InjectorWrapper<T>(block: block)
		injectors.append(wrapper)
	}
	
	public func inject(into: ViewControllerType) {
		injectors.forEach { $0.inject(object: into) }
	}
}

var storyboardIdent: UInt8 = 0

public extension NSStoryboard {
	var injectionContext: InjectorContext? {
		get { return objc_getAssociatedObject(self, &storyboardIdent) as? InjectorContext }
		set { objc_setAssociatedObject(self, &storyboardIdent, newValue, .OBJC_ASSOCIATION_RETAIN) }
	}
}
