//
//  bottomCell.swift
//  TweetToGramMock
//
//  Created by Val V on 07/03/22.
//

import UIKit

class bottomCell: UICollectionViewCell {
    
    var displayText:String?
        
    private let displayLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines  = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let container = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setup(){
        addSubview(container)
        container.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 3,paddingLeft: 5,paddingBottom:3,paddingRight: 5)
        container.layer.cornerRadius = 4
        container.addSubview(displayLabel)
        displayLabel.addConstraintsToFillView(container)
        //container.backgroundColor = UIColor(red: 1.00, green: 0.41, blue: 0.48, alpha: 1.00)
        container.backgroundColor = .black
        container.layer.borderWidth = 1.0
        container.layer.borderColor = UIColor.black.cgColor
    }
    func upDate(){
        displayLabel.text = displayText
    }
}

extension UIView{
    var textColor:UIColor{
        return traitCollection.userInterfaceStyle == .dark ? .white : .black
    }
}
