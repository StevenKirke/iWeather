//
//  WriteFileManager.swift
//  iWeather
//
//  Created by Steven Kirke on 16.02.2024.
//

import Foundation

// Enum, с описание формата файлов.
enum TypeFile {
	// Файл, формата JSON.
	case json

	var title: String {
		switch self {
		case .json:
			return "json"
		}
	}
}

// Enum, описывающие возврат ошибок для методов чтения из файловой системы.
enum ErrorFile: Error {
	// Ошибка чтения файла.
	case errorReadFile
	case errorDecode(String)

	var title: String {
		switch self {
		case .errorReadFile:
			return "Invalid rite file."
		case .errorDecode(let error):
			return "Invalid decode file \(error)."
		}
	}
}

/// Менеджер работы с файлами системы.
protocol IWriteFileManager {
	/**
	 Метод, получения файла из проекта.
	 - Parameters: авв
			- resource: Имя файла в проекте.
			- type: Тип формата файла.
	 - Throws: Возвращает ошибку тип enum ``ErrorFile``.
	 - Returns:
	 */
	func getFile(resource: String, type: TypeFile, response: @escaping (Result<Data, ErrorFile>) -> Void)
}

final class WriteFileManager: IWriteFileManager {
	func getFile(resource: String, type: TypeFile, response: @escaping (Result<Data, ErrorFile>) -> Void) {
		DispatchQueue.main.async {
			let path = Bundle.main.path(forResource: resource, ofType: type.title)
			guard let currentPath = path else {
				response(.failure(.errorReadFile))
				return
			}
			do {
				let currentURL = URL(fileURLWithPath: currentPath)
				let data = try Data(contentsOf: currentURL, options: .alwaysMapped)
				response(.success(data))
			} catch let error {
				response(.failure(.errorDecode(error.localizedDescription)))
			}
		}
	}
}
