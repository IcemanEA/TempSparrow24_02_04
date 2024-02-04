//
//  AnimatedButton.swift
//  TempSparrow24_02_04
//
//  Created by Egor Ledkov on 04.02.2024.
//

import UIKit

final class AnimatedButton: UIButton {
	private let title: String
	private let action: (() -> Void)?
	private let iconName: String
	
	private var isAnimating = false
	
	init(title: String, iconName: String = "arrow.right.circle.fill", action: (() -> Void)? = nil) {
		self.title = title
		self.action = action
		self.iconName = iconName
		
		super.init(frame: .zero)
		
		self.configuration = createDefaultConfig()
		self.setupHandler()
		self.setupAction()
		
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupAction() {
		addAction(UIAction { _ in
			self.animateButton(self)
		}, for: .touchDown)
		
		addAction(
			UIAction { _ in
				self.animateButton(self)
				(self.action ?? {})()
			}, for: .touchUpInside
		)
	}
	
	private func animateButton(_ button: UIButton) {
		if isAnimating {
			UIView.animate(withDuration: 0.1, animations: {
				button.transform = .identity
			}) { _ in
				self.isAnimating = false
			}
		} else {
			isAnimating = true
			UIView.animate(withDuration: 0.1, animations: {
				button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
			})
		}
	}
	
	private func createDefaultConfig() -> UIButton.Configuration {
		var config = UIButton.Configuration.filled()
		
		config.title = title
		
		config.contentInsets = NSDirectionalEdgeInsets(
			top: 10,
			leading: 14,
			bottom: 10,
			trailing: 14
		)
		
		var imageConfig = UIImage.SymbolConfiguration(paletteColors: [.white])
		imageConfig = imageConfig.applying(UIImage.SymbolConfiguration(scale: .default))
		config.image = UIImage(systemName: iconName, withConfiguration: imageConfig)
		config.imagePadding = 8
		config.imagePlacement = .trailing
		
		config.background.backgroundColor = .tintColor
		config.baseForegroundColor = .white
		
		return config
	}
	
	private func setupHandler() {
		configurationUpdateHandler = { [unowned self] button in
			var config = button.configuration
			
			switch button.state {
			case .highlighted:
				config = createHighlightedConfig(for: button)
			case .disabled:
				config = createDisableConfig(for: button)
			default:
				config = createDefaultConfig()
			}
			button.configuration = config
		}
	}
	
	private func createHighlightedConfig(for button: UIButton) -> UIButton.Configuration? {
		var config = button.configuration
		
		let foregroundColor: UIColor = .white
		config?.baseForegroundColor = foregroundColor
		
		var container = AttributeContainer()
		container.foregroundColor = button.isEnabled ? .white : .systemGray3
		
		let title = config?.title ?? ""
		config?.attributedTitle = AttributedString(title, attributes: container)
		
		return config
	}
	
	private func createDisableConfig(for button: UIButton) -> UIButton.Configuration? {
		var config = button.configuration
		
		let backgroundColor: UIColor = .systemGray2
		let foregroundColor: UIColor = .systemGray3
		
		config?.background.backgroundColor = backgroundColor
		config?.baseForegroundColor = foregroundColor
		
		var container = AttributeContainer()
		container.foregroundColor = button.isEnabled ? .white : .systemGray3
		
		let title = config?.title ?? ""
		config?.attributedTitle = AttributedString(title, attributes: container)
		
		var imageConfig = UIImage.SymbolConfiguration(paletteColors: [foregroundColor])
		imageConfig = imageConfig.applying(UIImage.SymbolConfiguration(scale: .default))
		config?.image = UIImage(systemName: iconName, withConfiguration: imageConfig)
		
		return config
	}
}
