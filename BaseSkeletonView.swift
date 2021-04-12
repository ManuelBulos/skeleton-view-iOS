//
//  BaseSkeletonView.swift
//  skeleton
//
//  Created by Manuel on 27/01/21.
//

import UIKit

public class BaseSkeletonView: UIView {

    public var centerColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) {
        didSet {
            gradientLayer.colors = [sideCGColor, centerCGColor, sideCGColor]
        }
    }

    public var sideColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) {
        didSet {
            gradientLayer.colors = [sideCGColor, centerCGColor, sideCGColor]
        }
    }

    public var cornerRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = cornerRadius
            gradientLayer.cornerRadius = cornerRadius

            if cornerRadius > 0.0 {
                clipsToBounds = true
            }
        }
    }

    public var animationDuration: CFTimeInterval = 1.0 {
        didSet {
            startPointAnimation.duration = animationDuration
            endPointAnimation.duration = animationDuration
            animationGroup.duration = animationDuration + waitingDuration
            restartAnimation()
        }
    }

    public var waitingDuration: CFTimeInterval = 0.5 {
        didSet {
            animationGroup.duration = animationDuration + waitingDuration
            restartAnimation()
        }
    }

    let animationKey = "GradientAnimation"
    let fromGradientPoints = (start: CGPoint(x: -1.0, y: 0.5), end: CGPoint(x: 0.0, y: 0.5))
    let toGradientPoints = (start: CGPoint(x: 1.0, y: 0.5), end: CGPoint(x: 2.0, y: 0.5))

    var centerCGColor: CGColor {
        return centerColor.cgColor
    }

    var sideCGColor: CGColor {
        return sideColor.cgColor
    }

    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [sideCGColor, centerCGColor, sideCGColor]

        gradientLayer.startPoint = fromGradientPoints.start
        gradientLayer.endPoint = fromGradientPoints.end

        return gradientLayer
    }()

    lazy var startPointAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
        animation.fromValue = fromGradientPoints.start
        animation.toValue = toGradientPoints.end
        animation.duration = animationDuration

        return animation
    }()

    lazy var endPointAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        animation.fromValue = fromGradientPoints.end
        animation.toValue = toGradientPoints.end
        animation.duration = animationDuration

        return animation
    }()

    lazy var animationGroup: CAAnimationGroup = {
        let group = CAAnimationGroup()
        group.animations = [startPointAnimation, endPointAnimation]
        group.duration = animationDuration + waitingDuration
        group.repeatCount = .infinity

        return group
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        layer.cornerRadius = cornerRadius
        gradientLayer.cornerRadius = cornerRadius

        if cornerRadius > 0.0 {
            clipsToBounds = true
        }
    }

    func setUp() {
        layer.addSublayer(gradientLayer)
        startAnimation()
    }

    func startAnimation() {
        gradientLayer.add(animationGroup, forKey: animationKey)
    }

    func restartAnimation() {
        gradientLayer.removeAnimation(forKey: animationKey)
        startAnimation()
    }

}
