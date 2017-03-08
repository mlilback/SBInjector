//
//  SBInjectorTests.swift
//  SBInjectorTests
//
//  Created by Mark Lilback on 3/5/17.
//  Copyright © 2017 Mark Lilback. All rights reserved.
//

import XCTest
@testable import SBInjector

class SBInjectorTests: XCTestCase {
	var storyboard: NSStoryboard!
	
	override func setUp() {
		super.setUp()
		storyboard = NSStoryboard(name: "Injector", bundle: Bundle(for: type(of: self)))
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testSimpleInject()
	{
		let context = InjectorContext()
		context.register(ControllerWithString.self) { (controller) in
			controller.name = "foo"
		}
		storyboard.injectionContext = context
		guard let vc = storyboard.instantiateController(withIdentifier: "simpleTest") as? ControllerWithString else { XCTFail(); return }
		_ = vc.view
		XCTAssert(vc.name == "foo")
	}

	func testTabs()
	{
		let context = InjectorContext()
		context.register(BasicController.self) { (controller) in
			controller.name = "basic"
		}
		context.register(Controller1.self) { controller in
			controller.name1 = "name1"
		}
		context.register(Controller2.self) { controller in
			controller.name2 = "name2"
		}
		storyboard.injectionContext = context
		guard let tabC = storyboard.instantiateController(withIdentifier: "tabTest") as? NSTabViewController else { XCTFail("failed to find tab view controller"); return }
		_ = tabC.view
		guard let c1 = tabC.tabViewItems[0].viewController as? Controller1 else { XCTFail() ; return}
		guard let c2 = tabC.tabViewItems[1].viewController as? Controller2 else { XCTFail(); return }
		_ = c1.view
		_ = c2.view
		XCTAssert(c1.name1 == "name1")
		XCTAssert(c2.name2 == "name2")
		XCTAssert(c1.name == "basic")
		XCTAssert(c2.name == "basic")
	}
}
