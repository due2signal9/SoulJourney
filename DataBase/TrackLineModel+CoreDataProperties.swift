//
//  TrackLineModel+CoreDataProperties.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/31.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TrackLineModel {

    @NSManaged var photo_url: String?
    @NSManaged var title: String?
    @NSManaged var daycount: NSNumber?
    @NSManaged var date: String?
    @NSManaged var id: String?

}
