//
//  MainWindowControllerDataSource.swift
//  testOutline
//
//  Created by thierryH24 on 30/07/2021.
//

import AppKit


extension MainWindowController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if item == nil {
            return feeds.count
        }

        if let feed = item as? Datas {
            return feed.children.count
        }
        
        if let feed = item as? Children {
            return feed.split.count
        }
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if item == nil {
            let feed = feeds[index]
            return feed
        }

        if let feed = item as? Datas {
            return feed.children[index]
        }
        if let feed = item as? Children {
            return feed.split[index]
        }

        return "child index : BAD ITEM"
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return isSourceGroupItem(item)
    }
    
    func isSourceGroupItem(_ item: Any) -> Bool
    {
        if item is Datas {
            return true
        }
        if item is Children {
            return true
        }
        if item is Split {
            return false
        }
        return false
    }
    
    /* When the outline view is saving the expanded items, this method is called for each expanded
         item, to translate the outline view item to an archived object.
     */
// MARK: - EncodeExpansion
    func outlineView(_ outlineView: NSOutlineView, persistentObjectForItem item: Any?) -> Any? {
        
        if let group = item as? Datas {
            return (group.identifier)
        }
        return nil
    }
    
    // MARK: - RestoreExpansion
    // Invoked by outlineView to return the item for the archived object.
    func outlineView(_ outlineView: NSOutlineView, itemForPersistentObject object: Any) -> Any? {
        
        if let identifier = object as? String {
            let id = Int( identifier)!
            if id < 1000 {
                let item = nodeFromData(identifier: id, nodes: feeds)
                return (item)
            }
        }
        return nil
    }
    
    // identifier must be unique
    private func nodeFromData(identifier: Int, nodes: [Datas]) -> Datas? {
        for node in nodes {
            if Int(node.identifier) ==  identifier {
                return node
            }
        }
        return nil
    }
    
//    private func nodeFromChildren(anObject: String, nodes: [Children]) -> Children? {
//        for node in nodes {
//            if node.identifier == anObject {
//                return node
//            }
//        }
//        return nil
//    }
    
    
}
