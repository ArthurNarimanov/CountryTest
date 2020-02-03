//
//  CountryDescriptionPresenter.swift
//  CountryTestNarimanov
//
//  Created by Arthur Narimanov on 03/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import Foundation

protocol CountryViewProtocol: class {
	func succes()
	func failure(error: String)
}
protocol CountryDescriptionViewPresenterProtocol: class {
	init(view: CountryViewProtocol, networkService: NetworkServiceProtocol)
	func searchCountry(by code: String)
	var country: CountryDescriptionModelProtocol? { get set }
}

class CountryDescriptionViewPresenter: CountryDescriptionViewPresenterProtocol {
	weak var view: CountryViewProtocol!
	let networkService: NetworkServiceProtocol!
	var country: CountryDescriptionModelProtocol?
	
	required init(view: CountryViewProtocol, networkService: NetworkServiceProtocol) {
		self.view = view
		self.networkService = networkService
	}
	
	func searchCountry(by code: String) {
		networkService.getCountryDescription(code: code) { [weak self] result in
			guard let _self = self else { return }
			switch result {
			case .success(let country):
				_self.country = country
				_self.view.succes()
				
			case .failure(let error):
				_self.view.failure(error: error)
			}
		}
	}
	
}
