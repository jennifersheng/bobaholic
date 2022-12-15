//
//  DrinkViewController.swift
//  bobaholic
//

import UIKit
import CoreData

class DrinkDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var drink:Drink?
    
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkRating: UILabel!
    @IBOutlet weak var drinkPrice: UILabel!
    
    @IBAction func drinkDetailsBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func drinkDetailsOrderButton(_ sender: Any) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Order", in: managedObjectContext)
        let order = Order(entity: entityDescription!, insertInto: managedObjectContext)
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        order.drink = drink
        order.date = df.string(from: Date())
        
        do {
            try managedObjectContext.save()
        } catch _ {}
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var tableView: UITableView!
    
    // sets number of sections in table to be one
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // sets number of rows in each section of the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // displays relevant data of each shop
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set cell view based on its completion status
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toppings", for: indexPath as IndexPath) as! DrinkDetailsTableViewCell
            cell.toppingsDetail?.text = drink?.toppings
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sugar", for: indexPath as IndexPath) as! DrinkDetailsTableViewCell
            cell.sugarDetail?.text = drink?.sugar
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ice", for: indexPath as IndexPath) as! DrinkDetailsTableViewCell
            cell.iceDetail?.text = drink?.ice
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notes", for: indexPath as IndexPath) as! DrinkDetailsTableViewCell
            cell.noteDetail?.text = drink?.notes
            return cell
        }
    }
    
    // unhighlights the selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "editDrinkSegue") {
            let drinkController:EditDrinkViewController = segue.destination as! EditDrinkViewController
            drinkController.detailVC = self
            drinkController.detailVCTable = tableView!
            drinkController.drink = drink!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drinkImage.image = UIImage(data: (drink?.image)!)
        drinkName.text = drink?.name
        
        if drink!.rating == 0.0 {
            drinkRating.text = "-"
        }
        else {
            drinkRating.text = String(drink!.rating)
        }
        
        if drink!.price == 0.0 {
            drinkPrice.text = "$ -"
        }
        else {
            drinkPrice.text = "$" + String(drink!.price)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "drink")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        print("here")
    }

}
