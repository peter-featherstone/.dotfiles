-- ln -s /Users/peter/Documents/Local/git/personal/.dotfiles/hammerspoon/init.lua /Users/peter/.hammerspoon/init.lua

-- F-keys switch tabs in Dia (ctrl+N) and tmux windows in Ghostty (alt+N, see .tmux.conf)
local tabModifiers = {
    ["company.thebrowser.dia"] = {"ctrl"},
    ["com.mitchellh.ghostty"] = {"alt"},
}

local function switchTab(number)
    return function()
        local app = hs.application.frontmostApplication()
        local modifiers = app and tabModifiers[app:bundleID()]

        if modifiers then
            hs.eventtap.keyStroke(modifiers, number)
        end
    end
end

hs.hotkey.bind({}, "f1", switchTab("1"))
hs.hotkey.bind({}, "f2", switchTab("2"))
hs.hotkey.bind({}, "f3", switchTab("3"))
hs.hotkey.bind({}, "f4", switchTab("4"))
hs.hotkey.bind({}, "f5", switchTab("5"))
