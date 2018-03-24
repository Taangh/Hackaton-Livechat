//
//  OXPatternLock.swift
//  OXPatternLock
//
//  Created by Dmitriy Azarov on 11/01/2017.
//  Copyright © 2017 http://oxozle.com. All rights reserved.
//  https://github.com/oxozle/OXPatternLock
//
//

import Foundation
import UIKit


/// OXPatternLock Delegate
public protocol OXPatternLockDelegate: class {
    
    /// Occurs when user ended to track pattern lock
    ///
    /// - Parameters:
    ///   - patterLock: instance of locker
    ///   - track: array of integers, which user tracked
    func didPatternInput(patterLock: OXPatternLock, track: [Int])
}


/// UI Element represent pattern lock
@IBDesignable
open class OXPatternLock: UIControl {
    public weak var delegate: OXPatternLockDelegate?
    
    
    /// Default state image
    @IBInspectable
    public var dot: UIImage? {
        didSet {
            updateLayoutConfiguration()
        }
    }
    
    
    /// Tracked state image
    @IBInspectable
    public var dotSelected: UIImage?{
        didSet {
            updateLayoutConfiguration()
        }
    }

    
    
    /// Grid size
    @IBInspectable
    public var lockSize: Int = 3{
        didSet {
            updateLayoutConfiguration()
        }
    }

    
    
    /// Color of track line
    @IBInspectable
    public var trackLineColor: UIColor = UIColor.white{
        didSet {
            updateLayoutConfiguration()
        }
    }

    
    
    /// Thickness of track line
    @IBInspectable
    public var trackLineThickness: CGFloat = 5{
        didSet {
            updateLayoutConfiguration()
        }
    }

    
    private var lockTrack = [Int]()
    private var lockFrames = [CGRect]()
    
    
    //MARK: Draw
    open override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        
        guard let ctx = UIGraphicsGetCurrentContext() else {return}
        guard let dot = dot else {return}
        guard let dotSelected = dotSelected else {return}
        
        #if !TARGET_INTERFACE_BUILDER
            // this code will run in the app itself
        #else
            prepareTrackForInterfaceBuilder()
        #endif
        
        if !lockTrack.isEmpty {
            drawTrackPath(ctx: ctx)
        }
        
        for (index,dotRect) in lockFrames.enumerated() {
            if lockTrack.contains(index) {
                dotSelected.draw(in: dotRect)
            } else {
                dot.draw(in: dotRect)
            }
        }
    }
    
    private func drawTrackPath(ctx: CGContext) {
        let path = UIBezierPath()
        
        for i in 0..<lockTrack.count - 1 {
            let index = lockTrack[i]
            let indexTo = lockTrack[i+1]
            let rect = lockFrames[index]
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            
            let rectTo = lockFrames[indexTo]
            path.addLine(to: CGPoint(x: rectTo.midX, y: rectTo.midY))
        }
        
        trackLineColor.set()
        ctx.setLineWidth(trackLineThickness)
        ctx.setLineCap(.round)
        ctx.setLineJoin(.round)
        ctx.addPath(path.cgPath)
        ctx.strokePath()
    }
    
    //MARK: Layout
    
    private func updateLayoutConfiguration() {
        guard let dot = dot else {return}
        guard let _ = dotSelected else {return}
        
        let rect = self.frame
        let spacing = (rect.width - (CGFloat(lockSize) * dot.size.width)) / CGFloat(lockSize + 1)
        let iconSize = dot.size
        lockFrames.removeAll()
        
        
        for y in 0..<lockSize {
            for x in 0..<lockSize {
                let point = CGPoint(x: spacing + CGFloat(x) * (iconSize.width + spacing), y: spacing + CGFloat(y) * (iconSize.width + spacing))
                let dotRect = CGRect(origin: point, size: iconSize)
                lockFrames.append(dotRect)
            }
        }
    }
    
    
    //MARK: Tracking
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        lockTrack.removeAll()
        let point = touch.location(in: self)
        if hitTestInLockFrames(at: point) {
            setNeedsDisplay()
        }
        return super.beginTracking(touch, with: event)
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        if hitTestInLockFrames(at: point) {
            setNeedsDisplay()
        }
        return super.continueTracking(touch, with: event)
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if lockTrack.count >= 2 {
            delegate?.didPatternInput(patterLock: self, track: lockTrack)
        }
        lockTrack.removeAll()
        setNeedsDisplay()
        super.endTracking(touch, with: event)
    }
    
    private func hitTestInLockFrames(at point: CGPoint) -> Bool {
        for (index, rect) in lockFrames.enumerated() {
            if rect.contains(point) {
                if !lockTrack.contains(index) {
                    lockTrack.append(index)
                }
                return true
            }
        }
        
        return false
    }
    
    //MARK: IBDesignable
    private func prepareTrackForInterfaceBuilder() {
        lockTrack.removeAll()
        lockTrack.append(0)
        lockTrack.append(1)
        lockTrack.append(lockSize)
        lockTrack.append(lockSize + 1)
        lockTrack.append(lockSize * 2 + 1)
    }
}

