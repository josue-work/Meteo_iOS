//
//  NetworkService.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/03.
//

import Foundation

protocol NetworkingService {
    func fetchData(url: URL, completion: @escaping (Data?, Error?) -> Void)
}

class MainNetworkingService: NetworkingService {
    
    func fetchData(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        var request = URLRequest(url: url)

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                completion(data, nil)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                completion(nil, error)
            }
        }

        task.resume()
    }
}
