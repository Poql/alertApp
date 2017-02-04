//
//  FacetView.swift
//  HeaderBar
//
//  Created by Gaétan Zanella on 30/12/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let animationDuration: TimeInterval = 0.5
    static let animationSpringDamping: CGFloat = 0.8
    static let animationSpringVelocity: CGFloat = 0.2
    static let minimumProgress: CGFloat = 0.3
    static let minimumVelocity: CGFloat = 0.3
    static let rotationAngle: CGFloat = -90.radians
}

private class FacetTransformView: UIView {

    enum State {
        case face
        case side
    }

    private let sideContainer = UIView()

    private let faceContainer = UIView()

    private(set) var angle: CGFloat = 0 {
        didSet {
            layer.transform = CATransform3DMakeRotation(angle, 0, 1, 0)
        }
    }

    private(set) var state: State = .face

    // MARK: - UIView

    override class var layerClass: AnyClass {
        return CATransformLayer.self
    }

    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func updateFacets(face: UIView?, side: UIView?) {
        sideContainer.subviews.first?.removeFromSuperview()
        faceContainer.subviews.first?.removeFromSuperview()
        if let face = face {
            faceContainer.pin(view: face)
        }
        if let side = side {
            sideContainer.pin(view: side)
        }
    }

    func rotate(percentage: CGFloat) {
        setupViewsIfNeeded()
        angle = Constant.rotationAngle * percentage
    }

    func showSide(animated: Bool = true, duration: TimeInterval, velocity: CGFloat = 1, completion: ((Bool) -> Void)?) {
        state = .side
        if animated {
            rotate(duration: duration, angle: Constant.rotationAngle, velocity: velocity, completion: completion)
            return
        }
        angle = Constant.rotationAngle
    }

    func showFace(animated: Bool = true, duration: TimeInterval, velocity: CGFloat = 1, completion: ((Bool) -> Void)?) {
        state = .face
        if animated {
            rotate(duration: duration, angle: 0, velocity: velocity, completion: completion)
            return
        }
        angle = 0
    }

    func switchFace(animated: Bool, duration: TimeInterval = 0, completion: ((_ finished: Bool) -> Void)? = nil) {
        setupViewsIfNeeded()
        if state == .side {
            showFace(animated: animated, duration: duration, completion: completion)
            return
        }
        showSide(animated: animated, duration: duration, completion: completion)
    }

    // MARK: - Private

    private func setupView() {
        pin(view: sideContainer)
        pin(view: faceContainer)
    }

    private func rotate(duration: TimeInterval,
                        angle: CGFloat,
                        velocity: CGFloat,
                        completion: ((_ finished: Bool) -> Void)?) {
        if velocity > 0 {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                usingSpringWithDamping: Constant.animationSpringDamping,
                initialSpringVelocity: velocity,
                options: [],
                animations: { self.angle = angle },
                completion: completion
            )
            return
        }
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseOut,
            animations: { self.angle = angle },
            completion: completion
        )
    }

    private func setupViewsIfNeeded() {
        guard CATransform3DIsIdentity(sideContainer.layer.transform) else { return }
        let translation = frame.width / 2
        layer.anchorPointZ = -translation
        var transform = CATransform3DMakeTranslation(translation, 0, -translation)
        transform = CATransform3DRotate(transform, 90.radians, 0, 1, 0)
        sideContainer.layer.transform = transform
    }
}

class FacetView: UIView {

    private let faceView: UIView

    private let sideView: UIView

    private let facetTransformView = FacetTransformView()

