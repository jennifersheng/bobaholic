//
//  AddDrinkViewController.swift
//  bobaholic
//

import UIKit
import CoreData

class AddDrink2ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    // Reference:
    // https://stackoverflow.com/questions/28760541/programmatically-go-back-to-previous-viewcontroller-in-swift
    @IBAction func addDrinkBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
    
    var prevVC:UIViewController?
    var shop:Shop?
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
    @IBAction func addDrinkSaveButton(_ sender: UIBarButtonItem) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Drink", in: managedObjectContext)
        let drink = Drink(entity: entityDescription!, insertInto: managedObjectContext)
        drink.image = drinkImage?.jpegData(compressionQuality: 1.0)
        drink.name = drinkName
        drink.shop = shop
        
        let drinkInput = (drinkRating as NSString).doubleValue
        if (drinkInput <= 0.0) {
            drink.rating = 0.0
        }
        else if (drinkInput > 5.0) {
            drink.rating = 5.0
        }
        else {
            drink.rating = drinkInput
        }
        
        let priceInput = round((drinkPrice as NSString).doubleValue * 100) / 100.0
        if (priceInput < 0.0) {
            drink.price = 0.0
        }
        else {
            drink.price = priceInput
        }
        
        drink.toppings = drinkTopping.text!
        drink.ice = drinkIcePref.text!
        drink.sugar = drinkSugarPref.text!
        drink.notes = drinkNotes.text!
        
        do {
            try managedObjectContext.save()
        } catch _ {}
        self.dismiss(animated: false, completion: nil)
        prevVC!.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
