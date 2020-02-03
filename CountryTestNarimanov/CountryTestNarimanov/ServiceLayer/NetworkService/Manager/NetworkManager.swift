//
//  NetworkManager.swift
//  HotelTestNarimanov
//
//  Created by Arthur Narimanov on 01/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//
// https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation

enum NetworkResponce: String {
	case success
	case notFound = "Not Found."
	case authenticationError = "You need to be authenticated first."
	case badRequest = "Bad request."
	case outdated = "The url requested is outdated."
	case failed = "Network request failed."
	case noData = "Response returned with no data to decode."
	case unableToDecode = "We could not decode the response."
	case checkNetConnection = "Please check your network connection."
}
enum ResultResponse<String> {
	case success
	case failure(String)
}
enum ResultNetwork<Decodable, String> {
	case success(Decodable)
	case failure(String)
}

protocol NetworkServiceProtocol {
	typealias ResultNetworkDecodable = ResultNetwork<Decodable?, String>
	
	func getAllCountries(completion: @escaping (ResultNetwork<[CountryModelProtocol]?, String>) -> Void)
	func getAllCountriesSecond(completion: @escaping (ResultNetworkDecodable) -> Void)
	func getCountryDescription(code: String,
							   completion: @escaping (ResultNetwork<CountryDescriptionModelProtocol?, String>) -> Void)
}

struct NetworkManager: NetworkServiceProtocol {
	static let environment: NetworkEnvironment = .production
	private let router = Router<CountryAPI>()
	
	//MARK: - getAllCountriesSecond
	func getAllCountriesSecond(completion: @escaping (ResultNetworkDecodable) -> Void) {
		request(route: .getAllCountries, typeDecodable: [CountryModel].self) { result in
			completion(result)
		}
	}
	
	func getAllCountries(completion: @escaping (ResultNetwork<[CountryModelProtocol]?, String>) -> Void) {
		
		router.request(.getAllCountries) { (data, response, error) in
			if let error = error {
				completion(.failure(error.localizedDescription))
			}
			guard let response = response as? HTTPURLResponse
				else { completion(.failure(NetworkResponce.failed.rawValue)); return }
			
			let result = self.handleNetworkResponse(response)
			switch result {
			case .success:
				guard let responseData = data
					else { completion(.failure(NetworkResponce.noData.rawValue)); return }
				
				do {
					let apiResponse = try JSONDecoder().decode([CountryModel].self, from: responseData)
					completion(.success(apiResponse))
				} catch {
					completion(.failure(NetworkResponce.unableToDecode.rawValue))
				}
				
			case .failure(let error):
				completion(.failure(error.rawValue))
			}
		}
	}
	
	func getCountryDescription(code: String,
							   completion: @escaping (ResultNetwork<CountryDescriptionModelProtocol?, String>) -> Void) {
		router.request(.getCountry(code: code)) { (data, response, error) in
			if let error = error {
				completion(.failure(error.localizedDescription))
			}
			guard let response = response as? HTTPURLResponse
				else { completion(.failure(NetworkResponce.failed.rawValue)); return }
			
			let result = self.handleNetworkResponse(response)
			switch result {
			case .success:
				guard let responseData = data
					else { completion(.failure(NetworkResponce.noData.rawValue)); return }
				
				do {
					let apiResponse = try JSONDecoder().decode(CountryDescriptionModel.self, from: responseData)
					completion(.success(apiResponse))
				} catch {
					completion(.failure(NetworkResponce.unableToDecode.rawValue))
				}
				
			case .failure(let error):
				completion(.failure(error.rawValue))
			}
		}
	}
}

//MARK: - private func
fileprivate extension NetworkManager {

	private func handleNetworkResponse(_ response: HTTPURLResponse) -> ResultResponse<NetworkResponce> {
		switch response.statusCode {
		case 200 ... 299: return .success
		case 404: return .failure(NetworkResponce.notFound)
		case 400 ... 500: return .failure(NetworkResponce.authenticationError)
		case 501 ... 599: return .failure(NetworkResponce.badRequest)
		case 600: return .failure(NetworkResponce.outdated)
		default: return .failure(NetworkResponce.failed)
			
		}
	}
	
	private func request<T: Decodable>(route: CountryAPI,
									   typeDecodable: T.Type,
									   completion: @escaping (ResultNetworkDecodable) -> Void) {
		
		router.request(route) { (data, response, error) in
			if let error = error {
				completion(.failure(error.localizedDescription))
			}
			guard let response = response as? HTTPURLResponse
				else { completion(.failure(NetworkResponce.failed.rawValue)); return }
			
			let result = self.handleNetworkResponse(response)
			switch result {
			case .success:
				guard let responseData = data
					else { completion(.failure(NetworkResponce.noData.rawValue)); return }
				
				do {
					let apiResponse = try JSONDecoder().decode(typeDecodable.self,
															   from: responseData)
					completion(.success(apiResponse))
					
				} catch {
					completion(.failure(NetworkResponce.unableToDecode.rawValue))
				}
				
			case .failure(let error):
				completion(.failure(error.rawValue))
			}
		}
	}
}
