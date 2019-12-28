//
//  Step.swift
//  EvaluateForXcode
//
//  Created by Iulian Onofrei on 28/12/2019.
//  Copyright © 2019 Iulian Onofrei. All rights reserved.
//

import AppKit
import Foundation

class Step {

	public var text: NSAttributedString {
		get {
			let fontManager = NSFontManager.shared

			let baseAttributes: [NSAttributedString.Key: Any] = [
				.foregroundColor: NSColor.white
			]

			let merge: (_: Any, _: Any) -> Any = { $1 }

			let thinAttributes: [NSAttributedString.Key: Any] = [
				.font: NSFont.systemFont(ofSize: 16, weight: .thin)
				].merging(baseAttributes, uniquingKeysWith: merge)

			let boldItalicAttributes: [NSAttributedString.Key: Any] = [
				.font: fontManager.font(withFamily: NSFont.systemFont(ofSize: 0).familyName!, traits: [.italicFontMask, .boldFontMask], weight: 0, size: 16)!
				].merging(baseAttributes, uniquingKeysWith: merge)

			let indexText = NSAttributedString(string: "\(self.index). ", attributes: thinAttributes)

			let instructionText = NSAttributedString(string: self.instruction, attributes: thinAttributes)

			let targetText = NSAttributedString(string: self.target, attributes: boldItalicAttributes)

			let text = NSMutableAttributedString()

			text.append(indexText)
			text.append(instructionText)
			text.append(NSAttributedString(string: " "))
			text.append(targetText)

			return text
		}
	}

	public var image: NSImage {
		get {
			return NSImage(named: self.imageName)!
		}
	}

	private let index: Int
	private let instruction: String
	private let target: String
	private let imageName: NSImage.Name

	init(_ index: Int, _ instruction: String, _ target: String, _ imageName: NSImage.Name) {
		self.index = index
		self.instruction = instruction
		self.target = target
		self.imageName = imageName
	}

}
