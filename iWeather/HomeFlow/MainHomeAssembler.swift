//
//  MainHomeAssembler.swift
//  iWeather
//
//  Created by Steven Kirke on 13.02.2024.
//

import UIKit

final class MainHomeAssembler {
	func configurator() -> UIViewController {
		let networkManager = NetworkManager()
		let decodeJSONManager = DecodeJsonManager()
		let fileManager = WriteFileManager()
		let locationManager = LocationManager()

		let assemblerURL = AssemblerURLCities()
		let assemblerRequestURL = AssemblerURLRequestService()

		let worker = MainHomeWorker(
			networkManager: networkManager,
			decodeJSONManager: decodeJSONManager,
			assemblerURL: assemblerURL,
			assemblerRequestURL: assemblerRequestURL,
			fileManager: fileManager,
			locationManager: locationManager
		)

		let viewController = MainHomeViewController()
		let presenter = MainHomePresenter(viewController: viewController)
		let iterator = MainHomeIterator(presenter: presenter, worker: worker)

		viewController.iterator = iterator

		return viewController
	}
}
