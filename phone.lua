---[[
--- This file is part of the High Scripts Facade Phone module.
--- Do not load this file directly, this is a declaration file for the High Scripts Phone module.
---]]

---@meta HighPhone

---@class MediaAttachment
---@field type 'image' | 'video'
---@field url string URL of the media attachment

---@class ContactAttachment
---@field number string Phone number of the contact
---@field name string Name of the contact
---@field photo string Optional photo URL of the contact

---@class NoteAttachment
---@field title string Title of the note
---@field content string Content of the note

---@alias AttachmentType 'media' | 'contact' | 'note'
---@alias AttachmentContent MediaAttachment | ContactAttachment | NoteAttachment

---@class MessageData
---@field sender string Sender phone number
---@field recipient string Recipient's phone number
---@field content string Content of the message.
---@field attachments AttachmentContent[]? Optional attachments for the message.

---@class MailData
---@field sender string Sender of the mail, can be a player or a system address.
---@field recipients string[] Recipients of the mail.
---@field subject string Subject of the mail
---@field content string Content of the mail, can be plain text or HTML.
---@field attachments AttachmentContent[]? Optional attachments for the mail.

---@class PhoneNotificationIcon
---@field name string? Name of the icon, e.g. 'fa-solid fa-envelope'
---@field imageUrl string? URL of the icon image
---@field color string? Color of the icon, e.g. '#fff'
---@field sizeMultiplier number? Size multiplier for the icon

---@class PhoneNotificationData
---@field title string Title of the notification
---@field content string Content of the notification
---@field application table? Application data, if the notification is from an app
---@field icon PhoneNotificationIcon Icon data for the notification
---@field duration number? Duration of the notification in milliseconds (default is 5000)

---@class PhoneSignalData
---@field provider string Name of the provider (e.g. 'High Mobile')
---@field strength number Signal strength

---@class HighScriptsSharedPhone
HighScripts.Shared.Phone = {};

--- Adds an application on the phone.
---
--- **Recommended to use on the server-side for optimization purposes.**
---@param name string Name of the application, it is used to identify the app in the phone.
---@param data AppConfig Application config, following the `applications.lua` config format.
---@param locales table<string, table<string, string>> Table of locales for the app, it is inserted into `ui.apps`.
--- ```lua
--- HighScripts.Shared.Phone.addApplication('bankingv2', {
---     icon = {
---         imageUrl = "https://aka.ms/confidential",
---         background = "#1B1B1B"
---     },
---     preAdded = false,
---     removable = true,
---     size = 9.11,
---     inAppStore = true,
---     developer = "High Scripts",
---     preview = {},
---     banner = {
---         imageUrl = "https://aka.ms/confidential",
---         background = "#1C222C",
---     },
---     defaultSettings = {
---         notifications = { allow = true, alerts = 3 }
---     }
--- }, {
---     ["en"] = {
---         label = "Banking",
---         description = "A very great banking application",
---         -- More locales if you wish to use the phone's built-in locale system instead of your own.
---     }
--- });
--- ```
function HighScripts.Shared.Phone.addApplication(name, data, locales) end

--- Merges custom locales into existing ones.
---
--- Useful for custom application labels and when using phone's built-in i18n module.
---@param locales table<string, table<string, string>> Table of locales for the app
--- ```lua
--- HighScripts.Shared.Phone.addLocales({
---     ["en"] = {
---         ui = {
---             apps = {
---                 myapp = {
---                     label = "My App",
---                     description = "This is a great app"
---                 }
---             }
---         }
---     }
--- });
--- ```
function HighScripts.Shared.Phone.addLocales(locales) end

--- Formats a phone number string into what you have configured.
---@param number string	Phone number that you want to format
--- ```lua
--- local formattedNumber <const> = HighScripts.Shared.Phone.formatPhoneNumber('1234567890');
--- ```
function HighScripts.Shared.Phone.formatNumber(number) end

--- Generates a phone number based on your config and returns it unformatted
---@return string
--- ```lua
--- local phoneNumber = HighScripts.Shared.Phone.generateNumber();
--- ```
function HighScripts.Shared.Phone.generateNumber() end

