//
//  SourceEditorCommand.swift
//  SourceEditorExtension
//
//  Created by Iulian Onofrei on 11/12/2019.
//  Copyright © 2019 Iulian Onofrei. All rights reserved.
//

import Foundation
import XcodeKit

import MathParser

enum EvaluateError: Error {
	case invalidSelections
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
		let buffer = invocation.buffer

		guard let selections = buffer.selections.reversed() as? [XCSourceTextRange] else {
			completionHandler(EvaluateError.invalidSelections)

			return
		}

		for (index, selection) in selections.enumerated() {
			let startLine = selection.start.line
			let startColumn = selection.start.column

			let endLine = selection.end.line
			let endColumn = selection.end.column

			var text = ""

			for index in startLine...endLine {
				let line = buffer.lines[index] as! NSString

				if startLine == endLine {
					// The selection is one line.

					text += line.substring(with: NSMakeRange(startColumn, endColumn - startColumn))
				} else if index == startLine {
					// The first line of the selection

					text += line.substring(from: startColumn)
				} else if index == endLine {
					// The last line of the selection

					text += line.substring(to: endColumn)
				} else {
					// A full line in the selection

					text += line as String
				}
			}

			if text.isEmpty {
				continue
			}

			do {
				let resultValue = try text.evaluate()
				let isInteger = resultValue.truncatingRemainder(dividingBy: 1) == 0
				let result = isInteger ? String(format: "%.0f", resultValue) : String(resultValue)
				let deltaWidth = result.count - text.count

				let isResultBigger = deltaWidth > 0
				let isResultSmaller = deltaWidth < 0

				let updateSelections: () -> Void = {
					guard let lines = buffer.lines as? [NSString] else {
						return
					}

					let selectionEndLine = selection.end.line
					let selectionEndColumn = selection.end.column
					let isSelectionOnMultipleLines = selection.start.line != selectionEndLine

					selection.updateEnd(byColumns: deltaWidth, withLines: lines)

					let lastLineDeltaWidth = isSelectionOnMultipleLines ? -selectionEndColumn : deltaWidth

					for previousIndex in 0..<index {
						let previousSelection = selections[previousIndex]

						if previousSelection.start.line <= selectionEndLine {
							previousSelection.updateStart(byColumns: lastLineDeltaWidth, withLines: lines)
						}

						if previousSelection.end.line <= selectionEndLine {
							previousSelection.updateEnd(byColumns: lastLineDeltaWidth, withLines: lines)
						}
					}
				}

				if isResultSmaller {
					updateSelections()
				}

				for index in stride(from: endLine, to: startLine - 1, by: -1) {
					let line = buffer.lines[index] as! NSString
					var newLine: String? = nil

					if startLine == endLine {
						// The selection is one line.

						newLine =
							line.substring(to: startColumn) +
							result +
							line.substring(with: NSMakeRange(endColumn, line.length - endColumn))
					} else if index == startLine {
						// The first line of the selection

						newLine =
							line.substring(to: startColumn) +
							result
					} else if index == endLine {
						// The last line of the selection

						if endColumn == line.length - 1 {
							// The entire line was selected, so we remove it
							// completely.
						} else {
							newLine = line.substring(from: endColumn)
						}
					}

					if let newLine = newLine {
						// Replace the line.

						buffer.lines.replaceObject(at: index, with: newLine)
					} else {
						// Remove the line.

						buffer.lines.removeObject(at: index)
					}
				}

				if isResultBigger {
					updateSelections()
				}
			} catch {
				completionHandler(error)

				return
			}
		}

		completionHandler(nil)
	}

}
