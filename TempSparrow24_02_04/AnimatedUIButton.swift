//
//  AnimatedButton.swift
//  TempSparrow24_02_04
//
//  Created by Egor Ledkov on 04.02.2024.
//

import UIKit

/// Анимированная кнопка с кастомным дизайном дополнительных состояний
final class AnimatedUIButton: UIButton {
	private let title: String
	private let action: (() -> Void)?
	private let iconName: String
	
	override var isHighlighted: Bool {
		didSet {
			UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
				self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
			}
		}
	}
	
	// MARK: - Initialize
	
	/// Создать анимированную кнопку с кастомным дизайном дополнительных состояний
	/// - Parameters:
	///   - title: Заголовок кнопки
	///   - iconName: Иконка на кнопке
	///   - action: Действие, вызываемое при нажатии
	init(title: String, iconName: String = "arrow.right.circle.fill", action: (() -> Void)? = nil) {
		self.title = title
		self.action = action
		self.iconName = iconName
		
		super.init(frame: .zero)
		
		self.configuration = createDefaultConfig()
		self.setupHandler()
		
		if let action {
			addAction(UIAction { _ in action() }, for: .touchUpInside)
		}
		
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Override methods
	
	override func tintColorDidChange() {
		super.tintColorDidChange()
		
		switch tintAdjustmentMode {
		case .dimmed:
			configuration = createDisableConfig(for: self)
		default:
			configuration = createDefaultConfig()
		}
	}
	
	// MARK: - Private methods
	
	private func setupHandler() {
		configurationUpdateHandler = { [unowned self] button in
			switch button.state {
			case .highlighted:
				button.configuration = createHighlightedConfig(for: button)
			case .disabled:
				button.configuration = createDisableConfig(for: button)
			default:
				button.configuration = createDefaultConfig()
			}
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
		container.foregroundColor = foregroundColor
		
		let title = config?.title ?? ""
		config?.attributedTitle = AttributedString(title, attributes: container)
		
		var imageConfig = UIImage.SymbolConfiguration(paletteColors: [foregroundColor])
		imageConfig = imageConfig.applying(UIImage.SymbolConfiguration(scale: .default))
		config?.image = UIImage(systemName: iconName, withConfiguration: imageConfig)
		
		return config
	}
}