---@class HighScriptsServerPhone
HighScripts.Server.Phone = {};

--- Send mail from either the system or a player.
---
--- To use HTML, action buttons, etc. you have to send a mail from the system by using one of
--- the reservedUsers addresses you've configured in the mail app configuration.
---@param data MailData Mail data to send.
---@param source number? Player's ID, only required if you're sending a mail on behalf of a player.
--- ```lua
--- HighScripts.Server.Phone.sendMail({
---     sender = "12345",
---     recipients = { "player1@high.mail", "player2@high.mail" },
---     subject = "Welcome to High Scripts",
---     content = "This is a test mail.",
---     attachments = {
---         {
---             type = "media",
---             url = "https://example.com/image.png"
---         }
---     }
--- });
--- ```
function HighScripts.Server.Phone.sendMail(data, source) end

--- Get a player's mail account data
---@param source number Player's ID
---@return table MailAccountData -- Not documented, but likely returns the player's mail account data as a table.
--- ```lua
--- local account <const> = HighScripts.Server.Phone.getPlayerMailAccount(source);
--- print(account?.address);
--- ```
function HighScripts.Server.Phone.getPlayerMailAccount(source) end

--- Get an offline player's mail account data by player's identifier
---@param identifier string Player's identifier
---@return table MailAccountData -- Not documented, but likely returns the player's mail account data as a table.
--- ```lua
--- local account <const> = HighScripts.Server.Phone.getOfflinePlayerMailAccount('char1:2gtp1d6c57d7989ba1209e2c6gc9002f4872b856');
--- print(account?.address);
--- ```
function HighScripts.Server.Phone.getOfflinePlayerMailAccount(identifier) end

--- Send a message to a number from a number
---@param data MessageData Message data to send.
---@param source number? Player's ID, only required if you're sending a message on behalf of a player.
--- ```lua
--- HighScripts.Server.Phone.sendMessage({
---     sender = '12345',
---     recipients = { '123456' },
---     content = 'Hello World',
---     attachments = {
---         {
---             type = 'media',
---             content = {
---                 type = 'image',
---                 url = 'https://i.imgur.com/6AnLddq.png'
---             }
---         }
---     }
--- });
--- ```
function HighScripts.Server.Phone.sendMessage(data, source) end

--- Creates a hook for a specified action. You can also return false in some hooks to cancel the action!
---@overload fun(eventName: 'startCall', callback: fun(src: number, call: table): boolean)
---@overload fun(eventName: 'endCall', callback: fun(src: number, call: table): boolean)
---@overload fun(eventName: 'beforeCreatePhone', callback: fun(src: number, phoneData: table): boolean)
---@overload fun(eventName: 'afterCreatePhone', callback: fun(src: number, phoneData: table): boolean)
---@overload fun(eventName: 'sendMessage', callback: fun(src: number, messageData: MessageData): boolean)
function HighScripts.Server.Phone.createHook(eventName, callback) end

---@class HighScriptsClientPhone
HighScripts.Client.Phone = {};

--- Opens the phone if the player has one and it's possible to do so.
---@param forced boolean? Bypass any checks, including has item check
--- ```lua
--- -- Opens the phone forcefully even if the player is in water, or dead.
--- HighScripts.Client.Phone.openPhone(true);
--- ```
function HighScripts.Client.Phone.openPhone(forced) end

--- Closes the phone.
--- ```lua
--- HighScripts.Client.Phone.closePhone();
--- ```
function HighScripts.Client.Phone.closePhone() end

--- Sends an NUI message to the phone. Mostly useful when trying to manipulate the phone's behavior.
---@param data table Data to send to the phone's NUI.
--- ```lua
--- HighScripts.Client.Phone.sendNui({
---     action = 'myevent',
---     payload = {
---        myData = 'Hello World'
---     }
--- });
--- ```
function HighScripts.Client.Phone.sendNui(data) end

