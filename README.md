# AlgebraMathMage 

This is an app for iPad to teach kids math, egged on by lots of little videos.

## Todo 
 *

### Todo Later/Maybe
* Show chapter finish screen (when we have chapters))
* Randomize answer order
* Don't use both Swift packages and cocoapods?
* Bugs
  * make reset data button animate
  * make transition back from section complete view into a scale transition 
  * limit usage to iPads in build


## Setup

### Summary

Install cocoapods, use that to install the pods, then run the app in XCode. Use `AlgebraMathMage.xcworkspace` to open the project in XCode since we're using cocoapods.

### Install cocoapods
```
brew install cocoapods
```

### Install pods
```
pod install
```

## Notes

Since I am on Apple Silicon, I had to do this before using homebrew (https://stackoverflow.com/questions/64963370/error-cannot-install-in-homebrew-on-arm-processor-in-intel-default-prefix-usr):
```
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Note From YouTubePlayerKit README
When submitting an app to the App Store which includes the YouTubePlayerKit, please ensure to add a link to the YouTube API Terms of Services in the review notes.

https://developers.google.com/youtube/terms/api-services-terms-of-service

