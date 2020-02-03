//https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?,
							urlParameters: Parameters?)
	case requestUrlParameters(urlParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?,
									urlParameters: Parameters?,
       	 							additionHeaders: HTTPHeaders?)
    case requestHeaders(additionHeaders: HTTPHeaders?)
}
