//
//  ViewController.swift
//  EvaluateForXcode
//
//  Created by Iulian Onofrei on 11/12/2019.
//  Copyright © 2019 Iulian Onofrei. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	// MARK: - Outlets

	@IBOutlet var textFieldTitle: IOLabel!
	@IBOutlet var imageViewScreenshot: NSImageView!

	// MARK: - Globals

	private var steps: [Step] {
		get {
			return [
				Step(1, "Open", "System Preferences", "help_1-image-668x516"),
				Step(2, "Select", "Extensions", "help_2-image-668x508"),
				Step(3, "Select", "Xcode Source Editor", "help_3-image-668x508"),
				Step(4, "Enable", "Evaluate", "help_4-image-668x508"),
				Step(5, "Select", "a mathematical expression", "help_5-image-936x357"),
				Step(6, "Select", "Editor > Evaluate > Parse", "help_6-image-449x444"),
			]
		}
	}

	private var currentStepIndex = 0

	// MARK: - Super

	override func viewDidLoad() {
		super.viewDidLoad()

		self.updateViewsForCurrentStep()
	}

	// MARK: - Private

	private func incrementCurrentStep() {
		self.currentStepIndex += 1

		if self.currentStepIndex >= self.steps.count {
			self.currentStepIndex = 0
		}
	}

	private func updateViewsForCurrentStep() {
		let step = self.steps[self.currentStepIndex]

		self.textFieldTitle.attributedStringValue = step.text
		self.imageViewScreenshot.image = step.image

		self.view.layoutSubtreeIfNeeded()

		let width = step.image.size.width
		let height = self.view.bounds.height

		if let window = NSApp.windows.first {
			window.setContentSize(NSSize(width: width, height: height))
			window.center()
		}
	}

	// MARK: Actions

	@IBAction func onContinueClick(_ sender: NSButton) {
		self.incrementCurrentStep()
		self.updateViewsForCurrentStep()
	}

}
