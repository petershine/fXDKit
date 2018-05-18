

import MediaPlayer


class FXDmoduleMedia: NSObject {

    lazy var musicPlayer: MPMusicPlayerController? = {
        return MPMusicPlayerController.systemMusicPlayer
    }()

    var lastMediaItem: MPMediaItem?


    deinit {    fxdFuncPrint()
        musicPlayer?.endGeneratingPlaybackNotifications()
        MPMediaLibrary.default().endGeneratingLibraryChangeNotifications()
    }


    func startObservingMediaNotifications() {    fxdFuncPrint()
		//MARK: The app's Info.plist must contain an NSAppleMusicUsageDescription key with a string value explaining to the user how the app uses this data.

        NotificationCenter.default.addObserver(self,
                         selector: #selector(self.observedMPMusicPlayerControllerPlaybackStateDidChange(_:)),
                         name: .MPMusicPlayerControllerPlaybackStateDidChange,
                         object:self.musicPlayer)

        NotificationCenter.default.addObserver(self,
                         selector: #selector(self.observedMPMusicPlayerControllerNowPlayingItemDidChange(_:)),
                         name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                         object:self.musicPlayer)

        NotificationCenter.default.addObserver(self,
                         selector: #selector(self.observedMPMediaLibraryDidChange(_:)),
                         name: .MPMediaLibraryDidChange,
                         object:MPMediaLibrary.default())


        if self.musicPlayer != nil {
            self.musicPlayer!.beginGeneratingPlaybackNotifications()
        }

        MPMediaLibrary.default().beginGeneratingLibraryChangeNotifications()
    }
}

extension FXDmoduleMedia {

	@objc func observedMPMusicPlayerControllerPlaybackStateDidChange(_ notification: Notification) {
		fxdPrint(self.musicPlayer?.playbackState.rawValue as Any)
	}

	@objc func observedMPMusicPlayerControllerNowPlayingItemDidChange(_ notification: Notification) {
		fxdPrint(self.musicPlayer?.nowPlayingItem?.title as Any)
		fxdPrint(self.lastMediaItem?.title as Any)
	}

	@objc func observedMPMediaLibraryDidChange(_ notification: Notification) {
		fxdPrint(MPMediaLibrary.default().lastModifiedDate)
	}
}

