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
    let size = 3*3
    private(set) var state: GameState
    var history: [Move] = []
    
    init(id: UUID = UUID())
    {
        self.id = id
        state = GameState()
    }
    
    @discardableResult
    func makeMoveOn(row: Int, column: Int) -> Move?
    {
        guard row <= 2, column <= 2, state[row, column] == nil else
        {
            print("Invalid position received")
            return nil
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
