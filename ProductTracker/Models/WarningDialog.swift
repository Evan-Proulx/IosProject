//
//  WarningDialog.swift
//  ProductTracker
//
//  Created by Evan Proulx on 2024-11-14.
//


import Foundation
import UIKit

class WarningDialog: UIView {        
        var dialogTitle: NSString = "Invalid Code"
        var dialogFillColour = UIColor.red
        
        //Dialog styles
        override func draw(_ rect: CGRect) {
            let width: CGFloat = 200
            let height: CGFloat = 80
            
            let viewRect = CGRect(x: round(bounds.size.width - width) / 2, y: round(bounds.size.height-height) / 2, width: width, height: height)
            let insideRect = UIBezierPath(roundedRect: viewRect, cornerRadius: 5)
            dialogFillColour.setFill()
            insideRect.fill()
            
            guard let image = UIImage(systemName: "exclamationmark.triangle.fill")?.withTintColor(.white) else { return }
            image.draw(in: CGRect(x: center.x - 15, y: center.y - 30, width: 30, height: 30))
            
            let attributes = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
            
            let textSize = dialogTitle.size(withAttributes: attributes)
            let textPoint = CGPoint(x: center.x - (textSize.width/2), y: center.y - (textSize.height/2) + height / 4)
            
            dialogTitle.draw(at: textPoint, withAttributes: attributes)
        }
        
        //Dialog animation
        func showDialog(){
            alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.5,initialSpringVelocity: 0.8,
                           options: .transitionCrossDissolve, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform(translationX: 0, y: -220)
            })
            
            UIView.animate(withDuration: 0.5, delay: 1.2,usingSpringWithDamping: 0.5,initialSpringVelocity: 0.8,
                           options: .transitionCrossDissolve, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform(translationX: 0, y: -1000)
            })
        }
    }
