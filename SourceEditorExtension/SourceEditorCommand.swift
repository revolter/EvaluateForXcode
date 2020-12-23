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

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
		let buffer = invocation.buffer

		for case let selection as XCSourceTextRange in buffer.selections.reversed() {
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
			} catch {
				completionHandler(error)

				return
			}
		}

		completionHandler(nil)
	}

}
