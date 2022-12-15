//
//  EditDrinkViewController.swift
//  bobaholic
//

import UIKit
import CoreData

class EditDrinkViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    // Reference:
    // https://stackoverflow.com/questions/28760541/programmatically-go-back-to-previous-viewcontroller-in-swift
    @IBAction func editDrinkCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var detailVC:UIViewController?
    var detailVCTable:UITableView?
    
    var drink:Drink?
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkName: UITextView!
    @IBOutlet weak var drinkRating: UITextField!
    @IBOutlet weak var drinkPrice: UITextField!
    
    // Reference:
    // https://daddycoding.com/2017/09/14/ios-tutorials-images-albumcamera/
    @IBOutlet weak var editDrinkImage: UIImageView!
    var imagePicker: UIImagePickerController!
    @IBAction func editDrinkButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Select Your Image", message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Take a Picture", style: .default, handler: {
            (action) -> Void in
            self.useCamera()
        })
        
        let album = UIAlertAction(title: "Select from Library", style: .default, handler: {
            (action) ->Void in
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action) -> Void in
        })
        
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func useCamera() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            editDrinkImage.image = image
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "editDrink2Segue"){
            let drinkController: EditDrink2ViewController = segue.destination as! EditDrink2ViewController
            drinkController.detailVC = detailVC
            drinkController.detailVCTable = detailVCTable!
            drinkController.prevVC = self
            drinkController.drink = drink!
            drinkController.drinkImage = drinkImage.image!
            drinkController.drinkName = drinkName.text!
            drinkController.drinkRating = drinkRating.text!
            drinkController.drinkPrice = drinkPrice.text!
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
        drinkRating.text = String(drink!.rating)
        drinkPrice.text = String(drink!.price)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    } 

}
