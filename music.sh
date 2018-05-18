#!/usr/bin/env osascript

use scripting additions
use framework "Foundation"
property NSString : a reference to current application's NSString

set titleString to " - Google Play Music"
set homePage to "Home" & titleString
set searchPage to "Search Results" & titleString

on remove:remove_string fromString:source_string
  set s_String to NSString's stringWithString:source_string
  set r_String to NSString's stringWithString:remove_string
  return (s_String's stringByReplacingOccurrencesOfString:r_String withString:"") as string
end remove:fromString:

tell application "Google Chrome"
  set t to ""
  if it is running then
    set window_list to every window # get the windows

    repeat with the_window in window_list # for every window
      set tab_list to every tab in the_window # get the tabs

      repeat with the_tab in tab_list # for every tab
        set the_title to the title of the_tab
        if the_title contains titleString and the_title is not equal to homePage and the_title is not equal to searchPage then

          set t to "♫ " & (my remove:titleString fromString:the_title)
          exit repeat
        end if
      end repeat
    end repeat
  end if

  if length of t > 35 then
    text 1 thru 35 of t & "..."
  else
    t
  end if
end tell

