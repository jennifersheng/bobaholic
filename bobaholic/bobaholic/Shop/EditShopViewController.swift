//
//  EditShopViewController.swift
//  bobaholic
//

import UIKit
import CoreData

class EditShopViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var shop:Shop?
    var vc:UIViewController?
    
    // Reference:
    // https://stackoverflow.com/questions/28760541/programmatically-go-back-to-previous-viewcontroller-in-swift
    @IBAction func editShopCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Reference:
    // https://rshankar.com/coredata-tutoiral-in-swift-using-nsfetchedresultcontroller/
    // https://cb510.medium.com/saving-images-to-core-data-in-ios-473b92d5fd4f
    // https://developer.apple.com/forums/thread/25521
    @IBAction func editShopSaveButton(_ sender: UIBarButtonItem) {
        shop?.image = editShopImage.image!.jpegData(compressionQuality: 1.0)
        shop?.name = editShopName.text!
        do {
            try managedObjectContext.save()
        } catch _ {}
        self.dismiss(animated: true, completion: nil)
        vc?.viewDidLoad()
    }

    // Reference:
    // https://daddycoding.com/2017/09/14/ios-tutorials-images-albumcamera/
    @IBOutlet weak var editShopImage: UIImageView!
    var imagePicker: UIImagePickerController!
    @IBAction func editPhotoButtonPressed(_ sender: Any) {
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
    
    // get picture from camera
    func useCamera() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    // get picture from photo library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            editShopImage.image = image
        }
    }

    @IBOutlet weak var editShopName: UITextView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        editShopName.text = shop!.name
        editShopImage.image = UIImage(data: shop!.image!)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }

}
