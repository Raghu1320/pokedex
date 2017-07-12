//
//  MoveCell.swift
//  Pokedex
//
//  Created by Raghu on 7/12/17.
//  Copyright © 2017 Raghu. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell {

    @IBOutlet weak var moveLbl: UILabel!
    
    var pokemon: Pokemon!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(pokemon: Pokemon, moveIndex: Int) {
        self.pokemon = pokemon
        moveLbl.text = "\(pokemon.moves[moveIndex]) - \(pokemon.moveLearnTypes[moveIndex])"
    }

}
