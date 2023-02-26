//
//  RepositoryService.swift
//  CourseProject
//
//  Created by Allan on 28.01.23.
//

import Foundation
import CoreData
final class RepositoryService{
    
    //let coreDataService = CoreDataStack()
    
    private var networkService = NetworkService()
    let arrOfWineTypes: [WineType] = [.red, .white, .sparkling, .rose, .dessert, .port]
    var dictOfWines: [String: [WineElement]] = [:]
    
    func updateCoreData(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        let currentStrDate = formatter.string(from: Date.now)
        let ud = UserDefaults()
        
        let dateStrOfPreviousSave = ud.string(forKey: "dateOfSave")
        
        if dateStrOfPreviousSave == nil{
            
            ud.set(currentStrDate, forKey: "dateOfSave")
        }else{
            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            
            guard let dateOfPreviousSave = formatter.date(from: dateStrOfPreviousSave!) else { return  }
            guard let currentDate = formatter.date(from: currentStrDate) else { return  }
            let passedTime = gregorian.components([.year], from: dateOfPreviousSave, to: currentDate as Date , options: [])

            if passedTime.month ?? 0 > 3{
                ud.set(currentStrDate, forKey: "dateOfSave")
                saveApiData()
            }
            
        }
    }
    
    func saveApiData(){
        let group = DispatchGroup()
        for elem in arrOfWineTypes{
            group.enter()
            networkService.loadWines(type: elem) { [weak self] arrOfWines in
                self?.dictOfWines["\(elem.rawValue)"] = arrOfWines
                group.leave()
            }
        }
        group.notify(queue: .main){
            self.dictOfWines.keys.forEach { type in
                self.saveInCoreDataWith(self.dictOfWines[type]!, type)
                   }
        }
        
    }
    private func saveInCoreDataWith(_ arr: [WineElement], _ type: String){
        let context = CoreDataStack.shared.backgroundContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        for elem in arr{
        context.perform {
            let newWine = Wine(context: context)
            newWine.typeOfWine = type
            newWine.location = elem.location
            newWine.wine = elem.wine
            newWine.winery = elem.winery
            newWine.image = URL(string: elem.image)
            newWine.averageRating = Float(elem.rating.average)!
            newWine.id = Int32(elem.id)
            newWine.isFavorite = false
            newWine.isSaved = false
            newWine.reviews = elem.rating.reviews
            
            CoreDataStack.shared.saveContext(context: context)
        }
        }
    }
    
     func loadInfo() -> [Wine]{
        let request = Wine.fetchRequest()
        request.returnsObjectsAsFaults = false
         let wines = try? CoreDataStack.shared.mainContext.fetch(request)
        return wines ?? []
        }

    func loadWinesByType(type: WineType, fetchtOffset: Int, wayOfSorting: WayOfSorting) -> [Wine] {
        let request = Wine.fetchRequest()
        request.predicate = NSPredicate(format: "\(#keyPath(Wine.typeOfWine)) == %@", type.rawValue)
        request.fetchLimit = 100
        request.fetchOffset = fetchtOffset
        request.sortDescriptors = getSortDescriptor(wayOfSorting: wayOfSorting)
        let wines = try? CoreDataStack.shared.mainContext.fetch(request)
        return wines ?? []
    }
    
