//
//  MainHomeViewController.swift
//  iWeather
//
//  Created by Steven Kirke on 13.02.2024.
//

import UIKit
import SnapKit

protocol IMainHomeViewLogic: AnyObject {
	func renderCity(viewModel: [MainHomeModel.ViewModel.City])
	func renderHour(viewModel: [MainHomeModel.ViewModel.Hour])
}

final class MainHomeViewController: UIViewController {

	// MARK: - Public properties

	// MARK: - Dependencies
	var iterator: IMainHomeIterator?

	// MARK: - Private properties
	private var collectionCities = CitiesCollectionView()
	private var collectionTodayTemp = TodayCollectionView()

	private var isCurrentLocation = false
	private var currentCoordinate: WCoordinate = WCoordinate(latitude: 0, longitude: 0)

	// MARK: - Initializator
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: - Lifecycle

	// MARK: - Public methods

	// MARK: - Public methods
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConfiguration()
		addUIView()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupLayout()

		getCurrentLocation()
		getListCities()
	}

	// MARK: - Private methods
}

// - MARK: Add UIView in Controler
private extension MainHomeViewController {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [collectionCities, collectionTodayTemp]
		views.forEach(view.addSubview)
	}
}

// - MARK: Initialisation configuration
private extension MainHomeViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		view.backgroundColor = UIColor(hex: "#431098")
		collectionCities.translatesAutoresizingMaskIntoConstraints = false

		collectionTodayTemp.translatesAutoresizingMaskIntoConstraints = false
	}
}

// - MARK: Initialisation constraint elements.
private extension MainHomeViewController {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {
		collectionCities.snp.makeConstraints { citiesView in
			citiesView.bottom.equalTo(collectionTodayTemp.snp.top).inset(-63)
			citiesView.left.right.equalToSuperview()
			citiesView.height.equalTo(215)
		}

		collectionTodayTemp.snp.makeConstraints { todayTempView in
			todayTempView.bottom.equalToSuperview().inset(91)
			todayTempView.left.right.equalToSuperview()
			todayTempView.height.equalTo(152)
		}
	}
}

// MARK: - Action UI
private extension MainHomeViewController {
	func getCurrentLocation() {
		if !isCurrentLocation {
			iterator?.fetchCurrentLocation()
		}
	}

	func getListCities() {
		iterator?.fetchCityList()
	}
}

// MARK: - Render Logic
extension MainHomeViewController: IMainHomeViewLogic {
	func renderCity(viewModel: [MainHomeModel.ViewModel.City]) {
		collectionCities.reloadData(render: viewModel)
	}

	func renderHour(viewModel: [MainHomeModel.ViewModel.Hour]) {
		collectionTodayTemp.reloadData(hours: viewModel)
	}
}
