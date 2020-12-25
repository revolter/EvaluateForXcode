//
//  XCSourceTextRange+Update.swift
//  SourceEditorExtension
//
//  Created by Iulian Onofrei on 25.12.2020.
//  Copyright © 2020 Iulian Onofrei. All rights reserved.
//

import XcodeKit

extension XCSourceTextRange {
	// MARK: - Internal

	func updateStart(byColumns columns: Int, withLines lines: [NSString]) {
		self.start = self.updateColumn(ofExtremity: self.start, byColumns: columns, withLines: lines)
	}

	func updateEnd(byColumns columns: Int, withLines lines: [NSString]) {
		self.end = self.updateColumn(ofExtremity: self.end, byColumns: columns, withLines: lines)
	}

	// MARK: - Private

	private func updateColumn(ofExtremity extremity: XCSourceTextPosition, byColumns columns: Int, withLines lines: [NSString]) -> XCSourceTextPosition {
		guard columns != 0 else {
			return extremity
		}

		var newExtremity = extremity
		var remainingColumns = columns

		let isDecreasing = remainingColumns < 0
		let isIncreasing = remainingColumns > 0

		if isDecreasing {
			let remainingLineLength = newExtremity.column
			let minColumns = min(abs(remainingColumns), remainingLineLength)

			newExtremity.column -= minColumns
			remainingColumns += minColumns

			let isAtLineStart = newExtremity.column == 0

			if isAtLineStart {
				let isFirstLine = newExtremity.line == 0

				if isFirstLine {
					return newExtremity
				}

				newExtremity.line -= 1
				newExtremity.column = newExtremity.lineLength(withLines: lines)
			}
		} else if isIncreasing {
			let isAtLineEnd = newExtremity.column == newExtremity.lineLength(withLines: lines)

			if isAtLineEnd {
				let isLastLine = newExtremity.line == lines.count - 1

				if isLastLine {
					return newExtremity
				}

				newExtremity.line += 1
				newExtremity.column = 0
			}

			let lineLength = newExtremity.lineLength(withLines: lines)
			let remainingLineLength = lineLength - newExtremity.column
			let minColumns = min(remainingColumns, remainingLineLength)

			newExtremity.column += minColumns
			remainingColumns -= minColumns
		}

		let isUpdateFinished = remainingColumns == 0

		if isUpdateFinished {
			return newExtremity
		}

		return self.updateColumn(ofExtremity: newExtremity, byColumns: remainingColumns, withLines: lines)
	}
}
