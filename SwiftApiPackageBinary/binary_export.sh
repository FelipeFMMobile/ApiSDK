# DERIVED_DATA_PATH=`xcodebuild -project "UpComingMovies.xcodeproj" -scheme "UpcomingMoviesApi" -showBuildSettings | grep OBJROOT | #cut -d "=" -f 2 - | sed 's/^ *//'`
# DERIVED_DATA_PATH=`dirname "$DERIVED_DATA_PATH"`
# echo "Found derived data path: $DERIVED_DATA_PATH"

rm -r "$@.xcframework"

xcodebuild archive -quiet -scheme "$@" -sdk iphoneos -destination 'generic/platform=iOS' -archivePath './Build/iphone' BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO -IDEBuildingContinueBuildingAfterErrors=YES

xcodebuild archive -quiet -scheme "$@" -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' -archivePath './Build/iphonesimulator' BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO -IDEBuildingContinueBuildingAfterErrors=YES

xcodebuild -create-xcframework -output "$@".xcframework -framework "./Build/iphone.xcarchive/Products/Library/Frameworks/$@.framework"  -framework "./Build/iphonesimulator.xcarchive/Products/Library/Frameworks/$@.framework"