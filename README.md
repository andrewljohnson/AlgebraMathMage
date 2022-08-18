# AlgebraMathMage 

This is an app for iPad to teach kids math, egged on by lots of little videos.

## Todo 
 *

### Todo Later/Maybe
* Show chapter finish screen (when we have chapters))
* Randomize answer order
* Bugs
  * make reset data button animate
  * make transition back from section complete view into a scale transition 
  * replace youtube library with something else, it has warnings in the code
  * limit usage to iPads in build


## Setup

### Summary

Install cocoapods, use that to install the pods, then run the app in XCode. Use `AlgebraMathMage.xcworkspace` to open the project in XCode since we're using cocoapods.

### Install cocoapods
```
brew install cocoapods
pod setup --verbose
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
