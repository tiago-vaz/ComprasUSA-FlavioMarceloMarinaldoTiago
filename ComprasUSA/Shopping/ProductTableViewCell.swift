//
//  ProdutoTableViewCell.swift
//  FlavioMarceloMarinaldoTiago
//
//  Created by Flavio Caruso, Marcelo Mussi, Marinaldo Ferreira and Tiago Vaz on 16/02/23.
//

import UIKit

class ProdutoTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbYesNo: UILabel!
    @IBOutlet weak var ivTitle: UIImageView!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
