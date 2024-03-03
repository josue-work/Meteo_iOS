//
//  MockNetworkingService.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import Foundation

class MockNetworkingService: NetworkingService {
    let jsonString: String
    
    init(jsonString: String) {
        self.jsonString = jsonString
    }
    
    func fetchData(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        
        if let data = jsonString.data(using: .utf8) {
            completion(data, nil)
        } else {
            let error = NSError(domain: "MockNetworkingServiceErrorDomain", code: -1, userInfo: nil)
            completion(nil, error)
        }
    }
}
