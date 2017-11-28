//
//  Game Entities.swift
//  Tic-Tac-Toe
//
//  Created by Amit on 17/11/17.
//  Copyright © 2017 Amit. All rights reserved.
//

import Foundation

struct GameState: CustomStringConvertible
{
    private var state : [[Sign?]]
    private(set) var nextTurn: Sign
    
    init()
    {
        state = Array(repeating: [nil, nil, nil], count: 3)
        nextTurn = .cross
    }
    
    subscript(_ row: Int, _ column: Int) -> Sign?
    {
        return state[row][column]
    }
    
    mutating func makeMove(_ move: Move)
    {
        guard state[move.position.row][move.position.column] == nil, nextTurn == move.sign else
        {
            fatalError("Row/Coumn already filled")
        }
        
        state[move.position.row][move.position.column] = move.sign
        nextTurn.toggle()
    }
    
    mutating func undoMove(_ move: Move)
    {
        guard state[move.position.row][move.position.column] != nil, nextTurn != move.sign else
        {
            fatalError("Row/Coumn already filled")
        }
        
        state[move.position.row][move.position.column] = nil
        nextTurn.toggle()
    }
    
    var isComplete: Bool
    {
        return getWinner() != nil || isDraw()
    }
    
    func getWinner() -> Sign?
    {
        for i in 0..<3
        {
            if state[i][0] == state[i][1], state[i][0] == state[i][2]
            {
                return state[i][0]
            }
            else if state[0][i] == state[1][i], state[0][i] == state[2][i]
            {
                return state[0][i]
            }
        }
        
        if state[0][0] == state[1][1], state[1][1] == state[2][2]
        {
            return state[0][0]
        }
        else if state[0][2] == state[1][1], state[1][1] == state[2][0]
        {
            return state[0][2]
        }
        else
        {
            return nil
        }
    }
    
    func isDraw() ->Bool
    {
        let isAnyCellEmpty = state.flatMap({$0}).flatMap({$0}).count != 9
        return !isAnyCellEmpty && getWinner() == nil
    }
    
    var description: String
    {
        var s = ""
        
        for row in 0..<3
        {
            for column in 0..<3
            {
                s += state[row][column]?.description ?? " "
                s += ", "
            }
            s += "\n"
        }
        return s
    }
}

enum Sign: CustomStringConvertible
{
    case circle, cross
    
    mutating func toggle()
    {
        if self == .circle
        {
            self = .cross
        }
        else
        {
            self = .circle
        }
    }
    
    var description: String
    {
        if self == .circle
        {
            return "Circle"
        }
        else
        {
            return "Cross"
        }
    }
}

class Player
{
    let id: NSUUID? = nil
    let name : String
    let sign: Sign
    
    init(_ name : String, _ sign : Sign)
    {
        self.name = name
        self.sign = sign

    }
    
    init(from dict: NSDictionary)
    {
        name = dict["name"] as! String
        sign = dict["Sign"] as? String == "Circle" ? .circle : .cross
    }
    
    var isEmpty: Bool {
        get {
            return self.name == nil && self.sign == nil
        }
    }
}

struct Move
{
    let sign: Sign
    let position: (row: Int, column: Int)
}


class GameInfo {
    var game : Game
    var player : Player    // since  we will send this instance to other player so we don't need other player's info
    var fcmtoken : String
    
    init(game:Game,player:Player,fcmtoken:String){
        self.fcmtoken = fcmtoken
        self.game = game
        self.player = player
    }
}
