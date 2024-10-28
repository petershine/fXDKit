

import fXDObjC


//MARK: For subclass to define names or keys
/* SAMPLE:
 #define entityname<#DefaultClass#> @"<#AppPrefix#>entity<#DefaultClass#>"
 #define attribkey<#AttributeName#> @"<#AttributeName#>"
 */

//MARK: Logging options
// -com.apple.CoreData.SQLDebug 1 || 2 || 3
// -com.apple.CoreData.Ubiquity.LogLevel 1 || 2 || 3


open class FXDmoduleCoredata: NSObject, @unchecked Sendable {
	private var enumeratingTask: UIBackgroundTaskIdentifier? = nil
	private var dataSavingTask: UIBackgroundTaskIdentifier? = nil

    public var mainDocument: UIManagedDocument? = nil


	public var documentSearchPath: String = {
		return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
	}()

	var appDocumentDirectory: URL? = {
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
	}()

    var appCachesDirectory: URL? = {
		return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last
	}()


	lazy var enumeratingOperationQueue: OperationQueue? = {
		return OperationQueue.newSerialQueue(withName: #function)
	}()

	lazy open var coredataName: String? = {	fxd_overridable()
		return Bundle.main.bundleIdentifier
	}()

	lazy open var ubiquitousContentName: String? = {	fxd_overridable()
		return coredataName?.replacingOccurrences(of: ".", with: "_")
	}()

	lazy open var sqlitePathComponent: String? = {	fxd_overridable()
		#if DEBUG
		return "DEV_\(coredataName ?? "").sqlite"
		#else
		return "\(coredataName ?? "").sqlite"
		#endif
	}()

    lazy open var mainEntityName: String? = {	fxd_overridable()
		//SAMPLE: _mainEntityName = entityname<#DefaultClass#>
		return nil
	}()

	lazy open var mainSortDescriptors: [Any]? = {	fxd_overridable()
		//SAMPLE: _mainSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attribkey<#AttributeName#> ascending:<#NO#>]];
		return nil
	}()


	public var doesStoredSqliteExist: Bool {	fxd_log()
		let storedPath = (documentSearchPath as NSString).appendingPathComponent(sqlitePathComponent ?? "")
		fxdPrint("storedPath: \(storedPath)")

		let doesExist = FileManager.default.fileExists(atPath: storedPath)
		fxdPrint("doesExist: \(doesExist)")

		return doesExist
	}

	
	deinit {
		enumeratingOperationQueue?.cancelAllOperations()
	}

	public func initialize(withBundledSqliteFile sqliteFile: String) -> Bool {
		guard doesStoredSqliteExist == false else {
			return false
		}


		fxd_log()
		let bundledSqlitePath = Bundle.main.path(forResource: sqliteFile, ofType: "sqlite") ?? ""
		fxdPrint("bundledSqlitePath: \(bundledSqlitePath)")

		return storeCopiedItem(fromSqlitePath: bundledSqlitePath, toStoredPath: nil)
	}

	open func transfer(fromOldSqliteFile oldSqliteFile: String) -> Bool {
		fxd_overridable()
		guard doesStoredSqliteExist == false else {
			return false
		}


		let pathComponent = "\(oldSqliteFile).sqlite"
		let oldSqlitePath = (documentSearchPath as NSString).appendingPathComponent(pathComponent)
		fxdPrint("oldSqlitePath: \(oldSqlitePath)")

		return storeCopiedItem(fromSqlitePath: oldSqlitePath, toStoredPath: nil)
	}

	open func upgradeAllAttributesForNewDataModel(finishCallback: FXDcallback? = nil) {	fxd_overridable()
		//TODO: Learn about NSMigrationPolicy implementation

		finishCallback?(true, nil)
	}
}


extension FXDmoduleCoredata {
	public func storeCopiedItem(fromSqlitePath sqlitePath: String, toStoredPath storedPath: String?) -> Bool {	fxd_log()
		let sqliteExists = FileManager.default.fileExists(atPath: sqlitePath)
		fxdPrint("sqliteExists: \(sqliteExists)")
		guard sqliteExists else {
			return false
		}


		var defaultStoredPath = storedPath
		if defaultStoredPath == nil {
			let pathComponent = sqlitePathComponent ?? ""
			defaultStoredPath = (documentSearchPath as NSString).appendingPathComponent(pathComponent)
		}


		var didCopy: Bool = true
		do {
			try FileManager.default.copyItem(atPath: sqlitePath, toPath: defaultStoredPath ?? "")
		}
		catch {
			fxdPrint("\(error)")
			didCopy = false
		}

		fxdPrint("didCopy: \(didCopy)")

		return didCopy
	}

