//
//  MainWindowControllerDelegate.swift
//  testOutline
//
//  Created by thierryH24 on 30/07/2021.
//

import AppKit


extension MainWindowController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
    {
        outlineView.columnAutoresizingStyle = NSTableView.ColumnAutoresizingStyle.sequentialColumnAutoresizingStyle
        
        if let feed = item as? Datas {
            return trackingFolder( outlineView, folderItem: feed)
        }
        
        if let feedItem = item as? Children {
            return trackingTransaction ( outlineView, tableColumn: tableColumn, item: feedItem)
        }
        return nil
    }
    
    func trackingFolder(_ outlineView: NSOutlineView, folderItem: Datas) -> NSView? {
        
        var cellView: KSHeaderCellView?
        
        cellView = outlineView.makeView(withIdentifier: .FeedCell, owner: self) as? KSHeaderCellView
        //        cellView = outlineView.makeView(withIdentifier: .FeedCell, owner: self) as? NSTableCellView
        print (  folderItem.name)
        cellView?.textField?.stringValue = folderItem.name
        cellView?.textField?.textColor = .labelColor
//        cellView?.textField?.font = NSFont.boldSystemFont(ofSize: 14.0)
        cellView?.fillColor = .green

        //        cellView?.textField?.sizeToFit()
        
        return cellView
    }
    
    
    func trackingTransaction(_ outlineView: NSOutlineView, tableColumn: NSTableColumn?, item: Children) -> NSView? {
        
        var cellView: NSTableCellView?
        
        let identifier = tableColumn!.identifier
        guard let propertyEnum = ListeOperationsDisplayProperty(rawValue: identifier.rawValue) else { return nil }
        
        if identifier.rawValue == "mode"
        {
            cellView = outlineView.makeView(withIdentifier: .FeedItemCell, owner: self) as? NSTableCellView
        } else
        {
            cellView = outlineView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
        }
        let textField = (cellView?.textField!)!
        textField.stringValue = ""
        
        switch propertyEnum
        {
        case .mode:
            textField.stringValue = item.mode
//            textField.sizeToFit()
            
        case .date:
            textField.stringValue = item.date
//            textField.sizeToFit()
            
        case .category:
            textField.stringValue = item.category
//            textField.sizeToFit()
        }
        return cellView
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        if isSourceGroupItem(item) == false {
            return 16.0
        } else {
            return 18.0
        }
    }
    
//    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
//        return MyNSTableRowView()
//    }

    
    // Returns a Boolean that indicates whether a given row should be drawn in the “group row” style.
    public func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool
    {
        if item is Datas {
            return true
        }
        return false
    }
    
    // MARK: -
    class MyNSTableRowView: NSTableRowView {
        
        static let backgroundColor = NSColor(red: 0.76, green: 0.82, blue: 0.92, alpha: 1)
    
        init()
        {
            super.init(frame: .zero)
            isTargetForDropOperation = false
            draggingDestinationFeedbackStyle = .none
            selectionHighlightStyle = .none
        }
        
        required init?(coder decoder: NSCoder) { nil }
        
        override func drawBackground(in dirtyRect: NSRect) {} // this avoids a visual bug
        override func drawSeparator(in dirtyRect: NSRect) {}
        
        override func drawSelection(in dirtyRect: NSRect) {
            super.drawSelection(in: dirtyRect)
            
            if isSelected == false {
                NSColor.selectedControlColor.set()
                __NSRectFill(dirtyRect)
            } else {
                backgroundColor.set()
                __NSRectFill(dirtyRect)
            }
        }
    }
}
