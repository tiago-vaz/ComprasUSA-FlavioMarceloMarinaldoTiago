//
//  StateTableViewCell.swift
//  FlavioMarceloMarinaldoTiago
//
//  Created by Flavio Caruso, Marcelo Mussi, Marinaldo Ferreira and Tiago Vaz on 16/02/23.
//

import UIKit

class StateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbTax: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

