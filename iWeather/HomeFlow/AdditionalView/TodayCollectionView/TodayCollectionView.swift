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
	private lazy var labelTitle = createUILabel()
	private var modelForDisplay: [MainHomeModel.ViewModel.Hour] = []
	private lazy var buttonLeft =  createButtonWithImage(systemName: "chevron.right")
	private lazy var buttonRight =  createButtonWithImage(systemName: "chevron.left")

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
		let views: [UIView] = [
			labelTitle,
			collectionTodayTemp,
			buttonLeft,
			buttonRight
		]
		views.forEach(addSubview)
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

		labelTitle.text = "Today"
		labelTitle.textAlignment = .left
		labelTitle.font = FontsStyle.poppinsMedium(20).font

		buttonLeft.addTarget(self, action: #selector(movingLeft), for: .touchUpInside)

		buttonRight.isHidden = true
		buttonRight.addTarget(self, action: #selector(movingRight), for: .touchUpInside)
	}
}

// - MARK: Initialisation constraint elements.
private extension TodayCollectionView {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		collectionTodayTemp.snp.makeConstraints { collection in
			collection.top.equalToSuperview()
			collection.left.equalToSuperview().inset(25)
			collection.right.equalToSuperview().inset(25)
			collection.bottom.equalToSuperview()
		}

		labelTitle.snp.makeConstraints { title in
			title.bottom.equalTo(collectionTodayTemp.snp.top).inset(-6)
			title.left.equalTo(collectionTodayTemp.snp.left)
			title.width.equalTo(collectionTodayTemp.snp.width).dividedBy(2)
			title.height.equalTo(30)
		}

		buttonLeft.snp.makeConstraints { buttonNext in
			buttonNext.width.height.equalTo(20)
			buttonNext.right.equalToSuperview().inset(5)
			buttonNext.top.equalTo(collectionTodayTemp.snp.top).inset(28)
		}

		buttonRight.snp.makeConstraints { buttonNext in
			buttonNext.width.height.equalTo(20)
			buttonNext.left.equalToSuperview().inset(5)
			buttonNext.top.equalTo(collectionTodayTemp.snp.top).inset(28)
		}
	}
}

extension TodayCollectionView: UICollectionViewDelegateFlowLayout {

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: 76, height: 106)
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

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let item = checkIndexPath()

		guard let currentItem = item else { return }
		let nextItem = IndexPath(item: currentItem.item - 1, section: 0)
		if nextItem.item > 1 {
			showButton()
		} else {
			hideButton()
		}
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

	func createUILabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 1
		label.textAlignment = .center
		label.textColor = UIColor.white
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	func createButtonWithImage(systemName: String) -> UIButton {
		let button = UIButton()
		let configuration = UIImage.SymbolConfiguration(textStyle: .title1)
		let image = UIImage(systemName: systemName, withConfiguration: configuration)
		button.setImage(image, for: .normal)
		button.tintColor = UIColor(hex: "#622FB5")
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}
}

// MARK: - UI Action
private extension TodayCollectionView {
	@objc func movingLeft() {
		let item = checkIndexPath()

		guard let currentItem = item else { return }
		let nextItem = IndexPath(item: currentItem.item + 1, section: 0)
		if nextItem.row < modelForDisplay.count {
			self.collectionTodayTemp.scrollToItem(at: nextItem, at: .left, animated: true)
		}

		if nextItem.row >= 1 {
			showButton()
		}
	}

	@objc func movingRight() {
		let item = checkIndexPath()
		guard let currentItem = item else { return }
		let nextItem = IndexPath(item: currentItem.item - 1, section: 0)
		if nextItem.row < modelForDisplay.count && nextItem.row > 0 {
			self.collectionTodayTemp.scrollToItem(at: nextItem, at: .right, animated: true)
		}
		if nextItem.row <= 1 {
			hideButton()
		}
	}

	func checkIndexPath() -> IndexPath? {
		let visibleItems = collectionTodayTemp.indexPathsForVisibleItems as NSArray
		let item = visibleItems.object(at: 0) as? IndexPath
		return item
	}

	func hideButton() {
		buttonRight.isHidden = true
	}

	func showButton() {
		buttonRight.isHidden = false
	}
}
