//
//  CellForToday.swift
//  iWeather
//
//  Created by Steven Kirke on 18.02.2024.
//

import UIKit
import SnapKit
import SVGKit

final class CellForToday: UICollectionViewCell {

	// MARK: - Public properties
	static let identifierID = "CellForToday.cell"
	lazy var imageIcon = createImage()
	lazy var labelTemperature = createUILabel()
	lazy var labelTime = createUILabel()

	// MARK: - Private properties
	private lazy var viewDie = createView()
	private var safeImage: String = ""

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

	func downloadImage(url: URL) {
		self.loadImageSVG(url: url)
	}
}

// - MARK: Add UIView in Controler
private extension CellForToday {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [viewDie, imageIcon, labelTemperature, labelTime]
		views.forEach(contentView.addSubview)
	}
}

// - MARK: Initialisation configuration
private extension CellForToday {
	/// Настройка UI элементов
	func setupConfiguration() {
		backgroundColor = UIColor.clear

		labelTemperature.font = FontsStyle.poppinsMedium(15).font

		labelTime.font = FontsStyle.poppinsBold(15).font
	}
}

// - MARK: Initialisation constraint elements.
private extension CellForToday {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		viewDie.snp.makeConstraints { die in
			die.top.equalToSuperview()
			die.left.right.equalToSuperview()
			die.height.equalTo(76)
		}

		imageIcon.snp.makeConstraints { image in
			image.top.equalToSuperview().inset(12)
			image.centerX.equalToSuperview()
			image.width.height.equalTo(30)
		}

		labelTemperature.snp.makeConstraints { textTemp in
			textTemp.bottom.equalTo(viewDie.snp.bottom).inset(11)
			textTemp.left.equalTo(viewDie.snp.left)
			textTemp.right.equalTo(viewDie.snp.right)
			textTemp.height.equalTo(20)
		}

		labelTime.snp.makeConstraints { textTime in
			textTime.top.equalTo(viewDie.snp.bottom).inset(-6)
			textTime.left.equalTo(viewDie.snp.left)
			textTime.right.equalTo(viewDie.snp.right)
			textTime.height.equalTo(20)
		}
	}
}

private extension CellForToday {
	func loadImageSVG(url: URL) {

		let writeURL = url.absoluteString
		if safeImage != writeURL {
			safeImage = writeURL
		}

		URLSession.shared.dataTask(with: url) { data, response, error in
			DispatchQueue.main.async {
				guard
					let currentData = data, error == nil,
					let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200
					else {
					return
				}
				let receivedImage: SVGKImage? = SVGKImage(data: currentData)

				let currentURL = self.safeImage
				if writeURL != currentURL {
					return
				}
				guard let convImage = receivedImage else { return }
				self.imageIcon.image = convImage.uiImage
			}
		}.resume()
	}
}

// - MARK: Fabric UI Element.
private extension CellForToday {
	func createUILabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 1
		label.textAlignment = .center
		label.textColor = UIColor.white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	func createImage() -> UIImageView {
		let image = UIImage(named: "ImageWeather/sunny")
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}

	func createView() -> UIView {
		let view = UIView()
		view.backgroundColor = UIColor(hex: "#622FB5")
		view.layer.cornerRadius = 16
		view.clipsToBounds = true

		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}
}