    @MainActor public func prepare(withUbiquityContainerURL ubiquityContainerURL: URL?, protectionOption: String?, managedDocument: UIManagedDocument?, finishCallback: FXDcallback? = nil) {	fxd_log()

		var mainManagedDocument = managedDocument
		if mainManagedDocument == nil {
			fxdPrint("CHECK if bundle has more than 1 momd")

			if let documentURL = appDocumentDirectory?.appending(path: "managedDocument.\(coredataName ?? "")") {
                fxdPrint("documentURL:", documentURL)
                mainManagedDocument = UIManagedDocument(fileURL: documentURL)
			}
		}
		assert(mainManagedDocument != nil, "[SHOULD NOT BE nil] mainManagedDocument: \(String(describing: mainManagedDocument))")


		fxdPrint("ubiquityContainerURL: ", ubiquityContainerURL)
		fxdPrint("protectionOption: ", protectionOption)
		fxdPrint("mainManagedDocument: ", mainManagedDocument)

		mainDocument = mainManagedDocument


		let rootURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
		let storeURL = rootURL?.appending(path: sqlitePathComponent ?? "")
		fxdPrint("storeURL: ", storeURL)


		var storeOptions : Dictionary<String , Any> = [:]
		storeOptions[NSMigratePersistentStoresAutomaticallyOption] = true
		storeOptions[NSInferMappingModelAutomaticallyOption] = true

		if ubiquityContainerURL != nil {
			//DEPRECATED: API_DEPRECATED("Please see the release notes and Core Data documentation.", macosx(10.7,10.12), ios(5.0,10.0));
			/*
			storeOptions[NSPersistentStoreUbiquitousContentNameKey] = ubiquitousContentName;
			storeOptions[NSPersistentStoreUbiquitousContentURLKey] = ubiquityContainerURL;
			 */
		}

		//MARK: NSFileProtectionCompleteUntilFirstUserAuthentication is already used as default
		if protectionOption?.isEmpty == false {
			storeOptions[NSPersistentStoreFileProtectionKey] = protectionOption
		}

		fxdPrint("storeOptions: \(storeOptions)")

		var didConfigure: Bool = true
		do {
			if storeURL != nil {
				try mainDocument?.configurePersistentStoreCoordinator(for: storeURL!, ofType: NSSQLiteStoreType, modelConfiguration: nil, storeOptions: storeOptions)
			}
			else {
				didConfigure = false
			}
		}
		catch {
			fxdPrint("\(error)")
			didConfigure = false
		}

		fxdPrint("1. didConfigure: \(didConfigure)")

		#if DEBUG
		let storeCoordinator: NSPersistentStoreCoordinator? = mainDocument?.managedObjectContext.persistentStoreCoordinator
		storeCoordinator?.persistentStores.forEach({
			(persistentStore: NSPersistentStore) in

			fxdPrint("", persistentStore.url)
			fxdPrint("", storeCoordinator?.metadata(for: persistentStore))
		})
		#endif

		assert(Thread.isMainThread)
		fxdPrint("2. didConfigure: \(didConfigure)")

		//MARK: If iCloud connection is not working, CHECK if cellular transferring is enabled on device"

		fxdPrint("UIManagedDocument.persistentStoreName: \(UIManagedDocument.persistentStoreName)")

		fxdPrint("modelConfiguration: ", mainDocument?.modelConfiguration)
		fxdPrint("managedObjectModel.versionIdentifiers: ", mainDocument?.managedObjectModel.versionIdentifiers)
		fxdPrint("managedObjectModel.entities: ", mainDocument?.managedObjectModel.entities)

#if DEBUG
        if ubiquityContainerURL != nil {
            fxdPrint("", FileManager.default.infoDictionary(forFolderURL: ubiquityContainerURL))
            fxdPrint("", FileManager.default.infoDictionary(forFolderURL: self.appCachesDirectory))
            fxdPrint("", FileManager.default.infoDictionary(forFolderURL: self.appDocumentDirectory))
        }
#endif

        let result: Bool = didConfigure
        upgradeAllAttributesForNewDataModel {
            (didFinish, responseObj) in

			finishCallback?((result && didFinish), nil)
			//MARK: Careful with order of operations

            DispatchQueue.main.async {
                self.startObservingCoreDataNotifications()
            }
		}
	}

