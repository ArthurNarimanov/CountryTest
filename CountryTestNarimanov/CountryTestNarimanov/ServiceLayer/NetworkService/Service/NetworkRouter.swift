//https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation

public typealias NetworkRouterComplection = (_ data: Data?, _ responce: URLResponse?, _ error: Error?) ->()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterComplection)
    func cancel()
}
