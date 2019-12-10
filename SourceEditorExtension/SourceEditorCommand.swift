//
//  SourceEditorCommand.swift
//  SourceEditorExtension
//
//  Created by Iulian Onofrei on 11/12/2019.
//  Copyright © 2019 Iulian Onofrei. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
		// Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.

		completionHandler(nil)
	}

}
