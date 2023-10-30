

import fXDObjC


class __temp__: FXDmoduleCoredata {

}

extension FXDmoduleCoredata {
	public static var documentSearchPath: String = {
		let searchPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last

		return searchPath ?? ""
	}()

	@objc public func startObservingCoreDataNotifications() {
		let notificationCenter = NotificationCenter.default

		//FXDobserverApplication
		notificationCenter.addObserver(self, selector: #selector(observedUIApplicationWillTerminate(_:) ), name: UIApplication.willTerminateNotification, object: nil)

		//FXDobserverNSManagedObject
		notificationCenter.addObserver(self, selector: #selector(observedUIDocumentStateChanged(_:)), name: UIDocument.stateChangedNotification, object: nil)

		//DEPRECATED: API_DEPRECATED("Please see the release notes and Core Data documentation.", macosx(10.7,10.12), ios(5.0,10.0));
		//https://developer.apple.com/documentation/coredata/nspersistentstoredidimportubiquitouscontentchangesnotification
		/*
		notificationCenter.addObserver(self, selector: #selector(observedNSPersistentStoreDidImportUbiquitousContentChanges(_:)), name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: nil)
		 */

		let observedContext = mainDocument?.managedObjectContext.parent
		fxdPrint("observedContext: \(String(describing: observedContext))")

		notificationCenter.addObserver(self, selector: #selector(observedNSManagedObjectContextObjectsDidChange(_:)), name: NSManagedObjectContext.didChangeObjectsNotification, object: observedContext)
		notificationCenter.addObserver(self, selector: #selector(observedNSManagedObjectContextWillSave(_:)), name: NSManagedObjectContext.willSaveObjectsNotification, object: observedContext)
		notificationCenter.addObserver(self, selector: #selector(observedNSManagedObjectContextDidSave(_:)), name: NSManagedObjectContext.didSaveObjectsNotification, object: observedContext)
	}

	@objc public func deleteAllData(finishCallback: FXDcallbackFinish? = nil) {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

		let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action in
			finishCallback?(#function, false, nil)
		}

		let deleteAction = UIAlertAction(title: NSLocalizedString("Delate All", comment: ""), style: .destructive) {
			[weak self] action in

			self?.enumerateAllData(
				withPrivateContext: false,
				shouldShowInformationView: true) {
					(managedContext, mainEntityObj, shouldBrake) in

					if shouldBrake?.pointee.boolValue == true {
						fxdPrint("shouldBrake?.pointee.boolValue: \(String(describing: shouldBrake?.pointee.boolValue))")
					}

					if mainEntityObj != nil {
						managedContext?.delete(mainEntityObj!)
					}

				} withFinishCallback: {
					(caller, didFinish, responseObj) in

					fxdPrint("\(String(describing: caller)) \(didFinish) \(String(describing: responseObj))")

					self?.saveMainDocument(finishCallback: finishCallback)
				}
		}

		alertController.addAction(deleteAction)
		alertController.addAction(cancelAction)

		let mainWindow = UIApplication.shared.mainWindow()
		let presentingViewController = mainWindow?.rootViewController
		presentingViewController?.present(alertController, animated: true)
	}

	@objc public func saveMainDocument(finishCallback: FXDcallbackFinish? = nil) {	fxd_log()
		fxdPrint("documentState: \(String(describing: mainDocument?.documentState))")
		fxdPrint("hasUnsavedChanges: \(String(describing: mainDocument?.hasUnsavedChanges))")
		fxdPrint("fileURL: \(String(describing: mainDocument?.fileURL))")

		guard let fileURL = mainDocument?.fileURL else {
			DispatchQueue.main.async {
				finishCallback?(#function, false, nil)
			}
			return
		}


		Task {	[weak self] in
			let didSave = await self?.mainDocument?.save(to: fileURL, for: .forOverwriting) ?? false

			fxd_log()
			fxdPrint("didSave: \(String(describing: didSave))")
			
			fxdPrint("documentState: \(await String(describing: self?.mainDocument?.documentState))")
			fxdPrint("hasUnsavedChanges: \(await String(describing: self?.mainDocument?.hasUnsavedChanges))")

			DispatchQueue.main.async {
				finishCallback?(#function, didSave, nil)
			}
		}
	}
}

extension FXDmoduleCoredata: FXDobserverApplication {
	public func observedUIApplicationDidEnterBackground(_ notification: NSNotification) {
	}
	
	public func observedUIApplicationDidBecomeActive(_ notification: NSNotification) {
	}
	
	public func observedUIApplicationWillTerminate(_ notification: NSNotification) {	fxd_log()

		let application = UIApplication.shared
		fxdPrint("backgroundTimeRemaining: \(application.backgroundTimeRemaining)")

		dataSavingTask = 
		application.beginBackgroundTask(expirationHandler: {
			[weak self] in

			if let dataSavingTask = self?.dataSavingTask {
				application.endBackgroundTask(dataSavingTask)
				self?.dataSavingTask = .invalid
			}
		})

		fxdPrint("dataSavingTask: \(dataSavingTask)")

		saveMainDocument {
			[weak self] (caller, didFinish, responseObj) in
			
			fxdPrint(caller as Any)
			fxdPrint("backgroundTimeRemaining: \(application.backgroundTimeRemaining)")

			fxdPrint("dataSavingTask: \(String(describing: self?.dataSavingTask))")

			if let dataSavingTask = self?.dataSavingTask {
				application.endBackgroundTask(dataSavingTask)
				self?.dataSavingTask = .invalid
			}
		}
	}
	
	public func observedUIApplicationDidReceiveMemoryWarning(_ notification: NSNotification) {
	}
	
	public func observedUIDeviceBatteryLevelDidChange(_ notification: NSNotification) {
	}
	
	public func observedUIDeviceOrientationDidChange(_ notification: NSNotification) {
	}
}


extension FXDmoduleCoredata: FXDobserverNSManagedObject {
	@objc public func observedUIDocumentStateChanged(_ notification: Notification?) {	fxd_log()
		fxdPrint("notification: \(String(describing: notification))")
		fxdPrint("fileModificationDate: \(String(describing: mainDocument?.fileModificationDate))")
		fxdPrint("documentState: \(String(describing: mainDocument?.documentState))")
	}

	@objc public func observedNSPersistentStoreDidImportUbiquitousContentChanges(_ notification: Notification?) {
		fxd_overridable()
		fxdPrint("notification: \(String(describing: notification))")
	}

	@objc public func observedNSManagedObjectContextObjectsDidChange(_ notification: Notification?) {
		fxd_overridable()
		fxdPrint("concurrencyType: \(String(describing: (notification?.object as? NSManagedObjectContext)?.concurrencyType))")
	}

	@objc public func observedNSManagedObjectContextWillSave(_ notification: Notification?) {
		fxd_overridable()
		fxdPrint("concurrencyType: \(String(describing: (notification?.object as? NSManagedObjectContext)?.concurrencyType))")
	}

	@objc public func observedNSManagedObjectContextDidSave(_ notification: Notification?) {
		fxd_overridable()
		fxdPrint("concurrencyType: \(String(describing: (notification?.object as? NSManagedObjectContext)?.concurrencyType))")

		//MARK: Distinguish notification from main managedObjectContext and private managedObjectContext
		let observedContext = notification?.object as? NSManagedObjectContext
		fxdPrint("observedContext: \(String(describing: observedContext))")

		guard observedContext?.isEqual(mainDocument?.managedObjectContext.parent) ?? false else {
			return
		}


		let mainPersistentStore = mainDocument?.managedObjectContext.persistentStoreCoordinator?.persistentStores.first
		let observedPersistentStore = observedContext?.persistentStoreCoordinator?.persistentStores.first

		let mainStoreUUID: String = mainPersistentStore?.metadata["NSStoreUUID"] as? String ?? ""
		let observedStoreUUID: String = observedPersistentStore?.metadata["NSStoreUUID"] as? String ?? ""

		//MARK: Merge only if persistentStore is same
		fxdPrint("mainStoreUUID: \(mainStoreUUID)")
		fxdPrint("observedStoreUUID: \(observedStoreUUID)")
		fxdPrint("mainStoreUUID == observedStoreUUID: \(mainStoreUUID == observedStoreUUID)")
		guard mainStoreUUID.isEmpty == false
				&& observedStoreUUID.isEmpty == false
				&& mainStoreUUID == observedStoreUUID
		else {
			return
		}


		#if DEBUG
		if let userInfo: [String : Any?] = notification?.userInfo as? [String : Any?] {
			fxdPrint("inserted.count : \(String(describing: (userInfo["inserted"] as? Array<Any?>)?.count))")
			fxdPrint("deleted.count : \(String(describing: (userInfo["deleted"] as? Array<Any?>)?.count))")
			fxdPrint("updated.count : \(String(describing: (userInfo["updated"] as? Array<Any?>)?.count))")
		}
		#endif

		mainDocument?.managedObjectContext.perform {
			fxdPrint(#function)

			if notification != nil {
				self.mainDocument?.managedObjectContext.mergeChanges(fromContextDidSave: notification!)
			}
			fxdPrint("DID MERGE: hasChanges: \(String(describing: self.mainDocument?.managedObjectContext.hasChanges))")
		}
	}
}