    @MainActor func startObservingCoreDataNotifications() {
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
		fxdPrint("observedContext: ", observedContext)

		notificationCenter.addObserver(self, selector: #selector(observedNSManagedObjectContextObjectsDidChange(_:)), name: NSManagedObjectContext.didChangeObjectsNotification, object: observedContext)
		notificationCenter.addObserver(self, selector: #selector(observedNSManagedObjectContextWillSave(_:)), name: NSManagedObjectContext.willSaveObjectsNotification, object: observedContext)
		notificationCenter.addObserver(self, selector: #selector(observedNSManagedObjectContextDidSave(_:)), name: NSManagedObjectContext.didSaveObjectsNotification, object: observedContext)
	}

    @MainActor func deleteAllData(finishCallback: FXDcallback? = nil) {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

		let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action in
			finishCallback?(false, nil)
		}

		let deleteAction = UIAlertAction(title: NSLocalizedString("Delate All", comment: ""), style: .destructive) {
			[weak self] action in

			self?.enumerateAllData(
				withPrivateContext: false,
				shouldShowOverlay: true) {
					(managedContext, mainEntityObj, shouldBrake) in

					if shouldBrake?.pointee == true {
						fxdPrint("shouldBrake?.pointee.boolValue: ", shouldBrake?.pointee)
					}

					if mainEntityObj != nil {
						managedContext?.delete(mainEntityObj!)
					}

				} withFinishCallback: {
					(didFinish, responseObj) in

					fxdPrint(didFinish, responseObj)

                    DispatchQueue.main.async {
                        self?.saveMainDocument(finishCallback: finishCallback)
                    }
				}
		}

		alertController.addAction(deleteAction)
		alertController.addAction(cancelAction)

		let mainWindow = UIApplication.shared.mainWindow()
		let presentingViewController = mainWindow?.rootViewController
		presentingViewController?.present(alertController, animated: true)
	}

    @MainActor func enumerateAllData(withPrivateContext shouldUsePrivateContext: Bool, shouldShowOverlay shouldShowProgressView: Bool, withEnumerationBlock enumerationBlock: (@Sendable (NSManagedObjectContext?, NSManagedObject?, UnsafeMutablePointer<Bool>?) -> Void)?, withFinishCallback finishCallback: FXDcallback? = nil) {	fxd_log()

		fxdPrint("shouldUsePrivateContext: \(shouldUsePrivateContext)")
		fxdPrint("enumeratingOperationQueue?.operationCount: ", enumeratingOperationQueue?.operationCount)

		guard enumeratingOperationQueue?.operationCount == 0 else {
			finishCallback?(false, nil)
			return
		}


		enumeratingTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
			[weak self] in

			if let validTask = self?.enumeratingTask {
				UIApplication.shared.endBackgroundTask(validTask)
				self?.enumeratingTask = .invalid
			}
		})
		fxdPrint("enumeratingTask: ", enumeratingTask)

		if shouldShowProgressView {
			let mainWindow = UIApplication.shared.mainWindow()
			mainWindow?.showOverlay()
		}



        let managedContext = shouldUsePrivateContext ? mainDocument?.managedObjectContext.parent : mainDocument?.managedObjectContext
        enumeratingOperationQueue?.addOperation(BlockOperation(block: {
			[weak self] in

            var shouldBreak: Bool = false

			let fetchedObjArray = managedContext?.fetchedObjArray(forEntityName: self?.mainEntityName, withSortDescriptors: self?.mainSortDescriptors, with: nil, withLimit: UInt(limitInfiniteFetch)) as? Array<NSManagedObject>

			for fetchedObj in fetchedObjArray ?? Array<NSManagedObject>() {
				guard shouldBreak == false else {
					break
				}

				if enumerationBlock != nil {
					let mainEntityObj = managedContext?.object(with: fetchedObj.objectID)

					if shouldUsePrivateContext {
						enumerationBlock?(managedContext, mainEntityObj, &shouldBreak)
					}
					else {
                        enumerationBlock?(managedContext, mainEntityObj, &shouldBreak)
					}
				}

                DispatchQueue.main.async {
                    fxdPrint("UIApplication.shared.backgroundTimeRemaining: \(UIApplication.shared.backgroundTimeRemaining)")
                }
			}


            let didBreak: Bool = !shouldBreak

            OperationQueue.current?.addOperation(BlockOperation(block: {
                [weak self] in

                if shouldShowProgressView {
                    DispatchQueue.main.async {
                        let mainWindow = UIApplication.shared.mainWindow()
                        mainWindow?.hideOverlay(afterDelay: DURATION_QUARTER)
                    }
                }

                fxdPrint("didBreak: \(didBreak)")
                finishCallback?(didBreak, nil)

                DispatchQueue.main.async {
                    fxdPrint("UIApplication.shared.backgroundTimeRemaining: \(UIApplication.shared.backgroundTimeRemaining)")
                    fxdPrint("self?.enumeratingTask: ", self?.enumeratingTask)

                    if let validTask = self?.enumeratingTask {
                        UIApplication.shared.endBackgroundTask(validTask)
                        self?.enumeratingTask = .invalid
                    }
                }
            }))
        }))
	}

