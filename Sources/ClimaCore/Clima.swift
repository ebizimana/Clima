import Foundation

public final class Clima {
    private let arguments: [String]
    
    public init(arguments: [String] = CommandLine.arguments){
        self.arguments = arguments
    }
    
    public func run() throws {
        print("Hello World")
    }
}
