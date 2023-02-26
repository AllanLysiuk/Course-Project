//
//  SearchBarVC.swift
//  CourseProject
//
//  Created by Allan on 8.02.23.
//

import Foundation
import UIKit

final class SearchBarVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!

//    weak var searchContainer: SearchBarController?
    private let repoService = RepositoryService()
    private let imageService = ImageService()
    var filteredWines: [Wine] = []
    var arrOfWines:[Wine] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool{
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name of wine"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.dataSource = self
        tableView.delegate = self
        registerCells()
        arrOfWines = repoService.loadWinesByRating(rating: 4.9, fetchtOffset: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    private func registerCells(){
        let nib1 = UINib(nibName: "\(WineInfoTableViewCell.self)", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "\(WineInfoTableViewCell.self)")
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  isFiltering{
            return filteredWines.count
        }
        return arrOfWines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WineInfoTableViewCell.self)") as? WineInfoTableViewCell
        let wine: Wine

        if isFiltering{
            wine = filteredWines[indexPath.row]
        }else{
            wine = arrOfWines[indexPath.row]
        }
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isFiltering{
        if scrollView.contentSize.height - scrollView.contentOffset.y < 1000 {
            let newWines = repoService.loadWinesByRating(rating: 4.9, fetchtOffset: arrOfWines.count)
            arrOfWines.append(contentsOf: newWines)
            tableView.reloadData()
        }
        }
    }
}

extension SearchBarVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filteredWines = repoService.loadWineByLetters(name: searchController.searchBar.text!)
        tableView.reloadData()
    }
}


//    private func filterContentForSearchText(_ searchText: String){
//        filteredWines = arrOfWines.filter({ wine in
//            return wine.wine?.lowercased().contains(searchText.lowercased()) ?? false
//        })
//        tableView.reloadData()
//    }


