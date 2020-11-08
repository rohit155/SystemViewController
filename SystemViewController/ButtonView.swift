//
//  ButtonView.swift
//  SystemViewController
//
//  Created by Rohit Jangid on 05/11/20.
//

import UIKit

class ButtonView: UIButton {

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 5
        clipsToBounds = true
    }

}
