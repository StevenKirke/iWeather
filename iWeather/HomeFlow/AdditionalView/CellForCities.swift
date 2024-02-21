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

	// MARK: - Private properties
	private lazy var gradient = createGradient()
	private lazy var labelTitle = createUILabel()
	private lazy var imageBackground = createImage()
	private var coordinateCity: MainHomeModel.ViewModel.Coordinate?

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

	override func layoutSubviews() {
		super.layoutSubviews()
		gradient.frame = bounds
	}

	func reloadData(
		title: String,
		coordinate: WCoordinate,
		image: UIImage?
	) {
		self.labelTitle.text = title
		self.imageBackground.image = image
		self.coordinateCity = coordinate
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
		labelTitle.textAlignment = .center
		labelTitle.font = FontsStyle.poppinsBold(20).font

		imageBackground.layer.insertSublayer(gradient, at: 0)
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
			text.left.right.equalToSuperview().inset(8)
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

	func createGradient() -> CAGradientLayer {
		let gradient = CAGradientLayer()
		let colours = [UIColor.black.cgColor, UIColor.white.cgColor, UIColor.black.cgColor]
		gradient.startPoint = CGPoint(x: 0.5, y: 0.1)
		gradient.endPoint = CGPoint(x: 0.5, y: 0.9)
		gradient.colors = colours
		gradient.opacity = 0.2
		return gradient
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
