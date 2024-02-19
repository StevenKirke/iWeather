//
//  TodayCollectionView.swift
//  iWeather
//
//  Created by Steven Kirke on 18.02.2024.
//

import UIKit
import SnapKit

final class TodayCollectionView: UIView {

	// MARK: - Public properties

	// MARK: - Dependencies

	// MARK: - Private properties
	private lazy var collectionTodayTemp = createCollectionView()
	private var modelForDisplay: [MainHomeModel.ViewModel.Hour] = []

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

	// MARK: - Public methods
	func reloadData(hours: [MainHomeModel.ViewModel.Hour]) {
		self.modelForDisplay = hours
		collectionTodayTemp.reloadData()
	}
}

// - MARK: Add UIView in Controler
private extension TodayCollectionView {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		addSubview(collectionTodayTemp)
	}
}

// - MARK: Initialisation configuration
private extension TodayCollectionView {
	/// Настройка UI элементов
	func setupConfiguration() {
		collectionTodayTemp.backgroundColor = .clear
		collectionTodayTemp.layer.cornerRadius = 16
		collectionTodayTemp.clipsToBounds = true
		collectionTodayTemp.register(CellForToday.self, forCellWithReuseIdentifier: CellForToday.identifierID)

		collectionTodayTemp.delegate = self
		collectionTodayTemp.dataSource = self
	}
}

// - MARK: Initialisation constraint elements.
private extension TodayCollectionView {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		collectionTodayTemp.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.left.equalToSuperview().inset(25)
			make.right.equalToSuperview().inset(25)
			make.bottom.equalToSuperview()
		}
	}
}

extension TodayCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: 76, height: 152)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
}

// MARK: - Add Delegate UICollectionView
extension TodayCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		modelForDisplay.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let hour = modelForDisplay[indexPath.item]
		if let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: CellForToday.identifierID,
			for: indexPath
		) as? CellForToday {
			cell.labelTemperature.text = hour.temp
			cell.labelTime.text = hour.hour
			if let currentURL = URL(string: hour.icon) {
				cell.downloadImage(url: currentURL)
			}
			return cell
		}
		return UICollectionViewCell()
	}
}

// - MARK: Fabric UIElement.
private extension TodayCollectionView {
	func createCollectionView() -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 20
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.translatesAutoresizingMaskIntoConstraints = false

		return collectionView
	}
}
