

import Foundation


enum APIServer {
    
    case live, development
    
    var domainUrl: String {
        switch self {
        case .live:
            return "http://15.206.22.70"

        case .development:
            return "http://15.206.22.70"
        }
    }
    
    var apiBaseUrl: String {
        switch self {
        case .live:
            return "\(self.domainUrl)/api/v1/"

        case .development:
            return "\(self.domainUrl):9001/v1/"
        }
    }
    
    var imageBaseUrl: String {
        switch self {
        case .live:
            return "\(self.domainUrl)/taxi_node_server/"
        case .development:
            return "\(self.domainUrl)/taxi_node_server/"
        }
    }
}