    private func getSortDescriptor(wayOfSorting: WayOfSorting) -> [NSSortDescriptor]{
        switch wayOfSorting {
        case .lowToHigh:
            return [NSSortDescriptor.init(key: #keyPath(Wine.averageRating), ascending: true)]
        case .highToLow:
            return [NSSortDescriptor.init(key: #keyPath(Wine.averageRating), ascending: false)]
        case .alphabetAZ:
            return [NSSortDescriptor.init(key: #keyPath(Wine.wine), ascending: true)]
        case .alphabetZA:
           return [NSSortDescriptor.init(key: #keyPath(Wine.wine), ascending: false)]
        }
    }
    func loadWineByLetters(name: String) -> [Wine] {
        let fetchRequest: NSFetchRequest<Wine>
        fetchRequest = Wine.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            format: "wine CONTAINS[cd] %@", "\(name)"
        )
        // Get a reference to a NSManagedObjectContext
        let context = CoreDataStack.shared.mainContext
        // Perform the fetch request to get the objects
        // matching the predicate
        let wine = try? context.fetch(fetchRequest)
       return wine ?? []
       }
    func loadWineByName(name: String) -> Wine {
        let fetchRequest: NSFetchRequest<Wine>
        fetchRequest = Wine.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            format: "wine == %@", "\(name)"
        )
        // Get a reference to a NSManagedObjectContext
        let context = CoreDataStack.shared.backgroundContext
        // Perform the fetch request to get the objects
        // matching the predicate
        let wine = try? context.fetch(fetchRequest)
        return wine?.first ?? Wine()
       }
    
    func loadWinesByLocation(location: String)/* -> Wine*/ {
        let fetchRequest: NSFetchRequest<Wine>
        fetchRequest = Wine.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            format: "location CONTAINS %@ AND ", "\(location)"
        )
        let context = CoreDataStack.shared.mainContext
        let wine = try? context.fetch(fetchRequest)
        print( wine)
       }
    func loadWinesByRating(rating: Float,  fetchtOffset: Int) -> [Wine]{
        // MARK: add enum decreasing and increasing
        let fetchRequest: NSFetchRequest<Wine>
        fetchRequest = Wine.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            format: "averageRating >= %@", "\(rating)"
        )
        fetchRequest.fetchLimit = 4
        fetchRequest.fetchOffset = fetchtOffset
        let context = CoreDataStack.shared.mainContext
        let wines = try? context.fetch(fetchRequest)
        return wines ?? []
    }
    func loadFavWines() -> [Wine]{
        let fetchRequest: NSFetchRequest<Wine>
        fetchRequest = Wine.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            format: "isFavorite == YES"
        )
        let context = CoreDataStack.shared.mainContext
        let wines = try? context.fetch(fetchRequest)
        return wines ?? []
    }
    
    func loadTryLaterWines() -> [Wine]{
        let fetchRequest: NSFetchRequest<Wine>
        fetchRequest = Wine.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            format: "isSaved == YES"
        )
        let context = CoreDataStack.shared.mainContext
        let wines = try? context.fetch(fetchRequest)
        return wines ?? []
    }
    
    func addWineToFav(name: String, isFavorite: Bool){
        let wine = self.loadWineByName(name: name)
        let context = CoreDataStack.shared.backgroundContext
        context.perform {
            wine.isFavorite = isFavorite
            CoreDataStack.shared.saveContext(context: context)
        }
    }
    func addWineToTryLater(name: String, tryLater: Bool){
        let wine = self.loadWineByName(name: name)
        
        let context = CoreDataStack.shared.backgroundContext
        context.perform {
            wine.isSaved = tryLater
            CoreDataStack.shared.saveContext(context: context)
        }
    }
    
    func isWineAddedToFav(name: String) -> Bool{
        let fetchRequest: NSFetchRequest<Wine>
        fetchRequest = Wine.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            format: "wine == %@", "\(name)"
        )
        let context = CoreDataStack.shared.mainContext
        let wines = try? context.fetch(fetchRequest)
        if let wine = wines?.first {
            return wine.isFavorite
        }
        return false
    }
    func isWineAddedToTryLater(name: String) -> Bool{
        let fetchRequest: NSFetchRequest<Wine>
        fetchRequest = Wine.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(
            format: "wine == %@", "\(name)"
        )
        let context = CoreDataStack.shared.mainContext
        let wines = try? context.fetch(fetchRequest)
        if let wine = wines?.first {
            return wine.isSaved
        }
        return false
    }
}
