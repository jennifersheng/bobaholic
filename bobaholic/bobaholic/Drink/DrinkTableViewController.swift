//
//  DrinkTableViewController.swift
//  bobaholic
//

import UIKit
import CoreData

// Resource:
// https://rshankar.com/coredata-tutoiral-in-swift-using-nsfetchedresultcontroller/
class DrinkTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    
    @IBAction func drinkTableBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var shop:Shop?
    @IBOutlet weak var shopNameTitle: UILabel!
    @IBOutlet weak var shopImage: UIImageView!
    
    // MARK: - Setting up Table View
    @IBOutlet weak var tableView: UITableView!
    
    // Reference:
    // https://letcreateanapp.com/2021/04/15/how-to-create-uitableview-with-sections-in-swift-5/
    // sets number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchedResultController.sections?.count)!
    }
    
    // sets number of rows in each section of the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultController.sections?[section].numberOfObjects)!
    }
    
    // Resource:
    // https://cb510.medium.com/saving-images-to-core-data-in-ios-473b92d5fd4f
    // displays relevant data of each shop
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set cell view based on its completion status
        let cell = tableView.dequeueReusableCell(withIdentifier: "drink", for: indexPath as IndexPath) as! DrinkTableViewCell
        let drink = fetchedResultController.object(at: indexPath as IndexPath) as! Drink
        cell.drinkName?.text = drink.name
        
        if drink.price == 0.0 {
            cell.drinkPrice.text = "$ -"
        }
        else {
            cell.drinkPrice.text = "$" + String(drink.price)
        }
        
        return cell
    }
    
    // unhighlights the selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Drink")
        let predicate = NSPredicate(format: "shop = %@", shop!)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "addDrinkSegue"){
            let drinkController: AddDrinkViewController = segue.destination as! AddDrinkViewController
            drinkController.shop = shop!
        }
        if (segue.identifier == "drinkDetailSegue"){
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let drinkController:DrinkDetailsViewController = segue.destination as! DrinkDetailsViewController
            let drink:Drink = fetchedResultController.object(at: indexPath!) as! Drink
            drinkController.drink = drink
        }
        if (segue.identifier == "editShopSegue") {
            let shopController:EditShopViewController = segue.destination as! EditShopViewController
            shopController.vc = self
            shopController.shop = shop!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shopImage.image = UIImage(data: (shop?.image)!)
        shopNameTitle.text = (shop?.name)! + " Drinks"
        
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "drink")
        
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