    @MainActor func saveManagedContext(_ managedContext: NSManagedObjectContext?, withFinishCallback finishCallback: FXDcallbackFinish? = nil) {	fxd_log()
		//TODO: Evaluate if this method is necessary
		fxdPrint("1. managedContext?.hasChanges: ", managedContext?.hasChanges, "concurrencyType: ", managedContext?.concurrencyType)

		var mainManagedContext = managedContext
		if mainManagedContext == nil {

			mainManagedContext = mainDocument?.managedObjectContext
			fxdPrint("2. managedContext?.hasChanges: ", mainManagedContext?.hasChanges, "concurrencyType: ", mainManagedContext?.concurrencyType)

			if mainManagedContext?.hasChanges == false
				&& mainManagedContext?.concurrencyType != mainDocument?.managedObjectContext.parent?.concurrencyType {

				mainManagedContext = mainDocument?.managedObjectContext.parent
				fxdPrint("3. managedContext?.hasChanges: ", mainManagedContext?.hasChanges, "concurrencyType: ", mainManagedContext?.concurrencyType)
			}
		}


		fxdPrint("4. mainManagedContext: ", mainManagedContext, "managedContext?.hasChanges: ", mainManagedContext?.hasChanges, "concurrencyType: ", mainManagedContext?.concurrencyType)

		guard (mainManagedContext != nil && mainManagedContext!.hasChanges) else {
			finishCallback?(#function, false, nil)
			return
		}


		let ManagedContextSavingBlock = {
			var didSave: Bool = true
			do {
				try mainManagedContext?.save()
			}
			catch {
				fxdPrint("\(error)")
				didSave = false
			}

			fxd_log()
			fxdPrint("5. didSave \(didSave) mainManagedContext: ", mainManagedContext, "managedContext?.hasChanges: ", mainManagedContext?.hasChanges, "concurrencyType: ", mainManagedContext?.concurrencyType)
		}

		fxdPrint("Thread.isMainThread: \(Thread.isMainThread)")
		if Thread.isMainThread {
			mainManagedContext?.performAndWait {
				ManagedContextSavingBlock()
			}
		}
		else {
			ManagedContextSavingBlock()
		}
	}

    public func saveMainDocument(finishCallback: FXDcallback? = nil) {	fxd_log()
        DispatchQueue.main.async { [weak self] in
            fxdPrint("documentState: ", self?.mainDocument?.documentState)
            fxdPrint("hasUnsavedChanges: ", self?.mainDocument?.hasUnsavedChanges)
            fxdPrint("fileURL: ", self?.mainDocument?.fileURL)
            
            guard (self?.mainDocument?.fileURL) != nil else {
                finishCallback?(false, nil)
                return
            }
        }


		Task {	[weak self] in
            var didSave: Bool = false
            if let fileURL = await self?.mainDocument?.fileURL {
                didSave = await self?.mainDocument?.save(to: fileURL, for: .forOverwriting) ?? false
            }

			fxd_log()
			fxdPrint("didSave: ", didSave)
			
            await fxdPrint("documentState: ", self?.mainDocument?.documentState)
            await fxdPrint("hasUnsavedChanges: ", self?.mainDocument?.hasUnsavedChanges)

            finishCallback?(didSave, nil)
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

		fxdPrint("dataSavingTask: ", dataSavingTask)

		saveMainDocument {
			[weak self] (didFinish, responseObj) in

            DispatchQueue.main.async {
                fxdPrint("backgroundTimeRemaining: \(application.backgroundTimeRemaining)")
                fxdPrint("dataSavingTask: ", self?.dataSavingTask)
                
                if let dataSavingTask = self?.dataSavingTask {
                    application.endBackgroundTask(dataSavingTask)
                    self?.dataSavingTask = .invalid
                }
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
		fxdPrint("notification: ", notification)
		fxdPrint("fileModificationDate: ", mainDocument?.fileModificationDate)
		fxdPrint("documentState: ", mainDocument?.documentState)
	}

	@objc public func observedNSPersistentStoreDidImportUbiquitousContentChanges(_ notification: Notification?) {
		fxd_overridable()
		fxdPrint("notification: ", notification)
	}

	@objc public func observedNSManagedObjectContextObjectsDidChange(_ notification: Notification?) {
		fxd_overridable()
		fxdPrint("concurrencyType: ", (notification?.object as? NSManagedObjectContext)?.concurrencyType)
	}

	@objc public func observedNSManagedObjectContextWillSave(_ notification: Notification?) {
		fxd_overridable()
		fxdPrint("concurrencyType: ", (notification?.object as? NSManagedObjectContext)?.concurrencyType)
	}

	@objc public func observedNSManagedObjectContextDidSave(_ notification: Notification?) {
		fxd_overridable()
		fxdPrint("concurrencyType: ", (notification?.object as? NSManagedObjectContext)?.concurrencyType)

		//MARK: Distinguish notification from main managedObjectContext and private managedObjectContext
		let observedContext = notification?.object as? NSManagedObjectContext
		fxdPrint("observedContext: ", observedContext)

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
			fxdPrint("inserted.count : ", (userInfo["inserted"] as? Array<Any?>)?.count)
			fxdPrint("deleted.count : ", (userInfo["deleted"] as? Array<Any?>)?.count)
			fxdPrint("updated.count : ", (userInfo["updated"] as? Array<Any?>)?.count)
		}
		#endif

		mainDocument?.managedObjectContext.perform {
			fxdPrint(#function)

			if notification != nil {
				self.mainDocument?.managedObjectContext.mergeChanges(fromContextDidSave: notification!)
			}
			fxdPrint("DID MERGE: hasChanges: ", self.mainDocument?.managedObjectContext.hasChanges)
		}
	}
}
