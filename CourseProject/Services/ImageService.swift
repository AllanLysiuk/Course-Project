//
//  ImageService.swift
//  CourseProject
//
//  Created by Allan on 8.02.23.
//

import Foundation
import UIKit
final class ImageService{
    func downloadImage(url: URL?) -> UIImage?{
        guard let url = url else { return UIImage(named: "emptyBottleOfWine")}
        let data = try? Data(contentsOf: url)
        if let data = data{
            return UIImage(data: data)
        }
        return UIImage(named: "emptyBottleOfWine")
    }
    func getImageByType(type: WineType) -> UIImage{
        switch type{
        case .red:
            return UIImage(named: "red")!
        case .white:
            return UIImage(named: "white")!
        case .sparkling:
            return UIImage(named: "sparkling")!
        case .rose:
            return UIImage(named: "rose")!
        case .dessert:
            return UIImage(named: "dessert")!
        case .port:
            return UIImage(named: "port")!
        }}
}
