// https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
	static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
	case parametersNil = "Parameters were nil."
	case encodingFailed = "Parameter encoding dailed."
	case missingURL = "URL is nil."
}
