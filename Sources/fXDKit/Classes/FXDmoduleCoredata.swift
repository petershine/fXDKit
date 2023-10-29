

import fXDObjC


extension FXDmoduleCoredata {
	public static var documentSearchPath: String = {
		let searchPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last

		return searchPath ?? ""
	}()
}


extension FXDmoduleCoredata {
	@objc public func observedUIDocumentStateChanged(_ notification: Notification?) {	fxd_log()

		fxdPrint("notification: \(String(describing: notification))")
		fxdPrint("fileModificationDate: \(String(describing: self.mainDocument?.fileModificationDate))")
		fxdPrint("documentState: \(String(describing: self.mainDocument?.documentState))")
	}

	@objc public func observedNSManagedObjectContextObjectsDidChange(_ notification: Notification?) {

		fxd_overridable()
		fxdPrint("concurrencyType: \(String(describing: (notification?.object as? NSManagedObjectContext)?.concurrencyType))")
	}

	@objc public func observedNSManagedObjectContextWillSave(_ notification: Notification?) {

		fxd_overridable()
		fxdPrint("concurrencyType: \(String(describing: (notification?.object as? NSManagedObjectContext)?.concurrencyType))")
	}

	//DEPRECATED: API_DEPRECATED("Please see the release notes and Core Data documentation.", macosx(10.7,10.12), ios(5.0,10.0));
	/*
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSPersistentStoreDidImportUbiquitousContentChanges:)
	 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
	 object:nil];
	 */
	@objc public func observedNSPersistentStoreDidImportUbiquitousContentChanges(_ notification: Notification?) {

		fxd_overridable()
		fxdPrint("notification: \(String(describing: notification))")
	}
}
