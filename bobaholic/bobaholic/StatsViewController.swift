//
//  StatsViewController.swift
//  bobaholic
//

import UIKit
import CoreData

// Resource:
// https://www.techotopia.com/index.php/An_iOS_7_Storyboard-based_Collection_View_Tutorial
class StatsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var year: UITextField!
    
    // Reference:
    // https://stackoverflow.com/questions/31952064/dismissing-the-keyboard-when-a-button-is-pressed-programmatically-with-swift
    @IBAction func getStatsButton(_ sender: UIButton) {
        self.view.endEditing(true)
        self.viewDidLoad()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
      numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell =
               collectionView.dequeueReusableCell(withReuseIdentifier:
                    "yearDrinks", for: indexPath) as! StatsCollectionViewCell
            
            cell.drinkDesc.text = "# DRINKS IN " + year.text!
            cell.yearDrinks.text = String((fetchedResultController.sections?[0].numberOfObjects)!)
            return cell
        }
        else {
            let cell =
               collectionView.dequeueReusableCell(withReuseIdentifier:
                    "yearMoney", for: indexPath) as! StatsCollectionViewCell

            cell.moneyDesc.text = "MONEY SPENT IN " + year.text!
            print(fetchedResultController)
            let numObj = (fetchedResultController.sections?[0].numberOfObjects)!
            var money = 0.0
            if numObj == 0 {
                cell.yearMoney.text = "$0.00"
            }
            else {
                for i in 0...(numObj-1) {
                    let order = fetchedResultController.object(at: IndexPath(row: i, section: 0)) as! Order
                    money += order.drink!.price
                }
                
                cell.yearMoney.text = "$" + String(money)
            }
            
            
            return cell
        }
    }
    
    // MARK: - Get Core Data
    func getFetchedResultController() -> NSFetchedResultsController<NSFetchRequestResult> {
        fetchedResultController = NSFetchedResultsController(fetchRequest: orderFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func orderFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        let predicate = NSPredicate(format: "date BEGINSWITH %@", year.text! + "-")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {}
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }

}
