//
//  MainMenuCoordinator.swift
//  iWeather
//
//  Created by Steven Kirke on 21.02.2024.
//

import UIKit

protocol IMainMenuCoordinator: ICoordinator {
	func showMainMenuScene()
}

final class MainMenuCoordinator: IMainMenuCoordinator {

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
		showMainMenuScene()
	}

	func showMainMenuScene() {
		let assembler = MainMenuAssembler()
		let mainMenuVC = assembler.configurator()
		navigateController.pushViewController(mainMenuVC, animated: true)
	}
}
