//
//  ICoordinator.swift
//  iWeather
//
//  Created by Steven Kirke on 14.02.2024.
//

import UIKit

protocol ICoordinator: AnyObject {

	var childCoordinators: [ICoordinator] { get set }

	var finishDelegate: ICoordinatorFinishDelegate? { get set }

	var navigateController: UINavigationController { get set }

	func start()

	func finish()
}

extension ICoordinator {
	func finish() {
		childCoordinators.removeAll()
		finishDelegate?.didFinish(coordinator: self)
	}
}
