//
//  EditDrink2ViewController.swift
//  bobaholic
//

import UIKit

class EditDrink2ViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    // Reference:
    // https://stackoverflow.com/questions/28760541/programmatically-go-back-to-previous-viewcontroller-in-swift
    @IBAction func editDrinkBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
     
    var detailVC:UIViewController?
    var detailVCTable:UITableView?
    
    var prevVC:UIViewController?
    var drink:Drink?
    var drinkImage:UIImage?
    var drinkName = ""
    var drinkRating = ""
    var drinkPrice = ""
    @IBOutlet weak var drinkTopping: UITextField!
    @IBOutlet weak var drinkIcePref: UITextField!
    @IBOutlet weak var drinkSugarPref: UITextField!
    @IBOutlet weak var drinkNotes: UITextView!
    
    // Reference:
    // https://rshankar.com/coredata-tutoiral-in-swift-using-nsfetchedresultcontroller/
    // https://www.advancedswift.com/rounding-floats-and-doubles-in-swift/#rounding-2-decimal-places-hundredths-
    // https://developer.apple.com/forums/thread/25521
    @IBAction func editDrinkSaveButton(_ sender: UIBarButtonItem) {
        drink?.image = drinkImage?.jpegData(compressionQuality: 1.0)
        drink?.name = drinkName
        
        let drinkInput = (drinkRating as NSString).doubleValue
        if (drinkInput < 0.0) {
            drink?.rating = 0.0
        }
        else if (drinkInput > 5.0) {
            drink?.rating = 5.0
        }
        else {
            drink?.rating = drinkInput
        }
        
        let priceInput = round((drinkPrice as NSString).doubleValue * 100) / 100.0
        if (priceInput < 0.0) {
            drink?.price = 0.0
        }
        else {
            drink?.price = priceInput
        }
        
        drink?.toppings = drinkTopping.text!
        drink?.ice = drinkIcePref.text!
        drink?.sugar = drinkSugarPref.text!
        drink?.notes = drinkNotes.text!
        
        do {
            try managedObjectContext.save()
        } catch _ {}
        self.dismiss(animated: false, completion: nil)
        prevVC!.dismiss(animated: true, completion: nil)
        detailVC?.viewDidLoad()
        detailVCTable?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        drinkTopping.text = drink?.toppings
        drinkIcePref.text = drink?.ice
        drinkSugarPref.text = drink?.sugar
        drinkNotes.text = drink?.notes
    }

}
