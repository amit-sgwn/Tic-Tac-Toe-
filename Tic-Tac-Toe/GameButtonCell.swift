//
//  GameButtonCell.swift
//  Tic-Tac-Toe
//
//  Created by Amit on 17/11/17.
//  Copyright © 2017 Amit. All rights reserved.
//

import UIKit

class GameButtonCell: UICollectionViewCell
{
    @IBOutlet private weak var imageView: UIImageView!
    
    func display(_ sign: Sign?)
    {
        if let sign = sign
        {
            if sign == .cross
            {
                imageView.image = #imageLiteral(resourceName: "image_x")
            }
            else
            {
                imageView.image = #imageLiteral(resourceName: "image_o")
            }
        }
        else
        {
            imageView.image = nil
        }
    }
}
