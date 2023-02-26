//
//  SearchBarCVCell.swift
//  CourseProject
//
//  Created by Allan on 30.01.23.
//

import Foundation
import UIKit

final class SearchBarVCCell: UICollectionViewCell, UISearchBarDelegate{
    @IBOutlet weak var backgroundImage: UIImageView!{
        didSet{
            self.backgroundImage.contentMode = .scaleToFill
            self.backgroundImage.image = UIImage(named: "barrel")
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            self.searchBar.isUserInteractionEnabled = false
        }
    }
}
