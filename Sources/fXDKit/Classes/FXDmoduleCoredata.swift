

import fXDObjC


//MARK: For subclass to define names or keys
/* SAMPLE:
 #define entityname<#DefaultClass#> @"<#AppPrefix#>entity<#DefaultClass#>"
 #define attribkey<#AttributeName#> @"<#AttributeName#>"
 */

//MARK: Logging options
// -com.apple.CoreData.SQLDebug 1 || 2 || 3
// -com.apple.CoreData.Ubiquity.LogLevel 1 || 2 || 3


open class FXDmoduleCoredata: NSObject {
	private var enumeratingTask: UIBackgroundTaskIdentifier? = nil
	private var dataSavingTask: UIBackgroundTaskIdentifier? = nil

	public var mainDocument: FXDManagedDocument? = nil


	public static var documentSearchPath: String = {
		return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
	}()

	static var appDocumentDirectory: URL? = {
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
	}()

	static var appCachesDirectory: URL? = {
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
		let storedPath = (Self.documentSearchPath as NSString).appendingPathComponent(sqlitePathComponent ?? "")
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
		let oldSqlitePath = (Self.documentSearchPath as NSString).appendingPathComponent(pathComponent)
		fxdPrint("oldSqlitePath: \(oldSqlitePath)")

		return storeCopiedItem(fromSqlitePath: oldSqlitePath, toStoredPath: nil)
	}

	open func upgradeAllAttributesForNewDataModel(finishCallback: FXDcallbackFinish? = nil) {	fxd_overridable()
		//TODO: Learn about NSMigrationPolicy implementation

		finishCallback?(#function, true, nil)
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
			defaultStoredPath = (Self.documentSearchPath as NSString).appendingPathComponent(pathComponent)
		}


		var didCopy: Bool = true
		do {
			try FileManager.default.copyItem(atPath: sqlitePath, toPath: defaultStoredPath ?? "")
		}
		catch let error {
			fxdPrint("error: \(error)")
			didCopy = false
		}

		fxdPrint("didCopy: \(didCopy)")

		return didCopy
	}

