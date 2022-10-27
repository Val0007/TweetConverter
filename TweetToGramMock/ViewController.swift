//
//  ViewController.swift
//  TweetToGramMock
//
//  Created by Val V on 21/02/22.
//

import UIKit
import SDWebImage
 


class ViewController: UIViewController {
    
    private var editOption:EditOptions = .text
    
    private lazy var doneButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.link, for: .normal)
        btn.addTarget(self, action: #selector(handleDoneEditing), for: .touchUpInside)
        return btn
    }()
    
    let colorPickerVc = UIColorPickerViewController()
    let ip = UIImagePickerController()
    var isGradient:Bool = false
    var gradientColors:[UIColor] = []

    
    //MARK:DATA FOR TEXT FONT EDIT
    var chosenFont:CustomFonts? = .none
    var fontNamesForCurrentFont:[String] = []
     var chosenTextEditableOption:TextEditableOptions? = .font
    var chosenShapeEditableOption:ShapeEditableOptions?
    
    lazy var txtEditableOptions:[String:[String:()->()]] = ["Font":["Roboto":changeFont,"Smooch Sans":changeFont,"SFUI-Regular":changeFont,"Montserrat":changeFont,"Raleway":changeFont,"Nunito":changeFont,"Open Sans":changeFont,"Source Sans Pro":changeFont]]
    var dataForEditingItem = [String:Any]()


    let topCollectionView:UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: Utils.createBottomCVLayout())
        return cv
    }()
    
    
    let collectionView:UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: Utils.createBottomCVLayout())
        return cv
    }()

    var board:Board
    
    var selectedItem:UIView?
    
    let boardBtn:UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        btn.setImage(UIImage(systemName:"plus",withConfiguration: config),for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(handleBoardEdit), for: .touchUpInside)
        return btn
    }()
    let boardConfigurationbtn:UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        btn.setImage(UIImage(systemName:"b.square",withConfiguration: config),for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(handleBoardConfig), for: .touchUpInside)
        return btn
    }()
    
    let saveBtn:UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        btn.setImage(UIImage(systemName:"square.and.arrow.down",withConfiguration: config),for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return btn
    }()
    
    let shareBtn:UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        btn.setImage(UIImage(systemName:"square.and.arrow.up",withConfiguration: config),for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var contentTxtBtn:UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        btn.setImage(UIImage(systemName:"message.circle",withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(handleContentTxtAdd), for: .touchUpInside)
        return btn
    }()
    lazy var accountNameBtn:UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        btn.setImage(UIImage(systemName:"at.badge.plus",withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(handleAccountNameAdd), for: .touchUpInside)
        return btn
    }()
    
    lazy var accountUserName:UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        btn.setImage(UIImage(systemName:"tag",withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(handleAccountUserNameAdd), for: .touchUpInside)
        return btn
    }()
    
    lazy var profilePhotoBtn:UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        btn.setImage(UIImage(systemName: "person.crop.circle",withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(handlePhotoAdd), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var customShapeBtn:UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        btn.setImage(UIImage(systemName: "cube",withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = true
        btn.addTarget(self, action: #selector(handleCustomShape), for: .touchUpInside)
        return btn
    }()
    
    var profilePhoto:Shape?
    

    var mainButtonStack:UIStackView!
    var boardEditStack:UIStackView!
    
    init(tweet:ReturnedTweet) {
        self.board = Board(frame: .zero, tweet: tweet)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        board.delegate = self
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        for font in TextEditableOptions.FontWeight.allCases{
            fontNamesForCurrentFont.append(font.rawValue)
        }
    }
    
    
    private func createUI(){
        view.addSubview(board)
        board.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        board.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        //0.75
        board.center(inView: view)
        createBottomButtons()
        CreateBoardEditStack()
        createBottomCollectionView()
        createTopCollectionView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    private func createBottomButtons(){
        mainButtonStack  = UIStackView(arrangedSubviews: [boardConfigurationbtn,boardBtn,saveBtn,shareBtn])
        mainButtonStack.spacing = 8
        mainButtonStack.distribution = .fillEqually
        mainButtonStack.translatesAutoresizingMaskIntoConstraints = true
        mainButtonStack.axis = .horizontal
        view.addSubview(mainButtonStack)
        mainButtonStack.frame.size.height = view.frame.height * 0.08
        mainButtonStack.frame.size.width = (view.frame.height * 0.08) * 4 + 24
        mainButtonStack.frame.origin.y = view.frame.height - (view.frame.height * 0.08 + 30)
        mainButtonStack.center.x = view.center.x
        boardBtn.layer.cornerRadius = (mainButtonStack.frame.height) * 0.5
        boardConfigurationbtn.layer.cornerRadius = (mainButtonStack.frame.height) * 0.5
        saveBtn.layer.cornerRadius = (mainButtonStack.frame.height) * 0.5
        shareBtn.layer.cornerRadius = (mainButtonStack.frame.height) * 0.5

    }
    
    private func CreateBoardEditStack(){
        boardEditStack = UIStackView(arrangedSubviews: [contentTxtBtn,accountNameBtn,profilePhotoBtn,accountUserName,customShapeBtn])
        boardEditStack.distribution = .fillEqually
        boardEditStack.spacing = 8
        boardEditStack.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(boardEditStack)
        boardEditStack.frame.size.height = view.frame.height * 0.08
        boardEditStack.frame.size.width = (view.frame.height * 0.08) * 5 + 32
        boardEditStack.frame.origin.y = view.frame.height + view.frame.height * 0.08
        boardEditStack.center.x = view.center.x
        contentTxtBtn.layer.cornerRadius = (boardEditStack.frame.height) * 0.5
        accountNameBtn.layer.cornerRadius = (boardEditStack.frame.height) * 0.5
        profilePhotoBtn.layer.cornerRadius = (boardEditStack.frame.height) * 0.5
        accountUserName.layer.cornerRadius = (boardEditStack.frame.height) * 0.5
        customShapeBtn.layer.cornerRadius = (boardEditStack.frame.height) * 0.5

    }
    
    private func createBottomCollectionView(){
        collectionView.register(bottomCell.self, forCellWithReuseIdentifier: "bottomcell")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.backgroundColor = .systemBackground
        collectionView.frame.size.height = view.frame.height * 0.07
        collectionView.frame.size.width = view.frame.width
        collectionView.frame.origin.y = view.frame.height + view.frame.height * 0.09
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
//        collectionView.layer.borderWidth = 1.0
//        collectionView.layer.borderColor = textColor.cgColor
    }
    
    private func createTopCollectionView(){
        topCollectionView.register(bottomCell.self, forCellWithReuseIdentifier: "topCell")
        topCollectionView.register(sliderCell.self, forCellWithReuseIdentifier: "sliderCell")
        topCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        view.addSubview(topCollectionView)
        topCollectionView.translatesAutoresizingMaskIntoConstraints = true
        topCollectionView.backgroundColor = .white
        topCollectionView.frame.size.height = view.frame.height * 0.06
        topCollectionView.frame.size.width = view.frame.width
        topCollectionView.frame.origin.y = view.frame.height + view.frame.height * 0.06
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
    }
    

    
    private func changeFont(){

        let item = selectedItem as! UILabel
        guard let chosen = chosenFont?.rawValue else {
            print("NO")
            return}
        fontNamesForCurrentFont = []
        for fontName in UIFont.fontNames(forFamilyName: chosenFont?.rawValue ?? "SFUI-Regular"){
            print("Family: \(chosenFont?.rawValue ?? "")     Font: \(fontName)")
            fontNamesForCurrentFont.append(fontName)
            }
        if chosenFont == .Default{
            chosenFont = .none
        }
        print(fontNamesForCurrentFont)
        item.font = UIFont.init(name: chosen, size: item.font.pointSize)
        item.frame.size.height = returnTextHeight(width: item.frame.size.width, font: item.font, text: item.text!) + 10
    }

    
    //MARK:Selectors
    
    @objc func handleBoardConfig(){
        doneButton.setTitle("Done", for: .normal)
        editOption = .board
        selectedItem = board
        collectionView.reloadData()
        bringEditStack()
        
    }
    
    @objc func handleBoardEdit(){
        doneButton.setTitle("Done", for: .normal)
        bringBoardEditStack()
    }
    
    @objc func handleShare(){
        let img = board.getImage()
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        let alert = UIAlertController(title: "Image added To Library", message: "Your Template has been added to your photo library", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { act in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func handleSave(){
//        let alert = UIAlertController(title: "Save template", message: nil, preferredStyle: .alert)
//        let frame = board.frame
//        print(frame)
        let alert = UIAlertController(title: "Update On the way", message: "Saving Templates will added in the future update!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { act in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
//        alert.addTextField { tf in
//            tf.placeholder = "Template name(eg:template1)"
//        }
//        alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { _ in
//            guard let name  = alert.textFields?.first?.text else {return}
//            do{
//                let viewToData = try  NSKeyedArchiver.archivedData(withRootObject: self.board, requiringSecureCoding: false)
//                UserDefaults.standard.setValue(viewToData, forKey: name)
//                if var templates  = UserDefaults.standard.value(forKey: "templates") as? [String] {
//                    templates.append(name)
//                    UserDefaults.standard.setValue(templates, forKey: "templates")
//                }
//                else{
//                    let temps = [name]
//                    UserDefaults.standard.setValue(temps, forKey: "templates")
//                    print("NEw template Created")
//                }
//                print("Saved")
//            }
//            catch{
//                print(error.localizedDescription)
//            }
//        }))
//
//        if self.presentedViewController == nil{
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    
    
    
    @objc func handleContentTxtAdd(){
        if(!board.addContentText(addType: .contentText)){
            doneButton.setTitle("", for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.mainButtonStack.frame.origin.y = self.view.frame.height - (self.view.frame.height * 0.08 + 30)
                self.boardEditStack.frame.origin.y = self.view.frame.height + (self.view.frame.height * 0.08)
                
            }
        }
    }
    @objc func handleAccountNameAdd(){
        if(!board.addContentText(addType: .accountName)){
            doneButton.setTitle("", for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.mainButtonStack.frame.origin.y = self.view.frame.height - (self.view.frame.height * 0.08 + 30)
                self.boardEditStack.frame.origin.y = self.view.frame.height + (self.view.frame.height * 0.08)
                
            }
        }
    }
    
    @objc func handlePhotoAdd(){
        profilePhoto = Shape(frame: .zero)
        profilePhoto!.addImage(image:board.tweet.profileImageURL)
        if(!board.addContentText(addType: .shape,shape: profilePhoto)){
            doneButton.setTitle("", for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.mainButtonStack.frame.origin.y = self.view.frame.height - (self.view.frame.height * 0.08 + 30)
                self.boardEditStack.frame.origin.y = self.view.frame.height + (self.view.frame.height * 0.08)
                
            }
        }
    }
    
    @objc func handleAccountUserNameAdd(){
        if(!board.addContentText(addType: .accountUser)){
            doneButton.setTitle("", for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.mainButtonStack.frame.origin.y = self.view.frame.height - (self.view.frame.height * 0.08 + 30)
                self.boardEditStack.frame.origin.y = self.view.frame.height + (self.view.frame.height * 0.08)
                
            }
        }
    }
    
    @objc func handleCustomShape(){
        let s = Shape(frame: .zero)
        let _ = board.addContentText(addType: .custom, shape: s)
    }
    
    
    
    @objc func handleDoneEditing(){
        if self.selectedItem?.tag == 1 {
            let lbl = self.selectedItem as! TxtLabel
            lbl.removeBorder()
        }
        else if self.selectedItem?.tag == 2 {
            let lbl = self.selectedItem as! Shape
            lbl.removeBorder()
        }
        
        board.selectedItem = nil
        
        bringHomeButtons()
        
        doneButton.setTitle("", for: .normal)

    }
    

    

}


extension ViewController:BoardDelegate{
    func txtTap(label:TouchedView) {
        switch label{
        case .label(let label):
            editOption = .text
            if (label.font.fontName) == ".SFUI-Regular"{
                chosenFont = .none
            }
            else{
                fontNamesForCurrentFont = []
                for fontName in UIFont.fontNames(forFamilyName: label.font.familyName){
                    print("Family: \(label.font.familyName)     Font: \(fontName)")
                    fontNamesForCurrentFont.append(fontName)
                    }
            }
            collectionView.reloadData()
            label.addBorder()
            label.bringSubviewToFront(self.view)
            selectedItem = label
            doneButton.setTitle("Done", for: .normal)
            print("FIRST FUNC")
            bringEditStack()
            
        case .shape(let shape):
            shape.addBorder()
            editOption = .shape
            selectedItem = shape
            doneButton.setTitle("Done", for: .normal)
            collectionView.reloadData()
            bringEditStack()
            
        }

    }
    
    
    func tapFromAnotherView(view: TouchedView) {
        switch view {
        case .label(let label):
            editOption = .text
            if (label.font.fontName) == ".SFUI-Regular"{
                chosenFont = .none
            }
            else{
                fontNamesForCurrentFont = []
                for fontName in UIFont.fontNames(forFamilyName: label.font.familyName){
                    print("Family: \(label.font.familyName)     Font: \(fontName)")
                    fontNamesForCurrentFont.append(fontName)
                    }
            }
            print("SECOND FUNC")
            collectionView.reloadData()
            label.addBorder()
            label.bringSubviewToFront(self.view)
            selectedItem = label
            doneButton.setTitle("Done", for: .normal)
            self.view.bringSubviewToFront(self.topCollectionView)
            bringDownTopCollectionView()
        case .shape(let shape):
            shape.addBorder()
            editOption = .shape
            selectedItem = shape
            doneButton.setTitle("Done", for: .normal)
            collectionView.reloadData()
            self.view.bringSubviewToFront(self.topCollectionView)
            bringDownTopCollectionView()
        }
    }
    
    

}

extension ViewController:sliderDelegate{
    func increaseFont(font: Float) {
        let label = selectedItem as! UILabel
        if chosenFont == nil{
            let f = UIFont.systemFont(ofSize: CGFloat(font), weight:label.font.weight)
            label.font = f
            label.frame.size.height = returnTextHeight(width: label.frame.width, font: label.font, text: label.text!)
            return

        }
        let d  = UIFontDescriptor(name: label.font.fontName, size: CGFloat(font))
        let f = UIFont.init(descriptor: d, size: CGFloat(font))
        label.font = f
        label.frame.size.height = returnTextHeight(width: label.frame.width, font: label.font, text: label.text!)

    }
    func increaseCorner(radius: Float) {
        let s = selectedItem as! Shape
        s.layer.cornerRadius = CGFloat(radius)
    }
}

extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            if editOption == .text{
                return TextEditableOptions.allCases.count
            }
            else if editOption == .shape{
                return ShapeEditableOptions.allCases.count
            }
            else if editOption == .board{
                return BoardEditableOptions.allCases.count
            }
        }
        
        else{
            //TOPCOLLECTIONVIEW
            if (editOption == .text){
                if chosenTextEditableOption == .font{
                    return dataForEditingItem.count
                }
                else if(chosenTextEditableOption == .size){
                    return 1
                }
                else if(chosenTextEditableOption == .color){
                    return AvailableColors.allCases.count
                }
                else if(chosenTextEditableOption == .weight){
                    if chosenFont == .none{
                        return TextEditableOptions.FontWeight.allCases.count
                    }
                    return fontNamesForCurrentFont.count
                }
            }
            else if(editOption == .shape){
                if chosenShapeEditableOption == .circle{
                    return 1
                }
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomcell", for: indexPath) as! bottomCell
            if editOption == .text{
                cell.displayText = TextEditableOptions.allCases[indexPath.row].rawValue
            }
            else if editOption == .shape{
                cell.displayText = ShapeEditableOptions.allCases[indexPath.row].rawValue
            }
            else if editOption == .board{
                cell.displayText = BoardEditableOptions.allCases[indexPath.row].rawValue
            }
            cell.upDate()
            return cell
       }
        else{
            if(editOption == .text){
                if(chosenTextEditableOption == .size){
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! sliderCell
                    let lbl = selectedItem as! TxtLabel
                    cell.changeValue(value: lbl.pointSize)
                    cell.forRadius = false
                    cell.delegate = self
                    return cell
                }
                else if(chosenTextEditableOption == .font){
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath) as! bottomCell
                    let arr = Array(dataForEditingItem.keys)
                    cell.displayText = arr[indexPath.row]
                    cell.upDate()
                    return cell
                }
                else if(chosenTextEditableOption == .color){
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
                    let color = AvailableColors.allCases[indexPath.row]
                    if color != .custom{
                        cell.backgroundColor = AvailableColors.allCases[indexPath.row].color
                    }
                    else{
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath) as! bottomCell
                        cell.displayText = "Custom"
                        cell.upDate()
                        return cell
                    }
                    return cell
                }
                else if(chosenTextEditableOption == .weight){
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath) as! bottomCell
                    if chosenFont == .none{
                        cell.displayText = TextEditableOptions.FontWeight.allCases[indexPath.row].rawValue
                    }
                    else{
                        cell.displayText = fontNamesForCurrentFont[indexPath.row]
                    }
                    cell.upDate()

                    return cell
                }
            }
            else if(editOption == .shape){
                if chosenShapeEditableOption == .circle{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! sliderCell
                    cell.forRadius = true
                    cell.setMinimumMaximum(minimum: 0, maximum: 25)
                    cell.changeValue(value: 0)
                    cell.delegate = self
                    return cell
                }
            }
            

        }
        
        return UICollectionViewCell()

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            if editOption == .text{
                let textItem = TextEditableOptions.allCases[indexPath.row]
                if(textItem == .font){
                    topCollectionView.collectionViewLayout = Utils.createBottomCVLayout()
                    chosenTextEditableOption = .font
                    let values = txtEditableOptions[textItem.rawValue]
                    dataForEditingItem = values!
                    bringTopCollectionView()
                    topCollectionView.reloadData()
                }
                else if(textItem == .size){
                    topCollectionView.collectionViewLayout = Utils.layoutForSlider()
                    chosenTextEditableOption = .size
                    bringTopCollectionView()
                    topCollectionView.reloadData()
                }
                else if(textItem == .color){
                    topCollectionView.collectionViewLayout = Utils.createBottomCVLayout()
                    chosenTextEditableOption = .color
                    bringTopCollectionView()
                    topCollectionView.reloadData()

                }
                else if(textItem == .delete){
                    selectedItem?.removeFromSuperview()
                    for (index,item) in  board.itemsOnBoard.enumerated(){
                        print(item)
                        handleDoneEditing()
                        if item == selectedItem{
                            board.itemsOnBoard.remove(at: index)
                        }
                    }
                    selectedItem = nil
                }
                else if(textItem == .weight){
                    topCollectionView.collectionViewLayout = Utils.createBottomCVLayout()
                    chosenTextEditableOption = .weight
                    topCollectionView.reloadData()
                    bringTopCollectionView()
                }
                else if(textItem == .bringToFront){
                    board.bringSubviewToFront(selectedItem!)
                }
            }
            else if(editOption == .shape){
                let shapeEditedItem = ShapeEditableOptions.allCases[indexPath.row]
                if shapeEditedItem == .background{
                    chosenShapeEditableOption = .background
                    presentColorPicker()
                }
                else if shapeEditedItem == .bringFront{
                    chosenShapeEditableOption = .bringFront
                    board.bringSubviewToFront(selectedItem!)
                }
                else if shapeEditedItem == .image{
                    chosenShapeEditableOption = .image
                    presentImagePicker()
                }
                else if shapeEditedItem == .circle{
                    topCollectionView.collectionViewLayout = Utils.layoutForSlider()
                    chosenShapeEditableOption = .circle
                    topCollectionView.reloadData()
                    bringTopCollectionView()
                }
                else if shapeEditedItem == .fullCircle{
                    guard let width = selectedItem?.frame.width else {return}
                    guard let height = selectedItem?.frame.height else {return}
                    if width>height{
                        selectedItem?.frame.size.height = width
                        selectedItem?.layer.cornerRadius = width * 0.5
                    }
                    else{
                        selectedItem?.frame.size.width = height
                        selectedItem?.layer.cornerRadius = height * 0.5
                    }
                }
                else if shapeEditedItem == .delete{
                    selectedItem?.removeFromSuperview()
                    let s = selectedItem as! Shape
                    selectedItem = nil
                    for (index,item) in  board.itemsOnBoard.enumerated(){
                        if let i = item as? Shape{
                            if i.id == s.id{
                                board.itemsOnBoard.remove(at: index)
                                handleDoneEditing()
                            }
                        }

                    }
                    profilePhoto = nil
                }
                else if shapeEditedItem == .gradient{
                    isGradient = true
                    presentColorPicker()
                }
            }
            else if editOption == .board{
                let item = BoardEditableOptions.allCases[indexPath.row]
                if item == .background{
                    chosenShapeEditableOption = .background
                    presentColorPicker()
                }
                else if item == .gradient{
                    isGradient = true
                    presentColorPicker()
                }
                else if item == .image{
                    chosenShapeEditableOption = .image
                    presentImagePicker()
                }
                else if item == .delete{
                    for v in board.subviews{
                        v.removeFromSuperview()
                    }
                    if let sublayers = board.layer.sublayers{
                        for l in sublayers{
                            l.removeFromSuperlayer()
                        }

                    }
                }

            }
            

        }
        else{
            if editOption == .text{
                if chosenTextEditableOption == .font{
                    let functionArr = Array(dataForEditingItem.keys)
                    let f = functionArr[indexPath.row]
                    chosenFont = CustomFonts.init(rawValue: f)
                     if let value = dataForEditingItem[f] as? ()->(){
                        value()
                    }
                }
                else if chosenTextEditableOption == .color{
                    let color = AvailableColors.allCases[indexPath.row]
                    if color != .custom{
                        let lbl = selectedItem as! UILabel
                        lbl.textColor = color.color
                    }
                    else{
                        presentColorPicker()
                    }
                }
                else if chosenTextEditableOption == .weight{
                    if chosenFont == .none{
                        let l = selectedItem as! TxtLabel
                        let w = TextEditableOptions.FontWeight.allCases[indexPath.row].fw
                        let f = UIFont.systemFont(ofSize: CGFloat(l.pointSize), weight: w)
                        l.font = f
                        return
                    }
                    else{
                        let fw = fontNamesForCurrentFont[indexPath.row]
                        let l = selectedItem as! TxtLabel
                        let d  = UIFontDescriptor(name: fw, size: l.font.pointSize)
                        let f = UIFont.init(descriptor: d, size: l.font.pointSize)
                        l.font = f
                    }

                
                }
            }

        }

    }
}

//HELPER FUNCTIONS
extension ViewController{
    func bringEditStack(){
        //if mainbtnstack is showing
        //put mainBtnStack down and bring collectionview up
        if(!(mainButtonStack.frame.origin.y > view.frame.height)){
            UIView.animate(withDuration: 0.2) {
                self.mainButtonStack.frame.origin.y = self.view.frame.height + (self.view.frame.height * 0.08)
                self.collectionView.frame.origin.y -= (self.view.frame.height * 0.09)*2 + 30
                

            }
        }
        //if boardEditStack is showing
        //put boardEditStack down and bring cv up
        else if(!(boardEditStack.frame.origin.y > view.frame.height)){
            UIView.animate(withDuration: 0.2) {
                self.boardEditStack.frame.origin.y = self.view.frame.height + (self.view.frame.height * 0.08)
                self.collectionView.frame.origin.y -= (self.view.frame.height * 0.09)*2 + 30

            }
        }
    }
    
    func bringHomeButtons(){
        if(collectionView.frame.origin.y < self.view.frame.height){
            //CollectionViewShowing => SomeItemWasTouched
            UIView.animate(withDuration: 0.2) {
                self.mainButtonStack.frame.origin.y = self.view.frame.height - (self.view.frame.height * 0.08 + 30)
                self.collectionView.frame.origin.y = self.view.frame.height + (self.view.frame.height * 0.09)
                if(self.topCollectionView.frame.origin.y < self.view.frame.height){
                    self.topCollectionView.frame.origin.y =  self.view.frame.height + self.view.frame.height * 0.06
                }
            }
        }
        else{
            //CollectionViewNotShowing => BoardEditStackButton was clicked
            UIView.animate(withDuration: 0.2) {
                self.boardEditStack.frame.origin.y = self.view.frame.height + (self.view.frame.height * 0.08)
                self.mainButtonStack.frame.origin.y = self.view.frame.height - (self.view.frame.height * 0.08 + 30)
            }

        }
    }
    private func bringTopCollectionView(){
        if(topCollectionView.frame.origin.y > view.frame.height){
            UIView.animate(withDuration: 0.2) {
                self.topCollectionView.frame.origin.y = self.collectionView.frame.origin.y - (self.view.frame.height * 0.06)

            }
        }
        

    }
    
    private func bringDownTopCollectionView(){
        UIView.animate(withDuration: 0.3) {
            if(self.topCollectionView.frame.origin.y < self.view.frame.height){
                self.topCollectionView.frame.origin.y =  self.view.frame.height + self.view.frame.height * 0.06
            }
        }


    }
    
    private func bringBoardEditStack(){
        UIView.animate(withDuration: 0.2) {
            self.mainButtonStack.frame.origin.y = self.view.frame.height + self.view.frame.height * 0.08
            print(self.boardEditStack.frame.origin.y)
            self.boardEditStack.frame.origin.y -= (self.view.frame.height * 0.08)*2  + 30
            print(self.boardEditStack.frame.origin.y)


        }
    }
    
    func presentColorPicker(){
        colorPickerVc.delegate = self
        present(colorPickerVc, animated: true, completion: nil)
    }
    
    func presentImagePicker(){
        ip.delegate = self
        present(ip, animated: true, completion: nil)
    }
}
    
extension ViewController:UIColorPickerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let clr  = viewController.selectedColor
        if editOption == .text{
            let lbl = selectedItem as! UILabel
            lbl.textColor = clr
        }
        else{
            if isGradient{
                if gradientColors == [] {
                    gradientColors.append(clr)
                    presentColorPicker()
                }
                else{
                    gradientColors.append(clr)
                    print(gradientColors)
                    isGradient = false
                    let gradientLayer = CAGradientLayer()
                    gradientLayer.colors = [gradientColors[0].cgColor, gradientColors[1].cgColor]
                    gradientLayer.locations = [0.0, 1.0]
                    guard let f = selectedItem?.bounds else {return}
                    print(f)
                    gradientLayer.frame = f
                    if editOption == .board{
                        board.layer.insertSublayer(gradientLayer, at: 0)
                        gradientColors = []

                    }
                    else{
                        self.selectedItem?.layer.insertSublayer(gradientLayer, at: 0)
                        gradientColors = []

                    }
                }
                return
            }
            if editOption == .board{
                let sh = selectedItem as! Board
                sh.backgroundColor = clr
            }
            else{
                let sh = selectedItem as! Shape
                sh.backgroundColor = clr
            }


        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ip.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            if editOption == .board{
                let s = selectedItem as! Board
                s.addBackGroundImage(image: image)
                
            }
            else{
                let s = selectedItem as! Shape
                s.image = image
            }

        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ip.dismiss(animated: true, completion: nil)
    }
}
