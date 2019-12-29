//
//  IOLabel.swift
//  EvaluateForXcode
//
//  Created by Iulian Onofrei on 28/12/2019.
//  Copyright © 2019 Iulian Onofrei. All rights reserved.
//

import AppKit

class IOLabel: NSTextField {

	override var intrinsicContentSize: NSSize {
		guard let cell = self.cell, cell.wraps else {
			return super.intrinsicContentSize
		}

		var frame = self.frame

		frame.size.height = CGFloat.greatestFiniteMagnitude

		let height = cell.cellSize(forBounds: frame).height

		return NSSize(width: frame.width, height: height)
	}

	override func textDidChange(_ notification: Notification) {
		super.textDidChange(notification)

		self.invalidateIntrinsicContentSize()
	}
}
