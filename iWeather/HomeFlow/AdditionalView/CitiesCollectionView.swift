//
//  CitiesCollectionView.swift
//  iWeather
//
//  Created by Steven Kirke on 17.02.2024.
//

import UIKit
import SnapKit

protocol ICitiesCoordinateHandler {
	func returnCoordinate(latitude: Double, longitude: Double)
}

final class CitiesCollectionView: UIView {

	// MARK: - Public properties
	var handlerCoordinateDelegate: ICitiesCoordinateHandler?
	// MARK: - Dependencies

	// MARK: - Private properties
	private lazy var collectionCities = createCollectionView()
	private var modelForDisplay: [MainHomeModel.ViewModel.City] = []

	// MARK: - Initializator

	convenience init(handlerCoordinateDelegate: ICitiesCoordinateHandler?) {
		self.init(frame: CGRect.zero)
		self.handlerCoordinateDelegate = handlerCoordinateDelegate
	}

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
	func reloadData(render: [MainHomeModel.ViewModel.City]) {
		self.modelForDisplay = render
		collectionCities.reloadData()
	}
}

// - MARK: Add UIView in Controler
private extension CitiesCollectionView {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		addSubview(collectionCities)
	}
}

// - MARK: Initialisation configuration
private extension CitiesCollectionView {
	/// Настройка UI элементов
	func setupConfiguration() {
		collectionCities.backgroundColor = .clear
		collectionCities.layer.cornerRadius = 22
		collectionCities.clipsToBounds = true
		collectionCities.register(CellForCities.self, forCellWithReuseIdentifier: CellForCities.identifierID)

		collectionCities.delegate = self
		collectionCities.dataSource = self
	}
}

// - MARK: Initialisation constraint elements.
private extension CitiesCollectionView {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		collectionCities.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.left.equalToSuperview()
			make.right.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}
}

extension CitiesCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		CGSize(width: 172, height: 215)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
	}
}

// MARK: - Add Delegate UICollectionView
extension CitiesCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		modelForDisplay.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let city = modelForDisplay[indexPath.item]
		//print("\(city.title) \(city.coordinate)")
		if let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: CellForCities.identifierID,
			for: indexPath
		) as? CellForCities {
			cell.reloadData(city: city)
			return cell
		}
		return UICollectionViewCell()
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let location = modelForDisplay[indexPath.item]
		//print("\(location.title) \(location.coordinate)")
		//print(location.title)
		//print(location.coordinate)
		self.handlerCoordinateDelegate?.returnCoordinate(
			latitude: location.coordinate.latitude,
			longitude: location.coordinate.longitude
		)
	}
}

// - MARK: Fabric UIElement.
private extension CitiesCollectionView {
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
