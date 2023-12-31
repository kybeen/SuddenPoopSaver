//
//  ClusterAnnotationView.swift
//  SuddenPoopSaver
//
//  Created by 김영빈 on 2023/11/05.
//

import UIKit
import MapKit

final class ClusterAnnotationView: MKAnnotationView {

    static let identifier = "clusterAnnotationView"
    
    var toiletCountLabel = ""
    override var annotation: MKAnnotation? {
        didSet {
            guard let annotation = annotation as? MKClusterAnnotation else {
                return
            }
            toiletCountLabel = annotation.memberAnnotations.count < 100 ? "\(annotation.memberAnnotations.count)" : "99+"
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            let totalToilets = cluster.memberAnnotations.count
            
//            image = drawClusterAnnotation(totalToilets, color: UIColor.gray)
            image = drawRatio(0, to: totalToilets, fractionColor: nil, wholeColor: UIColor.gray)
        }
    }
    
//    private func drawClusterAnnotation(_ count: Int, color: UIColor?) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
//        return renderer.image { _ in
//            // Fill full circle with wholeColor
//            color?.setFill()
//            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
//            
//            // Finally draw count text vertically and horizontally centered
//            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
//                              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
//            let size = toiletCountLabel.size(withAttributes: attributes)
//            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
//            toiletCountLabel.draw(in: rect, withAttributes: attributes)
//        }
//    }
    
    private func drawRatio(_ fraction: Int, to whole: Int, fractionColor: UIColor?, wholeColor: UIColor?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in
            // Fill full circle with wholeColor
            wholeColor?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()

            // Fill pie with fractionColor
            fractionColor?.setFill()
            let piePath = UIBezierPath()
            piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                           startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(fraction)) / CGFloat(whole),
                           clockwise: true)
            piePath.addLine(to: CGPoint(x: 20, y: 20))
            piePath.close()
            piePath.fill()

            // Fill inner circle with white color
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()

            // Finally draw count text vertically and horizontally centered
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
            let size = toiletCountLabel.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            toiletCountLabel.draw(in: rect, withAttributes: attributes)
        }
    }
}
