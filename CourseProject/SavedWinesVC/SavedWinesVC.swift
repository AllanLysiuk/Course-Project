//
//  SavedWinesVC.swift
//  CourseProject
//
//  Created by Allan on 15.02.23.
//

import Foundation
import UIKit

final class SavedWinesVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var hintLabel: UILabel!
    
    private var arrOfSavedWines: [Wine] = []
    private let imageService = ImageService()
    private let repoService = RepositoryService()
    var typeOfSavingCategory: TypeOfSavingWine! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        registerCells()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if typeOfSavingCategory == .favorite{
            arrOfSavedWines = repoService.loadFavWines()
        }else{
            arrOfSavedWines = repoService.loadTryLaterWines()
        }
        if arrOfSavedWines.isEmpty{
            hintLabel.isHidden = false
            
        }else{
            hintLabel.isHidden = true
        }
    }
    
    private func registerCells(){
        let nib = UINib(nibName: "\(WineInfoTableViewCell.self)", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "\(WineInfoTableViewCell.self)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfSavedWines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WineInfoTableViewCell.self)") as? WineInfoTableViewCell
        let wine = arrOfSavedWines[indexPath.row]
        let checkFlag = checkIfWineRefersToBothCategories(name: wine.wine ?? "")
        if checkFlag {
            cell?.isFavorite = true
            cell?.tryLater = true
        }else{
        if typeOfSavingCategory == .favorite{
            cell?.isFavorite = true
        }else {
            cell?.tryLater = true
        }}
        cell?.delegate = self
        cell?.nameLabel.text = wine.wine
        cell?.avgRatingLabel.text = "\(wine.averageRating)"
        cell?.locationLabel.text = wine.location
        cell?.reviewsLabel.text = wine.reviews
        cell?.wineImage.image = imageService.downloadImage(url: wine.image)
        cell?.wineryLabel.text = wine.winery
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 246
    }
    
    func checkIfWineRefersToBothCategories(name: String) -> Bool{
        let isFav = repoService.isWineAddedToFav(name: name)
        let isSaved = repoService.isWineAddedToTryLater(name: name)
        if isFav && isSaved{
            return true
        }
        return false
    }
}
extension SavedWinesVC: ButtonSaveDelegate{
    func buttonFavDidTap(wineName: String, addToFav: Bool) {
        print("Favourite Did Tap with name of Wine \(wineName) and bool \(addToFav)")
        repoService.addWineToFav(name: wineName, isFavorite: addToFav)
    }
    
    func buttonTryDidTap(wineName: String, addToTryLater: Bool) {
        print("Try Later Did Tap with name of Wine \(wineName) and bool \(addToTryLater)")
        repoService.addWineToTryLater(name: wineName, tryLater: addToTryLater)
    }
}


