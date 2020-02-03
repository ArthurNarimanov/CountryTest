//
//  CountriesPresenterTest.swift
//  CountryTestNarimanovTests
//
//  Created by Arthur Narimanov on 05/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import XCTest
@testable import CountryTestNarimanov

class MockView: CountriesViewProtocol {
	var titleError: String?
	var isSucces: Bool?
	var isSuccesSearch: Bool?
	
	func succes() {
		self.isSucces = true
	}
	func failure(error: String) {
		titleError = error
	}
	func succesSearch() {
		self.isSuccesSearch = true
	}
}

struct MockCountryModel: CountryModelProtocol {
	var name: String?
	var alpha3Code: String?
}

class MockNetworkManager: NetworkServiceProtocol {
	func getAllCountriesSecond(completion: @escaping (ResultNetwork<Decodable?, String>) -> Void) {}
	
	private let mockCountryModel = MockCountryModel(name: "Foo", alpha3Code: "Baz")
	func getAllCountries(completion: @escaping (ResultNetwork<[CountryModelProtocol]?, String>) -> Void) {
		completion(.success([mockCountryModel]))
	}
	func getCountryDescription(code: String,
							   completion: @escaping (ResultNetwork<CountryDescriptionModelProtocol?, String>) -> Void) {}
}

class CountriesPresenterTest: XCTestCase {
	var view: MockView!
	var presenter: CountriesPresenter!
	var networkService: MockNetworkManager!
	var mockCountryModel: MockCountryModel!
	
    override func setUp() {
		view = MockView()
		networkService = MockNetworkManager()
		presenter = CountriesPresenter(view: view, networkService: networkService)
		mockCountryModel = MockCountryModel(name: "Foo", alpha3Code: "Baz")
    }

    override func tearDown() {
        view = nil
		networkService = nil
		presenter = nil
		mockCountryModel = nil
    }
	
	func testCountriesIsNotNil() {
		XCTAssertNotNil(view)
		XCTAssertNotNil(networkService)
		XCTAssertNotNil(presenter)
		XCTAssertNotNil(mockCountryModel)
	}
	
	func testViewNetworkService() {
		networkService.getAllCountries { result in
			switch result {
			case .success:
				self.view.succes()
			case .failure(let error):
				self.view.failure(error: error)
			}
		}
		XCTAssertEqual(self.view.isSucces, true)
	}
	
	func testViewPresenter() {
		presenter.searchCountry(by: "Foo")
		XCTAssertEqual(self.view.isSuccesSearch, true)
	}
	
	func testCountryModel() {
		XCTAssertEqual(mockCountryModel.name, "Foo")
		XCTAssertEqual(mockCountryModel.alpha3Code, "Baz")
	}
	
}
