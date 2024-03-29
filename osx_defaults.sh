#!/bin/bash
#
# Based on github.com/mathiasbynens/dotfiles/.osx
#

# Ask for the administrator password upfront
echo "Need sudo password to set some OS X defaults"
sudo -v || exit

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Show battery percentage in menu bar
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Expanded Save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expanded Print dialog by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Dark Graphite Theme
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: enable 3-finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad ThreeFingerDrag -bool true

# Keyboard: Disable the terrible "Replace double-space with period" 'feature'
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Keyboard: Disable the equally terrible "Press and Hold" 'feature'
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use Fn to expand control strip instead of showing function keys
defaults delete com.apple.touchbar.agent PresentationModeGlobal
defaults write com.apple.touchbar.agent PresentationModeFnModes -dict appWithControlStrip -string fullControlStrip

# Default control strip items
defaults write com.apple.controlstrip MiniCustomized -array \
  -string com.apple.system.brightness \
  -string com.apple.system.volume \
  -string com.apple.system.mute \
  -string com.apple.system.screen-lock

###############################################################################
# Screen                                                                      #
###############################################################################

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

###############################################################################
# Finder/Dock                                                                 #
###############################################################################

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show item info below icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Change default window location
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Automatically hide and show the Dock and be on the right hand side.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock orientation -string 'right'

# Don't show recent apps in the dock.
defaults write com.apple.dock show-recents -bool false

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Create preferred dock entries
/usr/libexec/PlistBuddy -c "Delete persistent-apps" ~/Library/Preferences/com.apple.dock.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Delete persistent-others" ~/Library/Preferences/com.apple.dock.plist 2>/dev/null
/usr/libexec/PlistBuddy -c "Merge /Users/${USER}/.dotfiles/default-dock.plist" ~/Library/Preferences/com.apple.dock.plist 2>/dev/null

###############################################################################
# Safari                                                                      #
###############################################################################

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

###############################################################################
# Misc
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Enable Xcode build timing
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool true

# Set my account picture
ln -s ~/.dotfiles/Avatar.jpg ~/Pictures
sudo cp ~/.dotfiles/Avatar.jpg "/Library/User Pictures/rahatar.jpg"
sudo dscl . delete /Users/${USER} jpegphoto
sudo dscl . delete /Users/${USER} Picture
sudo dscl . create /Users/${USER} Picture "/Library/User Pictures/rahatar.jpg"

###############################################################################
# Kill affected applications                                                  #
###############################################################################
for app in "Dock" "Finder" "Safari" "SystemUIServer" "cfprefsd"; do
  echo "Killing $app, do not be alarmed"
  sudo killall "$app" > /dev/null 2>&1
done
