//https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation

class Router <EndPoint: EndPointType>: NetworkRouter {
	private var task: URLSessionTask?
	private let mainQueue = DispatchQueue.main
	func request(_ route: EndPoint, completion: @escaping NetworkRouterComplection){
		let session = URLSession.shared
		do {
			let request = try self.buildRequest(from: route)
			if let cachedResponse = URLCache.shared.cachedResponse(for: request){
				mainQueue.async {
					completion(cachedResponse.data, cachedResponse.response, nil)
				}
			} else {
				task = session.dataTask(with: request, completionHandler: { data, response, error in
					guard let _data = data,
						let _response = response else { completion(data, response, error); return }
					
					self.saveCache(data: _data, response: _response)
					completion(_data, _response, error)
				})
			}
		} catch {
			completion(nil, nil, error)
		}
		self.task?.resume()
	}
	
	func cancel() {
		self.task?.cancel()
	}
}
//	MARK: - private func
fileprivate extension Router {
	private func buildRequest(from route: EndPoint) throws -> URLRequest {
		
		var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
								 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
		request.httpMethod = route.httpMethod.rawValue
		
		do {
			switch route.task {
			case .request:
				request.setValue("application/json", forHTTPHeaderField: "Content-Type")
				
			case .requestParameters(let bodyParameters,
									let urlPaarameters):
				try self.configureParameters(bodyParameters: bodyParameters,
											 urlParameters: urlPaarameters,
											 request: &request)
				
			case .requestUrlParameters(let urlParameters):
				try self.configureParameters(bodyParameters: nil,
											 urlParameters: urlParameters,
											 request: &request)
				
			case .requestParametersAndHeaders(let bodyParameters,
											  let urlParameters,
											  let additionHeaders):
				self.addAdditionalHeaders(additionHeaders, request: &request)
				try self.configureParameters(bodyParameters: bodyParameters,
											 urlParameters: urlParameters,
											 request: &request)
				
			case .requestHeaders(let additionHeaders):
				self.addAdditionalHeaders(additionHeaders, request: &request)
			}
			return request
		} catch {
			throw error
		}
	}
	
	private func configureParameters(bodyParameters: Parameters?,
										 urlParameters: Parameters?,
										 request: inout URLRequest) throws {
		do {
			if let bodyParameters = bodyParameters {
				try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
			}
			if let urlParameters = urlParameters {
				try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
			}
		} catch {
			throw error
		}
	}
	
	private func addAdditionalHeaders(_ additionalHedears: HTTPHeaders?, request: inout URLRequest) {
		guard let headers = additionalHedears else { return }
		for (key, value) in headers {
			request.setValue(value, forHTTPHeaderField: key)
		}
	}
	
	//	MARK: - URLCache save cache
	private func saveCache(data: Data, response: URLResponse) {
		guard let responseURL = response.url else { return }
		let cachedResponse = CachedURLResponse(response: response, data: data)
		URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
	}
}
