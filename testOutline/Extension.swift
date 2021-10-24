    //
    //  Extension.swift
    //  testOutline
    //
    //  Created by thierryH24 on 03/10/2021.
    //

import AppKit


    // MARK: - NSTableRowView

class MyNSTableRowView: NSTableRowView {
    
    override func drawSelection(in dirtyRect: NSRect) {
        if self.selectionHighlightStyle != .none {
            let selectionRect = NSInsetRect(self.bounds, 2.5, 2.5)
            NSColor(calibratedWhite: 0.65, alpha: 1).setStroke()
            NSColor(calibratedWhite: 0.82, alpha: 1).setFill()
            let selectionPath = NSBezierPath.init(roundedRect: selectionRect, xRadius: 3, yRadius: 3)
            selectionPath.fill()
            selectionPath.stroke()
        }
    }
    
    override var interiorBackgroundStyle:NSView.BackgroundStyle  {
        get
        {
            if self.isSelected == true {
                return NSView.BackgroundStyle.emphasized
            }
            else {
                return NSView.BackgroundStyle.normal
            }
        }
    }
}

    // MARK: - NSTableCellView
class CategoryCellView: NSTableCellView {
    
    var oldColor : NSColor? = nil
    var oldFont : NSFont? = nil
    
//    @IBOutlet weak var categoryTextField: NSTextField!
    
    override var backgroundStyle: NSView.BackgroundStyle {
        willSet{
            if newValue == .emphasized {
                textField?.font = NSFont.boldSystemFont(ofSize: 14)
                textField?.textColor = NSColor.textColor
            } else {
                if oldColor == nil {
                    oldColor = textField?.textColor!
                    oldFont = textField?.font
                }
                textField?.textColor = oldColor
                textField?.font = oldFont
            }
            super.backgroundStyle = newValue
        }
    }
}
