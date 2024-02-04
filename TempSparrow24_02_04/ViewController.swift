//
//  ViewController.swift
//  TempSparrow24_02_04
//
//  Created by Egor Ledkov on 04.02.2024.
//

#if DEBUG
import SwiftUI
#endif


import UIKit

class ViewController: UIViewController {
	
	private lazy var firstButton = makeButton(with: "First Button")
	private lazy var secondButton = makeButton(with: "Second Medium Button")
	private lazy var thirdButton = makeButton(with: "Third")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
	}
	
	private func setup() {
		view.backgroundColor = .white
		
		view.addSubview(firstButton)
		view.addSubview(secondButton)
		view.addSubview(thirdButton)
		
		layout()
	}
}

// MARK: - Layout

private extension ViewController {
	
	private func layout() {
		NSLayoutConstraint.activate(
			[
				firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				firstButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
				secondButton.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor),
				secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 8),
				thirdButton.centerXAnchor.constraint(equalTo: secondButton.centerXAnchor),
				thirdButton.topAnchor.constraint(equalTo: secondButton.bottomAnchor, constant: 8),
			]
		)
	}
}

// MARK: - Constructors

private extension ViewController {
	
	func makeButton(with title: String) -> UIButton {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setTitle(title, for: .normal)
		
		return button
	}
}

// MARK: - PreviewProvider

#if DEBUG
struct MainViewControllerProvider: PreviewProvider {
	static var previews: some View {
		ViewController()
			.preview()
	}
}

extension UIViewController {
	struct Preview: UIViewControllerRepresentable {
		let viewController: UIViewController
		
		func makeUIViewController(context: Context) -> some UIViewController {
			viewController
		}
		
		func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
	}
	
	func preview( ) -> some View {
		Preview(viewController: self)
	}
}
#endif
