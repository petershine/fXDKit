#!/bin/bash

#https://developer.apple.com/documentation/xcode/creating-a-multi-platform-binary-framework-bundle
projectName="fXDObjC"
schemeName=$projectName
archiveName=$projectName
frameworkName=$projectName
folderName="xcframeworks"


xcodebuild archive -project "$projectName".xcodeproj \
    -scheme $schemeName \
    -destination "generic/platform=iOS" \
    -archivePath "$folderName/$archiveName"

xcodebuild archive -project "$projectName".xcodeproj \
    -scheme $schemeName \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "$folderName/$archiveName-Simulator"


xcodebuild -create-xcframework \
    -archive $folderName/$archiveName.xcarchive \
    -framework $frameworkName.framework \
    -archive $folderName/$archiveName-Simulator.xcarchive \
    -framework $frameworkName.framework \
    -output $folderName/$frameworkName.xcframework


cp -pRP $folderName/$frameworkName.xcframework ../

rm -rf $folderName
