//
//  AppCoordinator.swift
//  iWeather
//
//  Created by Steven Kirke on 14.02.2024.
//

import Foundation

import UIKit

protocol IAppCoordinator: ICoordinator {
	func showHomeFlow()
	func showMenuFlow()
}

final class AppCoordinator: IAppCoordinator {

	var childCoordinators: [ICoordinator] = []

	var finishDelegate: ICoordinatorFinishDelegate?

	var navigateController: UINavigationController

	internal init(navigateController: UINavigationController) {
		self.navigateController = navigateController
	}

	func start() {
		showHomeFlow()
	}

	func finish() { }

	func showHomeFlow() {
		let coordinator = MainHomeCoordinator(navigateController: navigateController)
		childCoordinators.append(coordinator)
		coordinator.finishDelegate = self
		coordinator.start()
	}

	func showMenuFlow() {
		let coordinator = MainMenuCoordinator(navigateController: navigateController)
		childCoordinators.append(coordinator)
		coordinator.finishDelegate = self
		coordinator.start()
	}
}

extension AppCoordinator: ICoordinatorFinishDelegate {
	func didFinish(coordinator: ICoordinator) {
		switch coordinator {
		case is IMainHomeCoordinator:
			childCoordinators.removeAll()
			showMenuFlow()
		default:
			break
		}
	}
}
