//
//  OrderViewController.swift
//  bobaholic
//

import UIKit
import CoreData

// Resource:
// https://rshankar.com/coredata-tutoiral-in-swift-using-nsfetchedresultcontroller/
class OrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
        
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Setting up Table View
    
    // Reference:
    // https://letcreateanapp.com/2021/04/15/how-to-create-uitableview-with-sections-in-swift-5/
    // sets number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchedResultController.sections?.count)!
    }
    
    // sets number of rows in each section to be the number of items in the coressponding completion category
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultController.sections?[section].numberOfObjects)!
    }
    
    // Resource:
    // https://cb510.medium.com/saving-images-to-core-data-in-ios-473b92d5fd4f
    // displays relevant data of each shop
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set cell view based on its completion status
        let cell = tableView.dequeueReusableCell(withIdentifier: "order2", for: indexPath as IndexPath) as! OrderTableViewCell
        let order = fetchedResultController.object(at: indexPath as IndexPath) as! Order
        
//        cell.drinkName?.text = order.drink?.name!
//        cell.shopName?.text = order.drink?.shop?.name!
//        cell.date?.text = order.date!
        cell.orderName?.text = (order.drink?.name)! + "\n" + (order.drink?.shop?.name)!
        cell.orderDate?.text = order.date!
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
        fetchedResultController = NSFetchedResultsController(fetchRequest: orderFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func orderFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "editOrderSegue") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let orderController:EditOrderViewController = segue.destination as! EditOrderViewController
            let order:Order = fetchedResultController.object(at: indexPath!) as! Order
            orderController.order = order
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
//        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "order")
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {}
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
