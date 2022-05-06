//
//  Board.swift
//  TweetToGramMock
//
//  Created by Val V on 25/02/22.
//

import UIKit

//MARK:START

protocol BoardDelegate {
    func txtTap(label:TouchedView)
    func tapFromAnotherView(view:TouchedView)
}

enum AddType{
    case contentText,accountName,shape,accountUser,custom
}

class Board: UIView {
    
    var delegate:BoardDelegate?
    
    var selectedItem:UIView?
    
    let tweet:ReturnedTweet
    
    var itemsOnBoard :[UIView] = []

    let verticalLine:UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let horizontalLine:UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    
    lazy var txtContentLabel = TxtLabel(frame: .zero, txt: tweet.text)
    
    lazy var accountLabel = TxtLabel(frame: .zero, txt: "@\(tweet.authorUsername)")
    
    lazy var accountUserLabel = TxtLabel(frame: .zero, txt: (tweet.authorName))

    
     init(frame: CGRect = .zero,tweet:ReturnedTweet) {
        self.tweet = tweet
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.94, alpha: 1.00)
        clipsToBounds = true

    }
    
    override func layoutSubviews() {
        addSubview(verticalLine)
        verticalLine.centerX(inView: self)
        verticalLine.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        verticalLine.widthAnchor.constraint(equalToConstant: 2).isActive = true
        verticalLine.isHidden = true
        addSubview(horizontalLine)
        horizontalLine.centerY(inView: self)
        horizontalLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
        horizontalLine.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        horizontalLine.isHidden = true
        layoutIfNeeded()
        print(center.x)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addContentText(addType:AddType,shape:Shape? = nil)->Bool{
        
        if(addType == .contentText){
            if !itemsOnBoard.contains(txtContentLabel){
            addSubview(txtContentLabel)
            let moveGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMove(_:)))
                txtContentLabel.addGestureRecognizer(moveGesture)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleItemTap(_:)))
                txtContentLabel.addGestureRecognizer(tap)
                txtContentLabel.frame.size.height = returnTextHeight(width: frame.size.width * 0.9, font: txtContentLabel.font, text: txtContentLabel.text!)
                txtContentLabel.frame.size.width = frame.size.width * 0.9
                txtContentLabel.center.x = frame.width/2
                txtContentLabel.center.y = frame.height/2
            itemsOnBoard.append(txtContentLabel)
            return true
            }
            return false
        }
        else if addType == .accountName{
            if !itemsOnBoard.contains(accountLabel){
            addSubview(accountLabel)
            let moveGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMove(_:)))
                accountLabel.addGestureRecognizer(moveGesture)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleItemTap(_:)))
                accountLabel.addGestureRecognizer(tap)
                accountLabel.frame.size.height = returnTextHeight(width: frame.size.width * 0.9, font: accountLabel.font, text: accountLabel.text!)
                accountLabel.frame.size.width = frame.size.width * 0.9
                accountLabel.center.x = frame.width/2
                accountLabel.center.y = frame.height/2
            itemsOnBoard.append(accountLabel)
            return true
            }
            return false
        }
        else if addType == .shape{
            guard let shape = shape else { return false}
            if !itemsOnBoard.contains(shape){
            addSubview(shape)
                shape.isUserInteractionEnabled = true
            let moveGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMove(_:)))
                shape.addGestureRecognizer(moveGesture)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleItemTap(_:)))
                shape.addGestureRecognizer(tap)
                shape.frame.size.height = frame.size.width * 0.3
                shape.frame.size.width = frame.size.width * 0.3
                shape.center.x = frame.width/2
                shape.center.y = frame.height/2
            itemsOnBoard.append(shape)
            return true
            }
            return false
        }
        else if addType == .accountUser{
            if !itemsOnBoard.contains(accountUserLabel){
            addSubview(accountUserLabel)
            let moveGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMove(_:)))
                accountUserLabel.addGestureRecognizer(moveGesture)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleItemTap(_:)))
                accountUserLabel.addGestureRecognizer(tap)
                accountUserLabel.frame.size.height = returnTextHeight(width: frame.size.width * 0.9, font: accountUserLabel.font, text: accountUserLabel.text!)
                accountUserLabel.frame.size.width = frame.size.width * 0.9
                accountUserLabel.center.x = frame.width/2
                accountUserLabel.center.y = frame.height/2
            itemsOnBoard.append(accountUserLabel)
            return true
            }
            return false
        }
        else if addType == .custom{
            guard let shape = shape else { return false}
            addSubview(shape)
                shape.isUserInteractionEnabled = true
            let moveGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMove(_:)))
                shape.addGestureRecognizer(moveGesture)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleItemTap(_:)))
                shape.addGestureRecognizer(tap)
                shape.frame.size.height = frame.size.width * 0.3
                shape.frame.size.width = frame.size.width * 0.3
                shape.center.x = frame.width/2
                shape.center.y = frame.height/2
            itemsOnBoard.append(shape)
            
        }
        
        return false
    }
    
    
    private func returnTextHeight(width:CGFloat,font:UIFont,text:String)->CGFloat{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        //resizes the label and gives the correct frame
        label.sizeToFit()
        return label.frame.height
    }
    
    
    
    @objc func handleItemTap(_ sender:UITapGestureRecognizer){
        guard let v = sender.view else {return}
        if let si = selectedItem {
            if si.tag == 1{
                let l = si as! TxtLabel
                l.removeBorder()
                if v.tag == 1{
                    let lbl = v as! TxtLabel
                    selectedItem = lbl
                    delegate?.tapFromAnotherView(view: .label(lbl))
                    return
                }
                else{
                    let sh = v as! Shape
                    selectedItem = sh
                    delegate?.tapFromAnotherView(view: .shape(sh))
                    return
                }
            }
            else{
                let sh = si as! Shape
                sh.removeBorder()
            }
        }
        if v.tag == 1{
            let lbl = v as! TxtLabel
            selectedItem = lbl
            delegate?.txtTap(label: .label(lbl))
            return
//            if v == accountLabel{
//                selectedItem = accountLabel
//                accountLabel.addBorder()
//                delegate?.txtTap(label: .label(accountLabel))
//
//            }
//            else if v == accountUserLabel{
//                selectedItem = accountUserLabel
//                accountUserLabel.addBorder()
//                delegate?.txtTap(label: .label(accountUserLabel))
//
//            }
//            else if v == txtContentLabel{
//                selectedItem = txtContentLabel
//                delegate?.txtTap(label: .label(txtContentLabel))
//            }
        }
        else if v.tag == 2 {
            let s = v as! Shape
            selectedItem = s
            s.isUserInteractionEnabled = true
            for shape in itemsOnBoard{
                if s == shape as? Shape{
                    delegate?.txtTap(label: .shape(s))
                }
            }
        }
    }
    
    func addBackGroundImage(image:UIImage){
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        addSubview(iv)
        iv.image = image
        iv.addConstraintsToFillView(self)
    }
    
    
    @objc func handleMove(_ gesture:UIPanGestureRecognizer){
        //of the specfied view and not the board
        guard let senderView = gesture.view else { return }
        var translatedPoint: CGPoint = gesture.translation(in:gesture.view)
        translatedPoint = CGPoint(x: senderView.center.x + translatedPoint.x, y: senderView.center.y + translatedPoint.y)
        gesture.view!.center = translatedPoint
        gesture.setTranslation(.zero, in: gesture.view)
        if(frame.size.width/2 > senderView.center.x){
            if ((frame.size.width/2 - senderView.center.x) < 4){
                print(frame.size.width/2 - senderView.center.x)
                verticalLine.isHidden = false
            }
            else{
                verticalLine.isHidden = true
            }
        }
        else{
            if ((frame.size.width/2 - senderView.center.x) > -4){
                print(frame.size.width/2 - senderView.center.x)
                verticalLine.isHidden = false
            }
            else{
                verticalLine.isHidden = true
            }
        }
        if(frame.size.height/2 > senderView.center.y){
            if ((frame.size.height/2 - senderView.center.y) < 4){
                horizontalLine.isHidden = false
            }
            else{
                horizontalLine.isHidden = true
            }
        }
        else{
            if ((frame.size.height/2 - senderView.center.y) > -4){
                horizontalLine.isHidden = false
            }
            else{
                horizontalLine.isHidden = true
            }
        }
        
        if gesture.state == .ended{
            verticalLine.isHidden = true
            horizontalLine.isHidden = true
        }

    }
    

    func addGesturesToItems(){
        for item in itemsOnBoard{
            if let i = item as? TxtLabel{
                //SO NEW txtContentLabel cannot be addedAgain
                if i.text == txtContentLabel.text{
                    print("YES")
                    txtContentLabel = i
                }
                else if i.text == accountUserLabel.text{
                    accountUserLabel = i
                }
                else if i.text == accountLabel.text{
                    accountLabel = i
                }
                
                i.addBothDots()
                let moveGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMove(_:)))
                    i.addGestureRecognizer(moveGesture)
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleItemTap(_:)))
                    i.addGestureRecognizer(tap)
            }
            else if let i  = item as? Shape{
                print(i.id)
                i.clipsToBounds = true
                i.addBothDots()
                i.addVerticalDots()
                i.isUserInteractionEnabled = true
            let moveGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMove(_:)))
                i.addGestureRecognizer(moveGesture)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleItemTap(_:)))
                i.addGestureRecognizer(tap)
            }
        }

    }

    


}






//txtlabel - 1
//shape - 2
