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
        if let feedItem = item as? Split {
            return trackingSplit ( outlineView, tableColumn: tableColumn, item: feedItem)
        }
        return nil
    }
    
    func trackingFolder(_ outlineView: NSOutlineView, folderItem: Datas) -> NSView? {
        
        var cellView: KSHeaderCellView?
        
        cellView = outlineView.makeView(withIdentifier: .FeedCell, owner: self) as? KSHeaderCellView
        
        cellView?.textField?.font = NSFont(name:"Arial", size: 32)
        cellView?.textField?.stringValue = folderItem.name + " " + folderItem.amount
        cellView?.textField?.textColor = .textColor

        cellView?.fillColor = .green
        return cellView
    }
    
    func trackingTransaction(_ outlineView: NSOutlineView, tableColumn: NSTableColumn?, item: Children) -> NSView? {
        
        var cellView: CategoryCellView?
        
        let identifier = tableColumn!.identifier
        guard let propertyEnum = ListeOperationsDisplayProperty(rawValue: identifier.rawValue) else { return nil }
        
        if identifier.rawValue == "mode"
        {
            cellView = outlineView.makeView(withIdentifier: .FeedItemCell, owner: self) as? CategoryCellView
        } else
        {
            cellView = outlineView.makeView(withIdentifier: identifier, owner: self) as? CategoryCellView
        }
        
        let textField = (cellView?.textField!)
        
        textField?.stringValue = ""
        textField?.textColor = NSColor.blue
        
        switch propertyEnum
        {
        case .mode:
            textField?.stringValue = item.mode
            textField?.textColor = NSColor.blue

        case .date:
            textField?.stringValue = item.date
            textField?.textColor = NSColor.green

        case .category:
            textField?.stringValue = item.category
            textField?.textColor = NSColor.orange
            
        case .comment:
            textField?.stringValue = item.comment
            textField?.textColor = NSColor.yellow
        }
        return cellView
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        if outlineView == self.testOutlineView {
            if isSourceGroupItem(item) == false {
                return 14.0
            } else {
                return 16.0
            }
        }
        return 10.0
    }
    
    func trackingSplit(_ outlineView: NSOutlineView, tableColumn: NSTableColumn?, item: Split) -> NSView? {
        
        var cellView: CategoryCellView?
        
        let identifier = tableColumn!.identifier
        guard let propertyEnum = ListeOperationsDisplayProperty(rawValue: identifier.rawValue) else { return nil }
        
        if identifier.rawValue == "mode"
        {
            cellView = outlineView.makeView(withIdentifier: .FeedItemCell, owner: self) as? CategoryCellView
        } else
        {
            cellView = outlineView.makeView(withIdentifier: identifier, owner: self) as? CategoryCellView
        }
        
        let textField = (cellView?.textField!)
        
        textField?.stringValue = ""
        textField?.textColor = NSColor.blue
        
        switch propertyEnum
        {
        case .mode:
            textField?.stringValue = item.rubric
            textField?.textColor = NSColor.red

        case .date:
            textField?.stringValue = item.amount
            textField?.textColor = NSColor.purple

        default:
            textField?.stringValue = ""
            textField?.textColor = NSColor.clear
        }
        return cellView
    }

    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        return MyNSTableRowView()
    }
    
        // Returns a Boolean that indicates whether a given row should be drawn in the ???group row??? style.
    public func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool
    {
        if item is Datas {
            return true
        }
        return false
    }
    
    func outlineViewSelectionDidChange(_ aNotification: Notification) {
    
        let selectedRow = testOutlineView.selectedRow
        if selectedRow != -1 { // else crash
            let myRowView = testOutlineView.rowView(atRow: selectedRow, makeIfNecessary: false)
            myRowView?.isEmphasized = false
        }
    }

}

