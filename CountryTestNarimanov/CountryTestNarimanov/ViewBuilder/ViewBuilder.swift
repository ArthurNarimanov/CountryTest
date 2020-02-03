//
//  ViewBuilder.swift
//  CountryTestNarimanov
//
//  Created by Arthur Narimanov on 03/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import UIKit.UIViewController

protocol ViewBuilderProtocol {
	func createCountriesViewController() -> UIViewController
	func createCountryDescriptionViewController(by code: String) -> UIViewController
}

class ViewBuilder {
	static func createCountriesViewController() -> UIViewController {
		let view = CountriesViewController()
		let networkService = NetworkManager()
		let presenter = CountriesPresenter(view: view,
										   networkService: networkService)
		
		view.presenter = presenter
		return view
	}
	
	static func createCountryDescriptionViewController(by code: String) -> UIViewController {
		let view = CountryDescriptionViewController()
		let networkService = NetworkManager()
		let presenter = CountryDescriptionViewPresenter(view: view,
														networkService: networkService)
		
		view.presenter = presenter
		presenter.searchCountry(by: code)
		
		return view
	}
}
