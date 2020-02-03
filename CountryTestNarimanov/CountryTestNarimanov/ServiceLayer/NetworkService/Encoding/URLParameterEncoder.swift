//https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
	public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
		guard let url = urlRequest.url else { throw NetworkError.missingURL }
		
		if let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false),
			!parameters.isEmpty {
			
			var item: [URLQueryItem] = []
			
			for (key, value) in parameters {
				let queryItem = URLQueryItem(name: key,
											 value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
				item.append(queryItem)
			}
			urlComponents.queryItems = item
			urlRequest.url = urlComponents.url
		}
		
		if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
			urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		}
	}
}
