//
//  ButtonSaveProtocol.swift
//  CourseProject
//
//  Created by Allan on 15.02.23.
//

import Foundation
protocol ButtonSaveDelegate{
    func buttonFavDidTap(wineName: String, addToFav: Bool)
    func buttonTryDidTap(wineName: String,addToTryLater: Bool)
}
