//
//  TaxesViewController.swift
//  FlavioMarceloMarinaldoTiago
//
//  Created by Flavio Caruso, Marcelo Mussi, Marinaldo Ferreira and Tiago Vaz on 16/02/23.
//


import UIKit
import CoreData


var data: [Product] = []

    class TotalViewController: UIViewController {
        
        @IBOutlet weak var lbTotalUSD: UILabel!
        @IBOutlet weak var lbTotalBRL: UILabel!

        var quota: Double = 0
        var iof: Double = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            loadProdutos()
            var totalGrossValue: Double = 0
            var totalNetValue: Double = 0
            for product in data {
                totalGrossValue += product.value
                totalNetValue += calculateTotal(product)
            }
            
            lbTotalUSD.text = totalGrossValue.usdValue()
            lbTotalBRL.text = totalNetValue.brlValue()
        }
        
        func loadProdutos() {
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            do {
               data = try context.fetch(fetchRequest)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func calculateTotal(_ product: Product) -> Double {
            
            let quotation = UserDefaults.standard.double(forKey: "dolar_preference")
            let iof = UserDefaults.standard.double(forKey: "iof_preference")
            let stTaxes: Double
            let totalDolarTaxes: Double
            var totalBRLValue: Double
            
            enum Optional<T> {
                case None
                case Some(T)
                
                init(_ value: T) {
                    self = .Some(value)
                }
                
                init() {
                    self = .None
                }
            }

            if Int(product.states!.taxes) > 0  {
                stTaxes = product.states!.taxes
                print("Valor do imposto : \(stTaxes)")
                print("Valor do produto : \(product.value)")
                totalDolarTaxes = ((product.states!.taxes/100) * product.value) + product.value
            } else {
                totalDolarTaxes = product.value
            }
            
            print("Valor total em dolar com imposto: \(totalDolarTaxes)")

            totalBRLValue = totalDolarTaxes * quotation
            print("Valor em reais: \(totalBRLValue)")
            
            let totalBRLTaxes = product.card ? totalBRLValue + ((iof/100) * totalBRLValue)  : totalBRLValue
            print("Valor total em reais incluindo impostos: \(totalBRLTaxes)")
            
            return totalBRLTaxes
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
       
}
