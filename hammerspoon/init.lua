-- ln -s /Users/peter/Documents/Local/git/personal/.dotfiles/hammerspoon/init.lua /Users/peter/.hammerspoon/init.lua

local function diaOnly(number)
    return function()
        local app = hs.application.frontmostApplication()

        if app and app:bundleID() == "company.thebrowser.dia" then
            hs.eventtap.keyStroke({"ctrl"}, number)
        end
    end
end

hs.hotkey.bind({}, "f1", diaOnly("1"))
hs.hotkey.bind({}, "f2", diaOnly("2"))
hs.hotkey.bind({}, "f3", diaOnly("3"))
hs.hotkey.bind({}, "f4", diaOnly("4"))
