//
//  HeaderView.swift
//  iWeather
//
//  Created by Steven Kirke on 19.02.2024.
//

import UIKit
import SnapKit
import SVGKit

final class HeaderView: UIView {

	// MARK: - Public properties

	// MARK: - Dependencies

	// MARK: - Private properties
	private lazy var headerView = createView()
	private lazy var imageBackground = createImage()
	
	private lazy var labelNameCity = createUILabel()
	private lazy var labelData = createUILabel()

	private lazy var labelTemperature = createUILabel()
	private lazy var labelCondition = createUILabel()

	private lazy var labelDetail = createUILabel()

	private lazy var imageIcon = createSystemImage()

	private lazy var imageIconWeather = createImage()

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

	func reloadData(model: MainHomeModel.ViewModel.WeatherLocation) {
		labelNameCity.text = model.name
		labelData.text = model.dateAndTemp
		labelTemperature.text = model.currentTemp
		labelCondition.text = model.condition
		if let iconURL = model.icon {
			self.loadImageSVG(url: iconURL)
		}
	}

	// MARK: - Private methods
}

// - MARK: Add UIView in Controler
private extension HeaderView {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			headerView,
			imageBackground,
			imageIconWeather,
			labelData,
			labelNameCity,
			labelTemperature,
			labelCondition,
			labelDetail,
			imageIcon
		]
		views.forEach(addSubview)
	}
}

// - MARK: Initialisation configuration
private extension HeaderView {
	/// Настройка UI элементов
	func setupConfiguration() {
		headerView.backgroundColor = UIColor.clear

		labelNameCity.font = UIFont(name: "Poppins-Bold", size: 28)

		labelData.font = UIFont(name: "Poppins-Bold", size: 13)

		labelTemperature.font = UIFont(name: "Poppins-Bold", size: 36)

		labelCondition.font = UIFont.systemFont(ofSize: 21, weight: .regular)
		labelCondition.font = UIFont(name: "Poppins-Bold", size: 21)

		labelDetail.text = "Swipe down for details"
		labelDetail.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		labelDetail.font = UIFont(name: "Poppins-Bold", size: 12)
		labelDetail.textColor = UIColor.white.withAlphaComponent(0.6)
	}
}

// - MARK: Initialisation constraint elements.
private extension HeaderView {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		headerView.snp.makeConstraints { header in
			header.top.equalToSuperview()
			header.left.right.equalToSuperview()
			header.height.equalTo(381)
		}

		imageBackground.snp.makeConstraints { image in
			image.top.equalTo(headerView.snp.top)
			image.bottom.equalTo(headerView.snp.bottom)
			image.left.equalTo(headerView.snp.left)
			image.right.equalTo(headerView.snp.right)
		}

		labelNameCity.snp.makeConstraints { nameCity in
			nameCity.centerY.equalTo(headerView.snp.centerY)
			nameCity.left.equalTo(headerView.snp.left).inset(25)
			nameCity.height.equalTo(42)
		}

		labelData.snp.makeConstraints { data in
			data.top.equalTo(labelNameCity.snp.bottom).inset(-7)
			data.left.equalTo(headerView.snp.left).inset(25)
			data.height.equalTo(19)
		}

		labelTemperature.snp.makeConstraints { temperature in
			temperature.centerY.equalTo(headerView.snp.centerY)
			temperature.right.equalTo(headerView.snp.right).inset(25)
			temperature.height.equalTo(42)
		}

		labelCondition.snp.makeConstraints { condition in
			condition.top.equalTo(labelNameCity.snp.bottom).inset(-7)
			condition.right.equalTo(headerView.snp.right).inset(25)
			condition.height.equalTo(19)
		}

		labelDetail.snp.makeConstraints { detail in
			detail.bottom.equalTo(headerView.snp.bottom).inset(30)
			detail.centerX.equalTo(headerView.snp.centerX)
			detail.height.equalTo(14)
		}

		imageIcon.snp.makeConstraints { detail in
			detail.bottom.equalTo(headerView.snp.bottom).inset(11)
			detail.centerX.equalTo(headerView.snp.centerX)
			detail.height.equalTo(20)
			detail.width.equalTo(10)
		}

		imageIconWeather.snp.makeConstraints { iconWeather in
			iconWeather.width.height.equalTo(60)
			iconWeather.top.equalTo(headerView.snp.top).inset(20)
			iconWeather.left.equalTo(headerView.snp.left).inset(20)
		}
	}
}

// - MARK: Fabric UI Element.
private extension HeaderView {
	func createImage() -> UIImageView {
		let image = UIImage(named: "ImageWeather/nightHill")
		let imageView = UIImageView(image: image)
		imageView.layer.cornerRadius = 30
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}

	func createII() -> UIImageView {
		let image = UIImage(named: "ImageWeather/Cloudy")
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 22
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}

	func createView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}

//	func createGradient() -> CAGradientLayer {
//		let gradient = CAGradientLayer()
//		let colours = [
//			UIColor(hex: "#1B0F36").cgColor,
//			UIColor(hex: "#2F1C78").cgColor,
//			UIColor(hex: "#321E82").cgColor
//		]
//		//gradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 381)
//		gradient.colors = colours
//
//		return gradient
//	}

	func createUILabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 1
		label.textAlignment = .center
		label.textColor = UIColor.white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	func createSystemImage() -> UIImageView {
		let image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
		let imageView = UIImageView(image: image)
		imageView.tintColor = UIColor.white
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}
}

private extension HeaderView {
	func loadImageSVG(url: URL) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			DispatchQueue.main.async {
				guard
					let currentData = data, error == nil,
					let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200
					else {
					return
				}
				let receivedImage: SVGKImage? = SVGKImage(data: currentData)
				guard let convImage = receivedImage else { return }
				self.imageIconWeather.image = convImage.uiImage
			}
		}.resume()
	}
}
