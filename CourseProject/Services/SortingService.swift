//
//  SortingService.swift
//  CourseProject
//
//  Created by Allan on 7.02.23.
//

import Foundation

final class SortingService{
     func sortByIncreasingRating(arr: inout [Wine]){
        arr.sort { w1, w2 in
            w1.averageRating < w2.averageRating
        }
    }
     func sortByDecreasingRating(arr: inout [Wine]){
        arr.sort { w1, w2 in
            w1.averageRating > w2.averageRating
        }
    }
    func sortByAlphabetAZ(arr: inout [Wine]){
        arr.sort { w1, w2 in
            w1.wine! < w2.wine!
        }
    }
    func sortByAlphabetZA(arr: inout [Wine]){
        arr.sort { w1, w2 in
            w1.wine! > w2.wine!
        }
    }
}
