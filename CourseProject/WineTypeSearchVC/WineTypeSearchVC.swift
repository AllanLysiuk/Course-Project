//
//  WineTypeSearchVC.swift
//  CourseProject
//
//  Created by Allan on 28.01.23.
//

import Foundation
import UIKit
final class WineTypeSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet private weak var tableView: UITableView!
    
    var selectedTypeOfWine: WineType!
    private var wayOfSorting: WayOfSorting = .highToLow
    private lazy var pullDownButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Sort By", image: nil, primaryAction: nil, menu: menu)
        return button
    }()
    private lazy var menu = UIMenu(title: "Options", children: elements)
    private lazy var elements: [UIAction] = [sortByIncreasingRating, sortByDecreasingRating, sortByAlphabetAZ, sortByAlphabetZA ]
    private lazy var sortByIncreasingRating = UIAction(title: "Sort from low to high", image: UIImage(systemName: "arrow.up.square"), attributes: [], state: .off) { action in
        self.wayOfSorting = .lowToHigh
        self.tableView.reloadData()
    }
    private lazy var sortByDecreasingRating = UIAction(title: "Sort from high to low", image: UIImage(systemName: "arrow.down.square"), attributes: [], state: .off) { action in
        self.wayOfSorting = .highToLow
        self.tableView.reloadData()
    }
    private lazy var sortByAlphabetAZ = UIAction(title: "Sort by alphabet A-Z", image: UIImage(systemName: "textformat.abc"), attributes: [], state: .off) { action in
        self.wayOfSorting = .alphabetAZ
        self.tableView.reloadData()
    }
    private lazy var sortByAlphabetZA = UIAction(title: "Sort by alphabet Z-A", image: UIImage(systemName: "textformat.abc"), attributes: [], state: .off) { action in
        self.wayOfSorting = .alphabetZA
        self.tableView.reloadData()
    }

    private var selectedWinesByType: [Wine] = [] 
    private let repoService = RepositoryService()
    private let imageService = ImageService()
    private let sortingService = SortingService()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCells()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.rightBarButtonItems = [pullDownButton]
       // selectedWinesByType = repoService.loadWinesByType(type: selectedTypeOfWine, fetchtOffset: 0, wayOfSorting: .highToLow)
    }
    private func registerCells(){
        let nib1 = UINib(nibName: "\(WineInfoTableViewCell.self)", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "\(WineInfoTableViewCell.self)")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedWinesByType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WineInfoTableViewCell.self)") as? WineInfoTableViewCell
//        selectedWinesByType.append(contentsOf: repoService.loadWinesByType(type: selectedTypeOfWine, fetchtOffset: selectedWinesByType.count))
        let wine = selectedWinesByType[indexPath.row]
        cell?.isFavorite = wine.isFavorite
        cell?.tryLater = wine.isSaved
        cell?.delegate = self
        cell?.nameLabel.text = wine.wine
        cell?.avgRatingLabel.text = "\(wine.averageRating)"
        cell?.locationLabel.text = wine.location
        cell?.reviewsLabel.text = wine.reviews
        cell?.wineImage.image = imageService.downloadImage(url: wine.image)
        cell?.wineryLabel.text = wine.winery
        return cell ?? UITableViewCell()
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 246
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height - scrollView.contentOffset.y < 1000 {
           let newWines = repoService.loadWinesByType(type: selectedTypeOfWine, fetchtOffset: selectedWinesByType.count, wayOfSorting: wayOfSorting)
            selectedWinesByType.append(contentsOf: newWines)
            tableView.reloadData()
        }
    }

}

extension WineTypeSearchVC: ButtonSaveDelegate{
    func buttonFavDidTap(wineName: String, addToFav: Bool) {
        print("Favourite Did Tap with name of Wine \(wineName) and bool \(addToFav)")
        repoService.addWineToFav(name: wineName, isFavorite: addToFav)
    }
    
    func buttonTryDidTap(wineName: String, addToTryLater: Bool) {
        print("Try Later Did Tap with name of Wine \(wineName) and bool \(addToTryLater)")
        repoService.addWineToTryLater(name: wineName, tryLater: addToTryLater)
    }
}