--- Sends an NUI message to a custom app.
---@param appName string Name of the app to send the message to.
---@param data table Data to send to the app's NUI.
--- ```lua
--- HighScripts.Client.Phone.sendAppNui('myapp', {
---     action = 'myevent',
---     payload = {
---         myData = 'Hello World'
---     }
--- });
--- ```
function HighScripts.Client.Phone.sendAppNui(appName, data) end

--- Sends a notification to the phone. Can also be from an application.
---@param data PhoneNotificationData Notification data
--- ```lua
--- HighScripts.Client.Phone.sendNotification({
---     title = 'Hello World',
---     content = 'Hello World',
---     application = { name = 'twizzler' },
---     icon = {
---         name = 'fa-solid fa-envelope',
---         imageUrl = '',
---         color = '#fff',
---         sizeMultiplier = 1.0
---     },
---     duration = 5000
--- })
--- ```
function HighScripts.Client.Phone.sendNotification(data) end

--- Gets the settings of a player's current phone.
---@param settingName string? Setting you want to get (optional)
---@return any
--- ```lua
--- local airplaneMode <const> = HighScripts.Client.Phone.getSettings('airplaneMode');
--- local settings <const> = HighScripts.Client.Phone.getSettings();
--- ```
function HighScripts.Client.Phone.getSettings(settingName) end

--- Toggles the camera view for use in apps, etc.
---@param state boolean Whether to enable or disable the camera view
---@param facing 'front' | 'rear'? Facing of the camera ('rear' by default)
---@param portrait boolean? Enable or disable portrait mode (blurry background, false by default)
--- ```lua
--- HighScripts.Client.Phone.toggleCamera(true, 'front', true);
--- ```
function HighScripts.Client.Phone.toggleCamera(state, facing, portrait) end

--- Change camera facing to either rear or front while camera view is enabled.
---@param facing 'front' | 'rear' Facing of the camera
--- ```lua
--- HighScripts.Client.Phone.setCameraFacing('front');
--- ```
function HighScripts.Client.Phone.setCameraFacing(facing) end

--- Gets the provider name and the signal strength of the current area player is in.
---@return PhoneSignalData
--- ```lua
--- local signalData <const> = HighScripts.Client.Phone.getSignal();
--- local provider <const> = signalData.provider;
--- local strength <const> = signalData.strength;
--- ```
function HighScripts.Client.Phone.getSignal() end

--- Sets whether the phone can be opened by the player.
---@param state boolean Setting this to false will prevent the player from opening the phone
---@param keepOpen boolean? If the phone is currently open, optionally don't close it
--- ```lua
--- HighScripts.Client.Phone.toggleUsability(true);
--- ```
function HighScripts.Client.Phone.toggleUsability(state, keepOpen) end

--- Returns whether the phone is currently disabled (including toggleUsability).
---@return boolean
--- ```lua
--- local isDisabled <const> = HighScripts.Client.Phone.isDisabled();
--- ```
function HighScripts.Client.Phone.isDisabled() end

--- Sets a name for a blip in maps application.
---@param blip number Blip handle
---@param name string Blip name
--- ```lua
--- local blip <const> = AddBlipForCoord(0.0, 0.0, 0.0);
--- SetBlipSprite(blip, 1);
---
--- local blipName = 'Test Blip';
--- BeginTextCommandSetBlipName("STRING");
--- AddTextComponentString(blipName);
--- EndTextCommandSetBlipName(blip);
---
--- HighScripts.Client.Phone.setBlipName(blip, blipName);
--- ```
function HighScripts.Client.Phone.setBlipName(blip, name) end

--- Returns whether valet is currently usable or not.
---@return boolean
--- ```lua
--- local canUseValet <const> = HighScripts.Client.Phone.canUseValet();
--- ```
function HighScripts.Client.Phone.canUseValet() end

--- Toggles the usability of Valet services.
---@param state boolean Setting this to true will prevent the player from using valet services
--- ```lua
--- HighScripts.Client.Phone.toggleValet(false);
--- ```
function HighScripts.Client.Phone.toggleValet(state) end
