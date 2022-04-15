//
//  sliderCell.swift
//  TweetToGramMock
//
//  Created by Val V on 08/03/22.
//

import UIKit

protocol sliderDelegate {
    func increaseFont(font:Float)
    func increaseCorner(radius:Float)
}

class sliderCell: UICollectionViewCell {
    
    var delegate:sliderDelegate?
    var forRadius:Bool = false
    
    private lazy var slider:UISlider = {
        let slider = UISlider()
        slider.minimumValue = 14
        slider.maximumValue = 40
        slider.value = 20
        slider.thumbTintColor = .white
        slider.tintColor = .white
        slider.addTarget(self, action: #selector(handleSlider(_:)), for: .valueChanged)
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(slider)
        slider.addConstraintsToFillView(self)
        slider.backgroundColor = .black
    }
    
    func changeValue(value:Float){
        slider.value = value
    }
    
    func setMinimumMaximum(minimum:Float,maximum:Float){
        slider.minimumValue = minimum
        slider.maximumValue = maximum
    }
    
    @objc func handleSlider(_ sender:UISlider){
        print(sender.value)
        if forRadius{
            delegate?.increaseCorner(radius: sender.value)
        }
        else{
            delegate?.increaseFont(font: sender.value)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
