//
//  CellForCities.swift
//  iWeather
//
//  Created by Steven Kirke on 17.02.2024.
//

import UIKit
import SnapKit

final class CellForCities: UICollectionViewCell {

	// MARK: - Public properties
	static let identifierID = "CellForCities.cell"
	lazy var labelTitle = createUILabel()
	lazy var imageBackground = createImage()

	// MARK: - Initializator
	override init(frame: CGRect) {
		super.init(frame: frame)
		addUIView()
		setupConfiguration()
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// - MARK: Add UIView in Controler
private extension CellForCities {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [imageBackground, labelTitle]
		views.forEach(contentView.addSubview)
	}
}

// - MARK: Initialisation configuration
private extension CellForCities {
	/// Настройка UI элементов
	func setupConfiguration() {
		backgroundColor = UIColor.clear
		labelTitle.textColor = UIColor.white
		labelTitle.font = UIFont.systemFont(ofSize: 20, weight: .regular)
		labelTitle.font = UIFont(name: "Poppins-Bold", size: 20)
	}
}

// - MARK: Initialisation constraint elements.
private extension CellForCities {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		imageBackground.snp.makeConstraints { image in
			image.top.bottom.equalToSuperview()
			image.left.right.equalToSuperview()
		}

		labelTitle.snp.makeConstraints { text in
			text.top.equalToSuperview().inset(24)
			text.left.right.equalToSuperview()
		}
	}
}

// - MARK: Fabric UI Element.
private extension CellForCities {
	func createUILabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 2
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	func createImage() -> UIImageView {
		let image = UIImage(named: "ImageWeather/Cloudy")
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 22
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}
}
