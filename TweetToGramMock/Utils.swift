//
//  Utils.swift
//  TweetToGramMock
//
//  Created by Val V on 07/03/22.
//

import Foundation
import UIKit

struct Utils {
    static func createBottomCVLayout()->UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout { section, env in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension:.fractionalWidth(1), heightDimension: .fractionalHeight(1.0)))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0)), subitem:item,count: 1)
            
            //Groups make up the section which are required for scrolling
            let groups = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0)), subitems:[group])
            
            
            let section = NSCollectionLayoutSection(group: groups)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
    
    static func layoutForSlider()->UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout { section, env in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension:.fractionalWidth(1), heightDimension: .fractionalHeight(1.0)))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0)), subitem:item,count: 1)

            
            let section = NSCollectionLayoutSection(group: group)
            //section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
    
}

extension UIViewController{
    var textColor:UIColor{
        return traitCollection.userInterfaceStyle == .dark ? .white : .black
    }

    func returnTextHeight(width:CGFloat,font:UIFont,text:String)->CGFloat{
        //no constraint in height,if width has greatest -> go out of screen
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        //resizes the label and gives the correct frame
        label.sizeToFit()
        return label.frame.height
    }
    
}




enum TextEditableOptions:String, CaseIterable{
    case font = "Font"
    case weight = "Font Weight"
    case color = "Color"
    case size = "Size"
    case delete = "Delete"
    case bringToFront = "Bring To Top"
    
    
    
    
    enum FontWeight:String,CaseIterable {
        
        case bold = "Bold",black = "Black",heavy = "Heavy",light = "Light"
             ,medium = "Medium",regular = "Regular",semibold = "SemiBold",thin = "Thin",ultralight = "UltraLight"
        var fw:UIFont.Weight{
            
            switch self {
            case .bold:
                return .bold
            case .black:
                return .black
            case .heavy:
            return .heavy
            case .light:
            return .light
            case .medium:
            return .medium
            case .regular:
            return .regular
            case .semibold:
            return .semibold
            case .thin:
            return .thin
            case .ultralight:
                return .ultraLight
            }
        }
        
    }
    
    
    var icon:UIImage{
        switch self{
        case .font:
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
            return UIImage(systemName:"f.cursive",withConfiguration: config)!
        case .weight:
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
            return UIImage(systemName:"f.cursive",withConfiguration: config)!
        case .color:
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
            return UIImage(systemName:"eyedropper",withConfiguration: config)!
        case .size:
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
            return UIImage(systemName:"textformat.size",withConfiguration: config)!
        case .delete:
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
            return UIImage(systemName:"trash",withConfiguration: config)!
        case .bringToFront:
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
        return UIImage(systemName:"tray.2.fill",withConfiguration: config)!
        }
    }
    
}

enum BoardEditableOptions:String,CaseIterable{
    case background = "Background Color"
    case image = "Background Image"
    case gradient = "Gradients"
    case delete = "Delete All"
}

enum ShapeEditableOptions:String,CaseIterable{
    case background = "Background Color"
    case image = "Background Image"
    case circle = "Rounded Corners"
    case bringFront = "Bring To Top"
    case fullCircle = "Circle"
    case delete = "Delete"
    case gradient = "Gradients"
    
    var icon:UIImage{
        switch self{
        case .background:
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
            return UIImage(systemName:"eyedropper",withConfiguration: config)!
        case .bringFront:
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
        return UIImage(systemName:"tray.2.fill",withConfiguration: config)!
        default:
                let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
                return UIImage(systemName:"eyedropper",withConfiguration: config)!
            
        }
    }
}

enum CustomFonts:String,CaseIterable{
    case Roboto = "Roboto"
    case SmoochSans = "Smooch Sans"
    case Montserrat = "Montserrat"
    case Default = "SFUI-Regular"
    case Raleway = "Raleway"
    case Nunito = "Nunito"
    case OpenSans = "Open Sans"
    case SourceSansPro = "Source Sans Pro"
}

enum EditOptions{
    case text
    case shape
    case board
}

enum TouchedView{
    case label(TxtLabel)
    case shape(Shape)
}

enum AvailableColors:CaseIterable{
    case custom,black,white,red,blue,yellow,orange,indigo,violet
    
    var color:UIColor{
        switch self{
        case .red:
            return .red
        case .blue:
            return .blue
        case .black:
            return .black
        case .yellow:
            return .yellow
        case .orange:
            return .orange
        case .white:
            return .white
        case .indigo:
            return .green
        case .violet:
            return .magenta
        case .custom:
            return .black
        }
    }
}


extension UIView{
    

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds) //a graphics renderer
        //a function that takes the context as a parameter which gives back an image
        //we want the uiview's layer to be rendered in the context
        return renderer.image { rendererContext in
            self.drawHierarchy(in: bounds, afterScreenUpdates: true)
            //renders a snapshot of the complete view
        }
    }
    
    
    func getImage() -> UIImage{
        let renderer = UIGraphicsImageRenderer(bounds: bounds) //a graphics renderer
        return renderer.image { ctx in
            layer.render(in: ctx.cgContext)
        }
    }
    

    
 
}


//UIImage obtained is in the size of the board so when displayed in gallary it scales thereby losing its quality
extension UIImage {

    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

}

extension UIFont {
    var weight: UIFont.Weight {
        guard let weightNumber = traits[.weight] as? NSNumber else { return .regular }
        //C.UIFontDescriptorTraitKey(_rawValue: NSCTFontWeightTrait): 0.6200000047683716
        let weightRawValue = CGFloat(weightNumber.doubleValue)
        let weight = UIFont.Weight(rawValue: weightRawValue)
        return weight
    }
    private var traits: [UIFontDescriptor.TraitKey: Any] {
            return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
                ?? [:]
        }
}
