//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Raghu on 7/11/17.
//  Copyright © 2017 Raghu. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var firstStack: UIStackView!
    
    @IBOutlet weak var secondStack: UIStackView!
    
    @IBOutlet weak var divider: UIView!
    
    @IBOutlet weak var thirdStack: UIStackView!
    
    @IBOutlet weak var fourthStack: UIStackView!
    
    @IBOutlet weak var evoView: UIView!
    
    @IBOutlet weak var fifthStack: UIStackView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var typeLbl: UILabel!
    
    @IBOutlet weak var defenseLbl: UILabel!
    
    @IBOutlet weak var heightLbl: UILabel!
    
    @IBOutlet weak var pokedexLbl: UILabel!
    
    @IBOutlet weak var weightLbl: UILabel!
    
    @IBOutlet weak var attackLbl: UILabel!
    
    @IBOutlet weak var currentEvoImg: UIImageView!
    
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    @IBOutlet weak var evoLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        nameLbl.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        pokemon.downloadPokemonDetails {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        pokedexLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionText)"
            
            if pokemon.nextEvolutionLvl != "" {
                str = str + " - LVL \(pokemon.nextEvolutionLvl)"
            }
            evoLbl.text = str
        }
        print(pokemon.moves)
        print(pokemon.moveLearnTypes)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            
            firstStack.isHidden = false
            secondStack.isHidden = false
            thirdStack.isHidden = false
            divider.isHidden = false
            fourthStack.isHidden = false
            evoView.isHidden = false
            fifthStack.isHidden = false
            tableView.isHidden = true
            
        case 1:
            
            firstStack.isHidden = true
            secondStack.isHidden = true
            thirdStack.isHidden = true
            divider.isHidden = true
            fourthStack.isHidden = true
            evoView.isHidden = true
            fifthStack.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
            
        default:
            
            break
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MoveCell") as? MoveCell {
            cell.configureCell(pokemon: self.pokemon, moveIndex: indexPath.row)
            return cell
        } else {
            return MoveCell()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.moves.count
    }
    
    

}
