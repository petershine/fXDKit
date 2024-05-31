#!/bin/bash

#https://developer.apple.com/documentation/xcode/creating-a-multi-platform-binary-framework-bundle
projectName="fXDObjC"
schemeName=$projectName
archiveName=$projectName
archiveNameForSimulator="$projectName-Simulator"
archiveNameForMacOS="$projectName-MacOS"

frameworkName=$projectName
folderName="xcframeworks"


xcodebuild archive -project "$projectName".xcodeproj \
    -scheme $schemeName \
    -destination "generic/platform=iOS" \
    -archivePath "$folderName/$archiveName"

xcodebuild archive -project "$projectName".xcodeproj \
    -scheme $schemeName \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "$folderName/$archiveNameForSimulator"

#xcodebuild archive -project "$projectName".xcodeproj \
    -scheme $schemeName \
    -destination "generic/platform=macOS,variant=Mac Catalyst" \
    -archivePath "$folderName/$archiveNameForMacOS"


xcodebuild -create-xcframework \
    -archive $folderName/$archiveName.xcarchive -framework $frameworkName.framework \
    -archive $folderName/$archiveNameForSimulator.xcarchive -framework $frameworkName.framework \
    -output $folderName/$frameworkName.xcframework


cp -pRP $folderName/$frameworkName.xcframework ../

rm -rf $folderName
