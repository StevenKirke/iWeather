//
//  SceneDelegate.swift
//  iWeather
//
//  Created by Steven Kirke on 13.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	// MARK: - Dependencies
	private var appCoordinator: AppCoordinator!

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)
		let navigationController = UINavigationController()
		appCoordinator = AppCoordinator(navigateController: navigationController)
		window.rootViewController = navigationController
		window.makeKeyAndVisible()

		appCoordinator.start()

		self.window = window
	}

	func sceneDidDisconnect(_ scene: UIScene) { }

	func sceneDidBecomeActive(_ scene: UIScene) { }

	func sceneWillResignActive(_ scene: UIScene) { }

	func sceneWillEnterForeground(_ scene: UIScene) { }

	func sceneDidEnterBackground(_ scene: UIScene) { }
}
