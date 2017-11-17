//
//  Game.swift
//  Tic-Tac-Toe
//
//  Created by Amit on 17/11/17.
//  Copyright © 2017 Amit. All rights reserved.
//

import Foundation

class Game
{
    let id: UUID
    var state: GameState
    var history: [Move] = []
    
    let player1: Player
    let player2: Player
    
    init(id: UUID = UUID(), p1: Player, p2: Player)
    {
        self.id = id
        state = GameState()
        player1 = p1
        player2 = p2
    }
    
    func makeMoveOn(row: Int, column: Int) -> Move
    {
        guard row <= 2, column <= 2 else
        {
            fatalError("Invalid position received")
        }
        
        let move = Move(sign: state.nextTurn, position: (row, column))
        state.makeMove(move)
        history.append(move)
        return move
    }
    
    func undoLastMove() -> Move?
    {
        guard let lastMove = history.last else
        {
            print("History is empty")
            return nil
        }
        
        state.undoMove(lastMove)
        return history.popLast()
    }
    
    func reset()
    {
        state = GameState()
        history = []
    }
}
