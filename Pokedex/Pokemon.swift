//
//  Pokemon.swift
//  Pokedex
//
//  Created by Raghu on 7/7/17.
//  Copyright © 2017 Raghu. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int?
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    private var _moves: [String]!
    private var _moveLearnTypes: [String]!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId!
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var moves: [String] {
        if _moves == nil {
            _moves = []
        }
        return _moves
    }
    
    var moveLearnTypes: [String] {
        if _moveLearnTypes == nil {
            _moveLearnTypes = []
        }
        return _moveLearnTypes
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId!)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        let pokemonUrl = URL(string: _pokemonUrl)!
        Alamofire.request(pokemonUrl).responseJSON { response in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        
                        for x in (1..<types.count) {
                            if let name = types[x]["name"] {
                                self._type! = self._type! + "/\(name.capitalized)"
                            }
                        }
                        
                    }
                    
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        
                        let nsurl = URL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(nsurl).responseJSON { response in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                }
                                
                            }
                            
                            completed()
                        }
                    }
                    
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        //Can't support mega pokemon right now but api still has mega data
                        if to.range(of: "mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                
                                let num = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionText = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                if let moveArr = dict["moves"] as? [Dictionary<String, AnyObject>], moveArr.count > 0 {
                    
                    var moveList = [String]()
                    var methodList = [String]()
                    
                    for x in (0..<moveArr.count) {
                        
                        if let move = moveArr[x]["name"] {
                            moveList.append(move.capitalized!)
                        }
                        
                        if let type = moveArr[x]["learn_type"] {
                            methodList.append(type.capitalized!)
                        }
                        
                    }
                    self._moves = moveList
                    self._moveLearnTypes = methodList
                }

            }
        }
    }
}
