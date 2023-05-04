import Foundation

public struct OMNTools {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}

open class MathsSuitable {
    fileprivate(set) var range: Int

    public init(range: Int) {
        self.range = range
    }

    @objc public func facto(n: Int) -> Int {
        if n == 0 {
            return 1
        }
        return n * facto(n: n-1)
    }
}
