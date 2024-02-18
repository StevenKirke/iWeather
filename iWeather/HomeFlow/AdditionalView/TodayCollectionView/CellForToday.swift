//
//  CellForToday.swift
//  iWeather
//
//  Created by Steven Kirke on 18.02.2024.
//

import UIKit
import SnapKit
import WebKit

final class CellForToday: UICollectionViewCell {

	// MARK: - Public properties
	static let identifierID = "CellForToday.cell"
	lazy var labelTemperature = createUILabel()
	lazy var labelTime = createUILabel()

	// MARK: - Private properties
	private lazy var viewDie = createView()
	private var safeImage: String = ""
	private lazy var webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

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

	func downloadImage(imageURL: URL) {
		self.loadImage(url: imageURL)
	}
}

// - MARK: Add UIView in Controler
private extension CellForToday {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [viewDie, labelTemperature, labelTime, webView]
		views.forEach(contentView.addSubview)
	}
}

// - MARK: Initialisation configuration
private extension CellForToday {
	/// Настройка UI элементов
	func setupConfiguration() {
		backgroundColor = UIColor.clear

		labelTemperature.text = "24\u{00B0}C"

		labelTime.text = "1:00PM"
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

		webView.snp.makeConstraints { image in
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

// - MARK: Fabric UI Element.
private extension CellForToday {
	func createUILabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 1
		label.textAlignment = .center
		label.textColor = UIColor.white
		label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		label.font = UIFont(name: "Poppins-Bold", size: 16)
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

private extension CellForToday {
	func loadImage(url: URL) {
		let writeURL = url.absoluteString
		if safeImage != writeURL {
			safeImage = writeURL
		}
	//	URLSession.shared.dataTask(with: url) { data, response, error in
			DispatchQueue.main.async {
//				guard
//					let data = data, error == nil,
//					let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200
//					else {
//					return
//				}
				let request = URLRequest(url: url)
				self.webView.load(request)
			}
//		}
//		.resume()
	}

	/*
	 let webView = WKWebView(frame: view.bounds)
	 let request = URLRequest(url: URL(string: path)!)
	 webView.load(request)
	 view.addSubview(webView)
	 */
}
