//
//  MainHomeCoordinator.swift
//  iWeather
//
//  Created by Steven Kirke on 14.02.2024.
//

import UIKit

protocol IMainHomeCoordinator: ICoordinator {
	func showMainScene()
}

protocol IMainHomeDelegate: AnyObject {
	func showAlertView(massage: String)
}

final class MainHomeCoordinator: IMainHomeCoordinator {

	// MARK: - Public properties
	var childCoordinators: [ICoordinator] = []

	// MARK: - Dependencies
	var navigateController: UINavigationController
	var finishDelegate: ICoordinatorFinishDelegate?

	// MARK: - Private properties

	// MARK: - Initializator
	internal init(navigateController: UINavigationController) {
		self.navigateController = navigateController
	}

	// MARK: - Public methods
	func start() {
		showMainScene()
	}

	func showMainScene() {
		let assembler = MainHomeAssembler()
		let mainHomeVC = assembler.configurator()
		navigateController.pushViewController(mainHomeVC, animated: true)
	}
}

final class AlertView: UIViewController {
	func createAlertView(massage: String) -> UIAlertController {
		let alert = UIAlertController(title: "Alert", message: massage, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))

		return alert
	}
}
