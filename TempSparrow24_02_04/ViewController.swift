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
	
	private lazy var firstButton = AnimatedButton(title: "First Button")
	private lazy var secondButton = AnimatedButton(title: "Second Medium Button")
	private lazy var thirdButton = AnimatedButton(title: "Third", action: openModalView)
	
	private var buttons: [AnimatedButton] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
	}
	
	private func setup() {
		view.backgroundColor = .white
		
		buttons = [firstButton, secondButton, thirdButton]
		buttons.forEach { view.addSubview($0) }
		
		layout()
	}
	
	private func openModalView() {
		buttons.forEach { $0.isEnabled = false }
		
		let modalVC = ModalViewController()
		let nav = UINavigationController(rootViewController: modalVC)
		
		nav.presentationController?.delegate = self
		if let sheet = nav.sheetPresentationController {
			sheet.detents = [.large()]
			sheet.largestUndimmedDetentIdentifier = .large
		}
		
		present(nav, animated: true)
	}
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension ViewController: UIAdaptivePresentationControllerDelegate {
	func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
		buttons.forEach { $0.isEnabled = true }
	}
}

// MARK: - Layout

private extension ViewController {
	
	private func layout() {
		NSLayoutConstraint.activate(
			[
				firstButton.centerXAnchor.constraint(equalTo:  view.centerXAnchor),
				firstButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				secondButton.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor),
				secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 8),
				thirdButton.centerXAnchor.constraint(equalTo: secondButton.centerXAnchor),
				thirdButton.topAnchor.constraint(equalTo: secondButton.bottomAnchor, constant: 8),
			]
		)
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
