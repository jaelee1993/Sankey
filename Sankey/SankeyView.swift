//
//  SankeyView.swift
//  Sankey
//
//  Created by Jae Lee on 12/2/19.
//  Copyright © 2019 Jae Lee. All rights reserved.
//

import UIKit
protocol SankeyDelegate {
    func lineIsHit<T:SankeyLineShapeLayer>(sankeyLineShapeLayer:T)
}
class SankeyLineShapeLayer: CAShapeLayer {
    var startTag:String?
    var endTag:String?
    func setLineStartEndTags(_ startTag:String?, _ endTag:String?) {
        self.startTag = startTag
        self.endTag = endTag
    }
}
enum SankeyType {
    case lineCenter
    case lineStacked
}
struct SankeyItem {
    var name:String
    var volume:Int
}

class SnakeyItemView:UIView {
    var titleTag:String = ""
    var title:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        title = UILabel()
        title.textColor = .white
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func setTitle(_ title:String) {
        self.title.text = title
        titleTag = title
    }
}

class SankeyView: UIScrollView {
    private var contentView:UIView!
    
    public var padding:            CGFloat = 5
    public var pixelPerItem:       CGFloat = 4
    public var spacing:            CGFloat = 20
    public var itemHeight:         CGFloat = 60
    public var itemWidth:          CGFloat = 80
    public var leftItemColor:      UIColor = .red
    public var rightItemColor:     UIColor = .blue
    
    var sankeyItems:[String:[SankeyItem]] = [
        "seller 1":  [SankeyItem(name: "buyer A", volume: 5)],
        "seller 2":  [SankeyItem(name: "buyer A", volume: 1)],
        "seller 3":  [SankeyItem(name: "buyer A", volume: 3)],
        "seller 4":  [SankeyItem(name: "buyer A", volume: 5),SankeyItem(name: "buyer B", volume: 10),SankeyItem(name: "buyer C", volume: 15)],
//        "seller 5":  [SankeyItem(name: "buyer A", volume: 1),SankeyItem(name: "buyer B", volume: 3),SankeyItem(name: "buyer C", volume: 5),SankeyItem(name: "buyer D", volume: 3),SankeyItem(name: "buyer E", volume: 5),SankeyItem(name: "buyer F", volume: 1),SankeyItem(name: "buyer G", volume: 3),SankeyItem(name: "buyer H", volume: 10)],
//
    ]
    
    var leftTotals:                     [String:Int] = [:]
    var rightTotals:                    [String:Int] = [:]
    
    var leftItemNewLineDrawPoint:       [String:CGFloat] = [:]
    var rightItemNewLineDrawPoint:      [String:CGFloat] = [:]
    
    var leftViews:                      [SnakeyItemView] = []
    var rightViews:                     [SnakeyItemView] = []
    
