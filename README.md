# iWeather

## Description
#### Данное приложение является тестовой работой, для выявление навыков работы с:
##### * Многопоточностью,
##### * Различными API,
##### * "С шеолокацей", 
##### * "верской кода с использованием  SnapKit SVGKit",

#### Включает в себя сцены:
##### * "Главный экран",
##### * "Экран с зеленой плашкой".

## Getting started
##### Запустить файл iWeather.xcworkspace.

## Usage
####

## Architecture
#### В данном проекте используется архитектура Clean Architecture.

## Structure

``` bash
├── iWeather
│   ├── README.md
│   ├── swiftlint.yml
│   ├── Packages
│   │   └── SnapKit-develop
│   ├── iWeather
│   │   ├── ConvertersDTO
│   │   │   ├── ConvertorHourDTO.swift
│   │   │   ├── ConvertorWeatherForLocationDTO.swift
│   │   │   └── ConvertorCityDTO.swift
│   │   ├── Styles
│   │   │   └── GlobalStyles.swift
│   │   ├── Extensions
│   │   │   └── Extension+UIColor.swift
│   │   ├── Mocks
│   │   │   └── CitiesMock.json
│   │   ├── Entities
│   │   ├── Managers
│   │   │   ├── LocationManager.swift
│   │   │   ├── DecodeJSONManager.swift
│   │   │   ├── NetworkManager.swift
│   │   │   └── WriteFileManager.swift
│   │   ├── Services
│   │   │   ├── AssemblerURLService.swift
│   │   │   ├── AssemblerURLRequestService.swift
│   │   │   └── TimeConvertServices.swift
│   │   ├── Coordinators
│   │   │   ├── Common
│   │   │   │   ├── ICoordinator.swift
│   │   │   │   ├── ICoordinatorDelegate.swift
│   │   │   │   └── AppCoordinator.swift
│   │   │   ├── MainHomeCoordinator.swift
│   │   │   └── MainMenuCoordinator.swift
│   │   ├── Flows
│   │   │   ├── MainFlow
│   │   │   │   └── MainHomeScene
│   │   │   │       ├── MainHomeAssembler.swift
│   │   │   │       ├── MainHomeViewController.swift
│   │   │   │       ├── MainHomeIterator.swift
│   │   │   │       ├── MainHomePresenter.swift
│   │   │   │       ├── MainHomeViewModel.swift
│   │   │   │       ├── AdditionalView
│   │   │   │       │     ├── HeaderView
│   │   │   │       │     │      └── HeaderView.swift
│   │   │   │       │     ├── CitiesCollectionView
│   │   │   │       │     │      ├── CitiesCollectionView.swift
│   │   │   │       │     │      └── CellForCities.swift
│   │   │   │       │     └── TodayCollectionView
│   │   │   │       │            ├── TodayCollectionView.swift
│   │   │   │       │            └── CellForToday.swift
│   │   │   │       └── Worker
│   │   │   │             ├── MainHomeWorker.swift
│   │   │   │             ├── SitiesDTO.swift
│   │   │   │             ├── TemperatureDTO.swift
│   │   │   │             └── WeatherDTO.swift
│   │   │   └── MenuFlow
│   │   │       └── MainMenuScene
│   │   │           ├── MainMenuAssembler.swift
│   │   │           └── MainMenuViewController.swift
│   │   ├── Application
│   │   │   ├── AppDelegate.swift
│   │   │   └── SceneDelegate.swift
│   │   └── Resources
│   │       │   └── Fonds
│   │       │       ├── Roboto-Regular
│   │       │       ├── Poppins-SemiBold
│   │       │       ├── Poppins-Medium
│   │       │       └── Poppins-Regular
│   │       ├── LaunchScreen.storyboard
│   │       ├── Assets.xcassets
│   │       └── Info.plist
│   ├── Products
│   ├── Frameworks
│   ├── Pods
└── Pods

```

## Running the tests

## Dependencies
#### Добавлен пакет SnapKit
#### Добавлен пакет SVGKit (Pods)
#### Добавлен пакет CocoaLumberjack (Pods)

## Workflow
#### XCode version: 15.2 
#### iOS version: 14.2

## Design
#### Дизайн для приложения выполнен по макету Figma
 https://www.figma.com/file/rggCrMxbvwdaHCL0WHkWYf/weather-app-(Community)-(Copy)?node-id=0%3A1&mode=dev.

## Task boards
#### Для координации используется Kaiten.

## API
#### В приложении используются API:
##### * [Яндекс погода ](https://yandex.ru/dev/weather) 
##### * [Список крупных городов России ](https://htmlweb.ru) 
