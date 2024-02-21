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
	private lazy var imageBackground = createImageView()
	private lazy var gradient = createGradient()

	private lazy var labelNameCity = createUILabel()
	private lazy var labelData = createUILabel()

	private lazy var labelTemperature = createUILabel()
	private lazy var labelCondition = createUILabel()

	private lazy var labelDetail = createUILabel()

	private lazy var imageIcon = createSystemImage()

	private var currentFrame: CGSize = .zero

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

	func reloadData(model: MainHomeModel.ViewModel.WeatherLocation) {
		imageBackground.image = checkTimeOfDay(timeOfDay: model.backgroundImage)
		labelNameCity.text = model.name
		labelData.text = model.dateAndTemp
		labelTemperature.text = model.currentTemp
		labelCondition.text = model.condition
	}

	// MARK: - Private methods
	private func checkTimeOfDay(timeOfDay: String) -> UIImage? {
		var named = ""
		switch timeOfDay {
		case "d":
			named = "ImageForHeader/DayForHeader"
		case "n":
			named = "ImageForHeader/nightForHeader"
		default:
			named = "Empty"
		}
		return UIImage(named: named)
	}
}

// - MARK: Add UIView in Controler
private extension HeaderView {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			headerView,
			imageBackground,
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

		imageBackground.layer.cornerRadius = 30
		imageBackground.clipsToBounds = true
		imageBackground.layer.insertSublayer(gradient, at: 0)

		labelNameCity.font = FontsStyle.poppinsBold(28).font

		labelData.font = FontsStyle.poppinsRegular(12.91).font

		labelTemperature.font = FontsStyle.poppinsBold(36).font

		labelCondition.numberOfLines = 1
		labelCondition.textAlignment = .right
		labelCondition.font = FontsStyle.poppinsRegular(21.33).font

		labelDetail.text = "Swipe down for details"
		labelDetail.font = FontsStyle.robotoRegular(12).font
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
			nameCity.height.equalTo(35)
		}

		labelData.snp.makeConstraints { data in
			data.top.equalTo(labelNameCity.snp.bottom).inset(-7)
			data.left.equalTo(headerView.snp.left).inset(25)
			data.height.equalTo(19)
		}

		labelTemperature.snp.makeConstraints { temperature in
			temperature.centerY.equalTo(headerView.snp.centerY)
			temperature.right.equalTo(headerView.snp.right).inset(25)
			temperature.height.equalTo(36)
		}

		labelCondition.snp.makeConstraints { condition in
			condition.top.equalTo(labelNameCity.snp.bottom).inset(-7)
			condition.right.equalTo(headerView.snp.right).inset(25)
			condition.width.equalTo(headerView.snp.width).dividedBy(2.5)
			condition.height.equalTo(35)
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
	}
}

// - MARK: Fabric UI Element.
private extension HeaderView {
	func createImageView() -> UIImageView {
		let image = UIImage(named: "ImageForHeader/nightForHeader")
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}

	func createView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}

	func createGradient() -> CAGradientLayer {
		let gradient = CAGradientLayer()
		let colours = [
			UIColor(hex: "#1B0F36").cgColor,
			UIColor(hex: "#2F1C78").cgColor,
			UIColor(hex: "#321E82").cgColor
		]
		gradient.colors = colours
		gradient.opacity = 0.5
		return gradient
	}

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
