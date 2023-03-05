//  AddProductViewController.swift
//  FlavioMarceloMarinaldoTiago
//
//  Created by Flavio Caruso, Marcelo Mussi, Marinaldo Ferreira and Tiago Vaz on 16/02/23.
//

import CoreData
import UIKit
@objcMembers
class AddProductViewController: UIViewController {
    
    
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfProductState: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    @IBOutlet weak var btAddProduct: UIButton!

   
    var pickerView: UIPickerView!
    var product: Product!
    var smallImage: UIImage!
    var dataSource: [State] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btAddProduct.isEnabled = false
        btAddProduct.backgroundColor = .gray
        
        tfProductName.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        tfProductState.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        tfValue.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        tfValue.keyboardType = .decimalPad
        
        
        if product != nil{
            tfProductName.text = product.name
            tfProductState.text = product.states?.name
            tfValue.text = String( product.value )
            swCard.setOn(product.card, animated: false)
            btAddProduct.setTitle("Atualizar", for: .normal)
            if let image = product.title as? UIImage {
                ivImage.image = image
            }
            
            btAddProduct.isEnabled = true
            btAddProduct.backgroundColor = .blue
        }
        setupPickerView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddProductViewController.handleTap))
        ivImage.addGestureRecognizer(tapGesture)
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        
    }
    
    deinit {
        tfProductName.removeTarget(self, action: #selector(editingChanged), for: .editingChanged)
        tfProductState.removeTarget(self, action: #selector(editingChanged), for: .editingChanged)
        tfValue.removeTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    func editingChanged(_ textField: UITextField) {
        guard
            let nomeProduto = tfProductName.text, !nomeProduto.isEmpty,
            let estadoProduto = tfProductState.text, !estadoProduto.isEmpty,
            let valor = tfValue.text, !valor.isEmpty
            else {
                btAddProduct.isEnabled = false
                btAddProduct.backgroundColor = .gray
                return
        }
        btAddProduct.isEnabled = true
        btAddProduct.backgroundColor = .blue
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadState()
    }
    
    func loadState() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        tfProductState.inputView = pickerView
        tfProductState.inputAccessoryView = toolbar
    }
    
    func cancel() {
        tfProductState.resignFirstResponder()
    }
    
    func done() {
        tfProductState.text = dataSource[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
  func handleTap() {
        let alert = UIAlertController(title: "Selecionar foto", message: "De onde você quer escolher a foto?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addProduto(_ sender: Any) {
        if product == nil { product = Product(context: context) }
        product.name = tfProductName.text
        product.title = ivImage.image
        if let indexState = dataSource.index(where: { $0.name  == tfProductState.text!}) {
            product.states = dataSource[indexState]
        }
        product.value = Double( tfValue.text! )!
        product.card = swCard.isOn
        if smallImage != nil {
            product.title = smallImage
        }
        do {
            print("Label estado:  \(tfProductState.text!)")
            print("CodeData estado:  \(product.states!)")
            
            try context.save()
            
            close()
        } catch {
            print(error.localizedDescription)
            close()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivImage.image = smallImage
        dismiss(animated: true, completion: nil)
    }
}

extension AddProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].name
    }
}

extension AddProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}

