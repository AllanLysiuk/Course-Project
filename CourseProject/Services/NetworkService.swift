//
//  NetworkService.swift
//  CourseProject
//
//  Created by Allan on 27.01.23.
//

import Foundation
import UIKit



final class NetworkService {
    
    private let domain: URL = URL(string: "https://api.sampleapis.com/wines/")!
    
    private enum Path {
        static let redWine = "reds"
        static let whiteWine = "whites"
        static let sparklingWine = "sparkling"
        static let roseWine = "rose"
        static let dessertWine = "dessert"
        static let portWine = "port"
    }
    
    func loadWines(type: WineType, completion: @escaping (([WineElement]) -> Void)) {
        //MARK: URL
        let path = getPathByTypeOfWine(type: type)
        let url = domain.appendingPathComponent(path)
        //MARK: Setup request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //MARK: send request
        URLSession.shared.dataTask(with: request)
        { responceData, responce, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let wineData = responceData {
                let model = try? JSONDecoder().decode([WineElement].self, from: wineData)
               // print(model)
                DispatchQueue.main.async {
                    completion(model ?? [])
                }
            }
        }.resume()
        
    }
     private func getPathByTypeOfWine(type: WineType) -> String {
        switch type{
        case .red:
            return Path.redWine
        case .white:
            return Path.whiteWine
        case .sparkling:
            return Path.sparklingWine
        case .rose:
            return Path.roseWine
        case .dessert:
            return Path.dessertWine
        case .port:
            return Path.portWine
        }
    }
//    private func loginValidation() {
//        let url = domain.appendingPathComponent(Path.login)
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//    }
    
}