	public func prepare(withUbiquityContainerURL ubiquityContainerURL: URL?, protectionOption: String?, managedDocument: FXDManagedDocument?, finishCallback: FXDcallbackFinish? = nil) {	fxd_log()

		var mainManagedDocument = managedDocument
		if mainManagedDocument == nil {
			fxdPrint("CHECK if bundle has more than 1 momd")

			if let documentURL = Self.appDocumentDirectory?.appending(path: "managedDocument.\(coredataName ?? "")") {

				mainManagedDocument = FXDManagedDocument(fileURL: documentURL)
			}
		}
		assert(mainManagedDocument != nil, "[SHOULD NOT BE nil] mainManagedDocument: \(String(describing: mainManagedDocument))")


		fxdPrint("ubiquityContainerURL: \(String(describing: ubiquityContainerURL))")
		fxdPrint("protectionOption: \(String(describing: protectionOption))")
		fxdPrint("mainManagedDocument: \(String(describing: mainManagedDocument))")

		mainDocument = mainManagedDocument


		let rootURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
		let storeURL = rootURL?.appending(path: sqlitePathComponent ?? "")
		fxdPrint("storeURL: \(String(describing: storeURL))")


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
		catch let exception {
			fxdPrint("exception: \(exception)")
			didConfigure = false
		}

		fxdPrint("1. didConfigure: \(didConfigure)")

		#if DEBUG
		let storeCoordinator: NSPersistentStoreCoordinator? = mainDocument?.managedObjectContext.persistentStoreCoordinator
		storeCoordinator?.persistentStores.forEach({
			(persistentStore: NSPersistentStore) in

			fxdPrint("\(String(describing: persistentStore.url))")
			fxdPrint("\(String(describing: storeCoordinator?.metadata(for: persistentStore)))")
		})
		#endif

		assert(Thread.isMainThread)
		fxdPrint("2. didConfigure: \(didConfigure)")

		//MARK: If iCloud connection is not working, CHECK if cellular transferring is enabled on device"

		fxdPrint("UIManagedDocument.persistentStoreName: \(UIManagedDocument.persistentStoreName)")

		fxdPrint("modelConfiguration: \(String(describing: mainDocument?.modelConfiguration))")
		fxdPrint("managedObjectModel.versionIdentifiers: \(String(describing: mainDocument?.managedObjectModel.versionIdentifiers))")
		fxdPrint("managedObjectModel.entities: \(String(describing: mainDocument?.managedObjectModel.entities))")

		upgradeAllAttributesForNewDataModel {
			(caller, didFinish, responseObj) in

			#if DEBUG
			if ubiquityContainerURL != nil {
				fxdPrint("\(String(describing: FileManager.default.infoDictionary(forFolderURL: ubiquityContainerURL)))")
				fxdPrint("\(String(describing: FileManager.default.infoDictionary(forFolderURL: Self.appCachesDirectory)))")
				fxdPrint("\(String(describing: FileManager.default.infoDictionary(forFolderURL: Self.appDocumentDirectory)))")
			}
			#endif

			finishCallback?(#function, didConfigure, nil)
			//MARK: Careful with order of operations
			
			self.startObservingCoreDataNotifications()
		}
	}

	func startObservingCoreDataNotifications() {
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

	func deleteAllData(finishCallback: FXDcallbackFinish? = nil) {
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

					if shouldBrake?.pointee == true {
						fxdPrint("shouldBrake?.pointee.boolValue: \(String(describing: shouldBrake?.pointee))")
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

	func enumerateAllData(withPrivateContext shouldUsePrivateContext: Bool, shouldShowInformationView shouldShowProgressView: Bool, withEnumerationBlock enumerationBlock: ((NSManagedObjectContext?, NSManagedObject?, UnsafeMutablePointer<Bool>?) -> Void)?, withFinishCallback finishCallback: FXDcallbackFinish? = nil) {	fxd_log()

		fxdPrint("shouldUsePrivateContext: \(shouldUsePrivateContext)")
		fxdPrint("enumeratingOperationQueue?.operationCount: \(String(describing: enumeratingOperationQueue?.operationCount))")

		guard enumeratingOperationQueue?.operationCount == 0 else {
			finishCallback?(#function, false, nil)
			return
		}


		enumeratingTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
			[weak self] in

			if let validTask = self?.enumeratingTask {
				UIApplication.shared.endBackgroundTask(validTask)
				self?.enumeratingTask = .invalid
			}
		})
		fxdPrint("enumeratingTask: \(String(describing: enumeratingTask))")

		if shouldShowProgressView {
			let mainWindow = UIApplication.shared.mainWindow()
			mainWindow?.showInformationView(afterDelay: DURATION_QUARTER)
		}


		var shouldBreak: Bool = false

		let managedContext = shouldUsePrivateContext ? mainDocument?.managedObjectContext.parent : mainDocument?.managedObjectContext

		enumeratingOperationQueue?.addOperation {
			[weak self] in

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
						DispatchQueue.main.async {
							enumerationBlock?(managedContext, mainEntityObj, &shouldBreak)
						}
					}
				}

				fxdPrint("UIApplication.shared.backgroundTimeRemaining: \(UIApplication.shared.backgroundTimeRemaining)")
			}


			OperationQueue.current?.addOperation {
				[weak self] in

				if shouldShowProgressView {
					let mainWindow = UIApplication.shared.mainWindow()
					mainWindow?.hideInformationView(afterDelay: DURATION_QUARTER)
				}

				fxdPrint("!shouldBreak: \(!shouldBreak)")

				finishCallback?(#function, !shouldBreak, nil)

				fxdPrint("UIApplication.shared.backgroundTimeRemaining: \(UIApplication.shared.backgroundTimeRemaining)")
				fxdPrint("self?.enumeratingTask: \(String(describing: self?.enumeratingTask))")

				if let validTask = self?.enumeratingTask {
					UIApplication.shared.endBackgroundTask(validTask)
					self?.enumeratingTask = .invalid
				}
			}
		}
	}

	func saveManagedContext(_ managedContext: NSManagedObjectContext?, withFinishCallback finishCallback: FXDcallbackFinish? = nil) {	fxd_log()
		//TODO: Evaluate if this method is necessary
		fxdPrint("1. managedContext?.hasChanges: \(String(describing: managedContext?.hasChanges)) concurrencyType: \(String(describing: managedContext?.concurrencyType))")

		var mainManagedContext = managedContext
		if mainManagedContext == nil {

			mainManagedContext = mainDocument?.managedObjectContext
			fxdPrint("2. managedContext?.hasChanges: \(String(describing: mainManagedContext?.hasChanges)) concurrencyType: \(String(describing: mainManagedContext?.concurrencyType))")

			if mainManagedContext?.hasChanges == false
				&& mainManagedContext?.concurrencyType != mainDocument?.managedObjectContext.parent?.concurrencyType {

				mainManagedContext = mainDocument?.managedObjectContext.parent
				fxdPrint("3. managedContext?.hasChanges: \(String(describing: mainManagedContext?.hasChanges)) concurrencyType: \(String(describing: mainManagedContext?.concurrencyType))")
			}
		}


		fxdPrint("4. mainManagedContext: \(String(describing: mainManagedContext)) managedContext?.hasChanges: \(String(describing: mainManagedContext?.hasChanges)) concurrencyType: \(String(describing: mainManagedContext?.concurrencyType))")

		guard (mainManagedContext != nil && mainManagedContext!.hasChanges) else {
			finishCallback?(#function, false, nil)
			return
		}


		let ManagedContextSavingBlock = {
			var didSave: Bool = true
			do {
				try mainManagedContext?.save()
			}
			catch let exception {
				fxdPrint("exception: \(exception)")
				didSave = false
			}

			fxd_log()
			fxdPrint("5. didSave \(didSave) mainManagedContext: \(String(describing: mainManagedContext)) managedContext?.hasChanges: \(String(describing: mainManagedContext?.hasChanges)) concurrencyType: \(String(describing: mainManagedContext?.concurrencyType))")
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

	public func saveMainDocument(finishCallback: FXDcallbackFinish? = nil) {	fxd_log()
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

		fxdPrint("dataSavingTask: \(String(describing: dataSavingTask))")

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
