//
//  XCSourceTextPosition+LineLength.swift
//  SourceEditorExtension
//
//  Created by Iulian Onofrei on 25.12.2020.
//  Copyright © 2020 Iulian Onofrei. All rights reserved.
//

import XcodeKit

extension XCSourceTextPosition {
	func lineLength(withLines lines: [NSString]) -> Int {
		let line = self.line

		guard line < lines.count else {
			return 0
		}

		return lines[line].length
	}
}