    //rules
    var sankeyType:SankeyType = .lineStacked
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }
    
    public init(frame: CGRect, type:SankeyType) {
        super.init(frame: frame)
        self.sankeyType = type
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
       
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    public func drawSankey() {
        analyzeSankeyItems()
        drawLeft()
        drawRight()
        drawSankeyLines()
    }
    
    public func drawSankey(_ sankeyItems:[SankeyItem]) {
        analyzeSankeyItems()
        drawLeft()
        drawRight()
        drawSankeyLines()
    }
    
    
    private func analyzeSankeyItems() {
        for (key,value) in sankeyItems {
            var count = 0
            
            
            value.forEach {
                count += $0.volume
                if rightTotals[$0.name] == nil {
                    rightTotals[$0.name] =  0 + $0.volume
                } else {
                    rightTotals[$0.name] =  rightTotals[$0.name]! + $0.volume
                }
                rightItemNewLineDrawPoint[$0.name] = 0
            }
            
            leftItemNewLineDrawPoint[key] = 0
            leftTotals[key] = count
            
        }
    }
    
    func drawLeft() {
        var i = 0
        let totals = leftTotals
        for (key,value) in totals {
            let view = SnakeyItemView()
            view.backgroundColor = UIColor.blue.withAlphaComponent(0.9)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setTitle(key)
            contentView.addSubview(view)
            
            switch sankeyType {
            case .lineCenter:
                print("")
            case .lineStacked:
                // not first and not last cell
                if i != 0 && i != (totals.count - 1) {
                    let priorView = leftViews[i - 1]
                    NSLayoutConstraint.activate([
                        view.topAnchor.constraint(equalTo: priorView.bottomAnchor, constant: spacing),
                        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                        view.widthAnchor.constraint(equalToConstant: 100),
                        view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem)
                    ])
                }
                    // last cell
                else if i == (totals.count - 1) && i != 0 {
                    let priorView = leftViews[i - 1]
                    if leftTotals.count > rightTotals.count {
                        NSLayoutConstraint.activate([
                            view.topAnchor.constraint(equalTo: priorView.bottomAnchor, constant: spacing),
                            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                            view.widthAnchor.constraint(equalToConstant: 100),
                            view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem),
                            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
                        ])
                    } else {
                        NSLayoutConstraint.activate([
                            view.topAnchor.constraint(equalTo: priorView.bottomAnchor, constant: spacing),
                            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                            view.widthAnchor.constraint(equalToConstant: 100),
                            view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem)
                        ])
                        
                    }
                }
                // last cell && first cell
                else if i == (totals.count - 1) && i == 0 {
                    if leftTotals.count > rightTotals.count {
                        NSLayoutConstraint.activate([
                            view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                            view.widthAnchor.constraint(equalToConstant: itemWidth),
                            view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem),
                            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
                        ])
                    } else {
                        NSLayoutConstraint.activate([
                            view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                            view.widthAnchor.constraint(equalToConstant: itemWidth),
                            view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem),
                        ])
                    }
                }
                    
                    
                    
                    // first cell
                else {
                    NSLayoutConstraint.activate([
                        view.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
                        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                        view.widthAnchor.constraint(equalToConstant: 100),
                        view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem)
                    ])
                }
            }
            
            contentView.layoutIfNeeded()
            leftViews.append(view)
            i += 1
            
        }
    }
    
    
    
    func drawRight() {
        var i = 0
        let totals = rightTotals
        for (key,value) in totals {
            let view = SnakeyItemView()
            view.backgroundColor = UIColor.systemPink.withAlphaComponent(0.9)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setTitle(key)
            contentView.addSubview(view)
            switch sankeyType {
            case .lineCenter:
                print("")
            case .lineStacked:
                // not first and not last cell
                if i != 0 && i != (totals.count - 1) {
                    let priorView = rightViews[i - 1]
                    NSLayoutConstraint.activate([
                        view.topAnchor.constraint(equalTo: priorView.bottomAnchor, constant: spacing),
                        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
                        view.widthAnchor.constraint(equalToConstant: 100),
                        view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem)
                    ])
                }
                // last cell
                else if i == (totals.count - 1) && i != 0  {
                    let priorView = rightViews[i - 1]
                    if rightTotals.count >= leftTotals.count {
                        NSLayoutConstraint.activate([
                            view.topAnchor.constraint(equalTo: priorView.bottomAnchor, constant: spacing),
                            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
                            view.widthAnchor.constraint(equalToConstant: 100),
                            view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem),
                            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
                        ])
                    } else {
                        NSLayoutConstraint.activate([
                            view.topAnchor.constraint(equalTo: priorView.bottomAnchor, constant: spacing),
                            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
                            view.widthAnchor.constraint(equalToConstant: 100),
                            view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem)
                        ])
                    }
                }
                
                // last cell && first cell
                else if i == (totals.count - 1) && i == 0 {
                    if rightTotals.count >= leftTotals.count {
                        NSLayoutConstraint.activate([
                            view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -padding),
                            view.widthAnchor.constraint(equalToConstant: itemWidth),
                            view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem),
                            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
                        ])
                        
                    } else {
                        NSLayoutConstraint.activate([
                            view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
                            view.widthAnchor.constraint(equalToConstant: itemWidth),
                            view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem)
                        ])
                        
                    }
                    
                }
                    
                // first cell
                else {
                    NSLayoutConstraint.activate([
                        view.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
                        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
                        view.widthAnchor.constraint(equalToConstant: 100),
                        view.heightAnchor.constraint(equalToConstant: CGFloat(value) * pixelPerItem)
                    ])
                }
            }
            
            contentView.layoutIfNeeded()
            rightViews.append(view)
            i += 1
            
        }
    }
    
    //MARK: - Sankey Lines
    fileprivate func drawSankeyLines() {
        
        for (key,values) in sankeyItems {
            // left point
            guard let leftView = (leftViews.filter { $0.titleTag == key}).first else {continue}
            
            for value in values {
                //right point
                guard let rightView = (rightViews.filter {$0.titleTag == value.name}).first else {continue}
                
                // centerLeft & centerRight
                let leftDrawPoint = leftItemNewLineDrawPoint[key] == nil ? 0 : leftItemNewLineDrawPoint[key]!
                let leftY = leftView.frame.minY + leftDrawPoint
                leftItemNewLineDrawPoint[key] = leftDrawPoint + pixelPerItem * CGFloat(value.volume)
                let centerLeft = CGPoint(x: (leftView.frame.maxX), y: leftY)
                
                
                let rightDrawPoint = rightItemNewLineDrawPoint[value.name] == nil ? 0 : rightItemNewLineDrawPoint[value.name]!
                let rightY = rightView.frame.minY + rightDrawPoint
                rightItemNewLineDrawPoint[value.name] = rightDrawPoint + pixelPerItem * CGFloat(value.volume)
                
                let centerRight = CGPoint(x: (rightView.frame.minX), y: rightY)
                 
                drawLine(start: centerLeft, end: centerRight, lineWidth: pixelPerItem * CGFloat(value.volume))
            }
        }
    }

    func drawLine(start:CGPoint, end:CGPoint, lineWidth:CGFloat) {
        let linePath = UIBezierPath()
        
        let newStart = CGPoint(x: start.x, y: start.y + lineWidth/2)
        let newEnd = CGPoint(x: end.x, y: end.y + lineWidth/2)
        
        linePath.move(to: newStart)
        linePath.addCurve(to: newEnd, controlPoint1: CGPoint(x: newEnd.x, y: newStart.y), controlPoint2: CGPoint(x: newStart.x, y: newEnd.y))
        
        
        
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.random().withAlphaComponent(0.3).cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.path = linePath.cgPath
        lineLayer.lineWidth = lineWidth
        
        lineLayer.name = "line"
        layer.addSublayer(lineLayer)
    }
    
    
    
    
    
    
    fileprivate func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: heightAnchor)
        heightConstraint.priority = UILayoutPriority(250) //very important
        NSLayoutConstraint.activate([
            heightConstraint,
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
    }

}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}







extension Int {
    var pixelPerItem: CGFloat {
        switch self {
        case 0...50:
            return 0.5
        case 51...100:
            return 0.4
        case 100...200:
            return 0.2
        case let x where x > 200:
            return 0.1
        default:
            return 6
        }
    }
    

}
