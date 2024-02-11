//
//  ViewController.swift
//  TempSparrow24_02_04
//
//  Created by Egor Ledkov on 04.02.2024.
//

import UIKit

class ViewController: UIViewController {
	
	private lazy var firstButton = AnimatedUIButton(title: "First Button")
	private lazy var secondButton = AnimatedUIButton(title: "Second Middle Button")
	private lazy var thirdButton = AnimatedUIButton(title: "Third", action: openModalView)
	
	private var buttons: [AnimatedUIButton] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
	}
	
	private func setup() {
		view.backgroundColor = .white
		
		buttons = [firstButton, secondButton, thirdButton]
		buttons.forEach { view.addSubview($0) }
		buttonsLayout()
	}
	
	private func openModalView() {
		let modalVC = ModalViewController()
		
		present(modalVC, animated: true)
	}
}

// MARK: - Layout

private extension ViewController {
	
	private func buttonsLayout() {
		var previous: UIButton?
		
		for button in buttons {
			button.centerXAnchor
				.constraint(equalTo: view.centerXAnchor)
				.isActive = true
			
			if let previous {
				button.topAnchor
					.constraint(equalTo: previous.bottomAnchor, constant: 8)
					.isActive = true
			} else {
				button.topAnchor
					.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
					.isActive = true
			}
			previous = button
		}
	}
}
