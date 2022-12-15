//
//  ViewController.swift
//  bobaholic
//

import UIKit
import CoreData

// Resource:
// https://rshankar.com/coredata-tutoiral-in-swift-using-nsfetchedresultcontroller/
class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    
    // MARK: - Setting up Table View
    
    @IBOutlet weak var tableView: UITableView!
    
    // Reference:
    // https://letcreateanapp.com/2021/04/15/how-to-create-uitableview-with-sections-in-swift-5/
    // sets number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchedResultController.sections?.count)!
    }
    
    // sets number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultController.sections?[section].numberOfObjects)!
    }
    
    // Resource:
    // https://cb510.medium.com/saving-images-to-core-data-in-ios-473b92d5fd4f
    // displays relevant data of each shop
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shop2", for: indexPath as IndexPath) as! MainTableViewCell
        let shop = fetchedResultController.object(at: indexPath as IndexPath) as! Shop
//        cell.mainImage?.image = UIImage(named:"PlaceholderImage")
//        cell.mainImage?.image = UIImage(data: shop.image!)
//        cell.mainShopName?.text = shop.name!
        cell.shopName2?.text = shop.name!
        return cell
    }

    // unhighlights the selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // deletes shop that is swiped to deleted on
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let managedObject:NSManagedObject = fetchedResultController.object(at: indexPath as IndexPath) as! NSManagedObject
        managedObjectContext.delete(managedObject)
        do {
            try managedObjectContext.save()
        } catch _ {
        }
    }
    
    // MARK: - Getting Core Data
    
    func getFetchedResultController() -> NSFetchedResultsController<NSFetchRequestResult> {
        fetchedResultController = NSFetchedResultsController(fetchRequest: shopFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func shopFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shop")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "drinkTableSegue") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let drinkController:DrinkTableViewController = segue.destination as! DrinkTableViewController
            let shop:Shop = fetchedResultController.object(at: indexPath!) as! Shop
            drinkController.shop = shop
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "shop")
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {}
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    

}

