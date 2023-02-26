//
//  WineInfoTableViewCell.swift
//  CourseProject
//
//  Created by Allan on 28.01.23.
//

import Foundation
import UIKit

final class WineInfoTableViewCell: UITableViewCell{
    @IBOutlet weak var wineryLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var avgRatingLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    
    @IBOutlet weak var wineImage: UIImageView!
    @IBOutlet private weak var buttonFav: UIButton!{
        didSet{
            buttonFav.tintColor = .systemGreen
        }
    }
    @IBOutlet weak var buttonTryLater: UIButton!{
        didSet{
            buttonTryLater.tintColor = .systemGreen
        }
    }

    
    var delegate: ButtonSaveDelegate?
    var isFavorite: Bool = false{
        didSet{
            if !isFavorite{
                self.buttonFav.tintColor = .systemGreen
            }else{
                self.buttonFav.tintColor = .systemRed
            }
        }
    }
    var tryLater: Bool = false{
        didSet{
            if !tryLater{
                self.buttonTryLater.tintColor = .systemGreen
            }else{
                self.buttonTryLater.tintColor = .systemRed
            }
        }}
    
   
    @IBAction private func saveToFavDidTap(){
        if self.buttonFav.tintColor == .systemGreen{
            delegate?.buttonFavDidTap(wineName: self.nameLabel.text ?? "",addToFav: true )
            self.buttonFav.tintColor = .systemRed
        }else{
            delegate?.buttonFavDidTap(wineName: self.nameLabel.text ?? "", addToFav: false )
            self.buttonFav.tintColor = .systemGreen
        }
    }
    @IBAction private func saveToTryLaterDidTap(){
        if self.buttonTryLater.tintColor == .systemGreen{
            delegate?.buttonTryDidTap(wineName: self.nameLabel.text ?? "",addToTryLater: true )
            self.buttonTryLater.tintColor = .systemRed
        }else{
            delegate?.buttonTryDidTap(wineName: self.nameLabel.text ?? "", addToTryLater: false )
            self.buttonTryLater.tintColor = .systemGreen
        }
    }
}
