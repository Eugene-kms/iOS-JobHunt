import Foundation

struct Header {
    let imageURL: URL?
    let company: String
    let location: String
}

public final class AccountViewModel {
    
    var header: Header
    
    init(header: Header) {
        self.header = Header(
            imageURL: nil,
            company: "Company",
            location: "Location not specified"
        )
        
        
    }
}
