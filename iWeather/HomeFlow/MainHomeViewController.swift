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
	func renderWeatherLocal(viewModel: MainHomeModel.ViewModel.WeatherLocation)
}

final class MainHomeViewController: UIViewController {

	// MARK: - Dependencies
	var iterator: IMainHomeIterator?
	var handlerDelegate: ICitiesCoordinateHandler?

	// MARK: - Private properties
	private lazy var collectionCities = CitiesCollectionView()
	private lazy var collectionTodayTemp = TodayCollectionView()
	private lazy var headerView = HeaderView()
	private lazy var buttonIPerson = createButtonWithImage(systemName: "person.crop.circle")
	private lazy var buttonBurgerMenu = createButtonWithImage(systemName: "line.3.horizontal")

	private var isCurrentLocation = false

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
		getListCities()
		getCurrentLocation()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupLayout()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: false)
	}

	// MARK: - Private methods
}

// - MARK: Add UIView in Controler
private extension MainHomeViewController {
	/// Добавление элементов UIView в Controller.
	func addUIView() {
		let views: [UIView] = [
			headerView,
			collectionCities,
			collectionTodayTemp,
			buttonIPerson,
			buttonBurgerMenu
		]
		views.forEach(view.addSubview)
	}
}

// - MARK: Initialisation configuration
private extension MainHomeViewController {
	/// Настройка UI элементов
	func setupConfiguration() {

		view.backgroundColor = UIColor(hex: "#431098")
		collectionCities.translatesAutoresizingMaskIntoConstraints = false
		collectionCities.handlerCoordinateDelegate = self
		collectionTodayTemp.translatesAutoresizingMaskIntoConstraints = false

		buttonIPerson.addTarget(self, action: #selector(self.showProfile), for: .touchUpInside)
		buttonBurgerMenu.addTarget(self, action: #selector(self.nextMenuScene), for: .touchUpInside)
	}
}

// - MARK: Initialisation constraint elements.
private extension MainHomeViewController {
	/// Верстка элементов UI.
	/// - Note: Добавление constraints для UIView элементов.
	func setupLayout() {

		headerView.snp.makeConstraints { viewBack in
			viewBack.top.equalToSuperview()
			viewBack.left.right.equalToSuperview()
			viewBack.height.equalTo(381)
		}

		collectionCities.snp.makeConstraints { citiesView in
			citiesView.top.equalTo(headerView.snp.bottom).inset(-30)
			citiesView.left.right.equalToSuperview().inset(25)
			citiesView.height.equalTo(215)
		}

		collectionTodayTemp.snp.makeConstraints { todayTempView in
			todayTempView.top.equalTo(collectionCities.snp.bottom).inset(-60)
			todayTempView.left.right.equalToSuperview()
			todayTempView.height.equalTo(106)
		}

		buttonIPerson.snp.makeConstraints { buttonPerson in
			buttonPerson.top.equalTo(headerView.snp.topMargin).inset(-20)
			buttonPerson.left.equalToSuperview().inset(25)
			buttonPerson.width.height.equalTo(44)
		}

		buttonBurgerMenu.snp.makeConstraints { buttonPerson in
			buttonPerson.top.equalTo(headerView.snp.topMargin).inset(-20)
			buttonPerson.right.equalToSuperview().inset(25)
			buttonPerson.width.height.equalTo(44)
		}
	}
}

// - MARK: Fabric UI Element.
private extension MainHomeViewController {
	func createGradient() -> CAGradientLayer {
		let gradient = CAGradientLayer()
		let colours = [
			UIColor(hex: "#1B0F36").cgColor,
			UIColor(hex: "#2F1C78").cgColor,
			UIColor(hex: "#321E82").cgColor
		]
		gradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 381)
		gradient.colors = colours

		return gradient
	}

	func createButtonWithImage(systemName: String) -> UIButton {
		let button = UIButton()
		let configuration = UIImage.SymbolConfiguration(textStyle: .title1)
		let image = UIImage(systemName: systemName, withConfiguration: configuration)
		button.setImage(image, for: .normal)
		button.tintColor = UIColor.white
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}
}

// MARK: - Action UI
private extension MainHomeViewController {
	func getCurrentLocation() {
		if !isCurrentLocation {
			iterator?.fetchCurrentLocation(coordinate: nil)
		}
	}

	func getListCities() {
		iterator?.fetchCityList()
	}

	@objc func showProfile() {
		iterator?.showProfileView()
	}

	@objc func nextMenuScene() {
		iterator?.showMenuScene()
	}
}

// MARK: - Render Logic
extension MainHomeViewController: IMainHomeViewLogic {
	func renderCity(viewModel: [MainHomeModel.ViewModel.City]) {
		return collectionCities.reloadData(render: viewModel)
	}

	func renderHour(viewModel: [MainHomeModel.ViewModel.Hour]) {
		collectionTodayTemp.reloadData(hours: viewModel)
	}

	func renderWeatherLocal(viewModel: MainHomeModel.ViewModel.WeatherLocation) {
		headerView.reloadData(model: viewModel)
	}
}

extension MainHomeViewController: ICitiesCoordinateHandler {
	func returnCoordinate(latitude: Double, longitude: Double) {
		let coord = MainHomeModel.Response.Coordinate(latitude: latitude, longitude: longitude)
		iterator?.fetchCurrentLocation(coordinate: coord)
	}
}
