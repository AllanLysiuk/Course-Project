//
//  WineElement.swift
//  CourseProject
//
//  Created by Allan on 27.01.23.
//

import Foundation

// MARK: - WineElement
struct WineElement: Codable {
    let winery: String
    let wine: String
    let rating: Rating
    let location: String
    let image: String
    let id: Int
}

// MARK: - Rating
struct Rating: Codable {
    let average: String
    let reviews: String
}

