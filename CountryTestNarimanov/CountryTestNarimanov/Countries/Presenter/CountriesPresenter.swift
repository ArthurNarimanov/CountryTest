//
//  CountriesPresenter.swift
//  CountryTestNarimanov
//
//  Created by Arthur Narimanov on 02/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import Foundation

protocol CountriesViewProtocol: class {
	func succes()
	func failure(error: String)
	func succesSearch()
}

protocol CountriesPresenterProtocol: class {
	init(view: CountriesViewProtocol, networkService: NetworkServiceProtocol)
	func getAllCountries()
	func searchCountry(by name: String)
	var countries: [CountryModelProtocol] { get set }
	var filterCountries: [CountryModelProtocol] { get set }
}

class CountriesPresenter: CountriesPresenterProtocol {
	weak var view: CountriesViewProtocol!
	let networkService: NetworkServiceProtocol!
	var countries = [CountryModelProtocol]() { didSet { filterCountries = countries }}
	var filterCountries = [CountryModelProtocol]()
	
	required init(view: CountriesViewProtocol, networkService: NetworkServiceProtocol) {
		self.view = view
		self.networkService = networkService
	}
	
	func getAllCountries() {
		networkService.getAllCountriesSecond { [weak self] result in
			guard let _self = self else { return }
			switch result {
			case .success(let countries):
				guard let countries = countries else { return }
				_self.countries = countries as? [CountryModelProtocol] ?? []
				_self.view.succes()
				
			case .failure(let error):
				_self.view.failure(error: error)
			}
		}
	}
	
	func searchCountry(by name: String) {
		filterCountries = name.isEmpty ? countries: countries.filter({ country -> Bool in
			return country.name.lowercased().contains(name.lowercased())
		})
		self.view.succesSearch()
	}
	
}
