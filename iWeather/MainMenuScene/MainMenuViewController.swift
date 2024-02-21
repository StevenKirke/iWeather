//
//  MainMenuViewController.swift
//  iWeather
//
//  Created by Steven Kirke on 21.02.2024.
//

import UIKit
import SnapKit

final class MainMenuViewController: UIViewController {

	// MARK: - Initializator
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: - Public methods
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConfiguration()
	}
}

// - MARK: Initialisation configuration
private extension MainMenuViewController {
	/// Настройка UI элементов
	func setupConfiguration() {
		navigationController?.setNavigationBarHidden(false, animated: true)
		view.backgroundColor = UIColor.green
	}
}
