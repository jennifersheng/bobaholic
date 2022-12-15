//
//  EditOrderViewController.swift
//  bobaholic
//

import UIKit

class EditOrderViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var order:Order!
    let df = DateFormatter()
    
    @IBOutlet weak var drink: UILabel!
    @IBOutlet weak var shop: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UIDatePicker!
    
    @IBAction func editOrderBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editOrderSaveButton(_ sender: Any) {
        df.dateFormat = "yyyy-MM-dd"
        order?.date = df.string(from: date.date)
        do {
            try managedObjectContext.save()
        } catch _ {}
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        df.dateFormat = "yyyy-MM-dd"
        
        drink.text = order.drink?.name
        shop.text = order.drink?.shop?.name
        if order.drink?.price == 0.0 {
            price.text = "$ -"
        }
        else {
            price.text = "$" + String(order.drink!.price)
        }
        date.date = df.date(from: order.date!)!
        
        date.maximumDate = Date()
    }

}
