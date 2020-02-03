//https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation

public enum HTTPMethod: String {
    case post   = "POST"
    case get    = "GET"
    case patch  = "PATCH"
    case put    = "PUT"
    case delete = "DELETE"
}