    fileprivate lazy var gestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(recognizerAction(_:)))
        recognizer.delegate = self
        return recognizer
    }()

    private var state: FacetTransformView.State {
        return facetTransformView.state
    }

    // MARK: - UIView

    init(faceView: UIView, sideView: UIView) {
        self.faceView = faceView
        self.sideView = sideView
        super.init(frame: CGRect.zero)
        setupView()
        setupRecognizer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func switchFace(animated: Bool = true) {
        beginAnimation()
        if animated {
            facetTransformView.switchFace(animated: true, duration: Constant.animationDuration, completion: rotationCompletion)
            return
        }
        facetTransformView.switchFace(animated: false)
        rotationCompletion(true)
    }

    // MARK: - Private

    private func setupView() {
        pin(view: sideView)
        pin(view: faceView)
        pin(view: facetTransformView)
        sideView.isHidden = true
        facetTransformView.isHidden = true
    }

    private func setupRecognizer() {
        addGestureRecognizer(gestureRecognizer)
    }

    private func calculateVelocity(of gesture: UIPanGestureRecognizer) -> CGFloat {
        return max(0, fabs(gesture.velocity(in: self).x) / frame.width)
    }

    private func calculateProgress(of percentage: CGFloat) -> CGFloat {
        switch state {
        case .face:
            return percentage
        case .side:
            return 1 - percentage
        }
    }

    private func calculatePercentage(of gesture: UIPanGestureRecognizer) -> CGFloat {
        let translation = gesture.translation(in: self).x
        let percentage: CGFloat
        switch state {
        case .face:
            percentage = -translation / frame.width
        case .side:
            percentage = 1 - translation / frame.width
        }
        return max(0, min(percentage,1))
    }

    private func beginAnimation() {
        faceView.isHidden = false
        sideView.isHidden = false
        let face = faceView.snapshotView(afterScreenUpdates: true)
        let side = sideView.snapshotView(afterScreenUpdates: true)
        sideView.isHidden = true
        faceView.isHidden = true
        facetTransformView.updateFacets(face: face, side: side)
        facetTransformView.isHidden = false
    }

    private func rotate(of percentage: CGFloat) {
        facetTransformView.rotate(percentage: percentage)
    }

    private func endAnimation(duration: TimeInterval, velocity: CGFloat) {
        isUserInteractionEnabled = false
        switch state {
        case .face:
            facetTransformView.showSide(
                duration: duration,
                velocity: velocity,
                completion: rotationCompletion
            )
        case .side:
            facetTransformView.showFace(
                duration: duration,
                velocity: velocity,
                completion: rotationCompletion
            )
        }
    }

    private func cancelAnimation() {
        isUserInteractionEnabled = false
        switch state {
        case .face:
            facetTransformView.showFace(
                duration: Constant.animationDuration,
                velocity: 0,
                completion: rotationCompletion
            )
        case .side:
            facetTransformView.showSide(
                duration: Constant.animationDuration,
                velocity: 0,
                completion: rotationCompletion
            )
        }
    }

    private func rotationCompletion(_ finished: Bool) {
        isUserInteractionEnabled = true
        guard finished else { return }
        switch state {
        case .face:
            sideView.isHidden = true
            faceView.isHidden = false
            bringSubview(toFront: faceView)
        case .side:
            sideView.isHidden = false
            faceView.isHidden = true
            bringSubview(toFront: sideView)
        }
        facetTransformView.isHidden = true
    }

    // MARK: - Actions

    @objc private func recognizerAction(_ sender: UIPanGestureRecognizer) {
        let velocity = calculateVelocity(of: sender)
        let percentage = calculatePercentage(of: sender)
        let progress = calculateProgress(of: percentage)
        let validate = progress >= Constant.minimumProgress || velocity >= Constant.minimumVelocity && progress > 0
        switch sender.state {
        case .began:
            beginAnimation()
        case .changed:
            rotate(of: percentage)
        case .ended where validate:
            let duration = TimeInterval(1 - progress) * Constant.animationDuration
            endAnimation(duration: duration, velocity: velocity)
        default:
            cancelAnimation()
        }
    }
}

extension FacetView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard
            let gesture = gestureRecognizer as? UIPanGestureRecognizer, gesture == gestureRecognizer
            else {
                return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        let velocity = gesture.velocity(in: self)
        return fabs(velocity.x) > fabs(velocity.y)
    }
}

private extension Int {
    var radians: CGFloat { return CGFloat(self) * CGFloat.pi / 180 }
    var degrees: CGFloat { return CGFloat(self) * 180 / CGFloat.pi }
}

private extension UIView {
    func pin(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

