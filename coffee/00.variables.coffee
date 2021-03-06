pkg = require './package.json'
plg = require './plugin.json'

SocketModules = module.parent.require './socket.io/modules'
SocketAdmin = module.parent.require './socket.io/admin'
io = module.parent.require './socket.io'
Settings = module.parent.require './settings'
Route = require './services/Route'

plugin = Object.freeze
  name: plg.id.substring 14
  version: pkg.version
  adminPage:
    name: plg.name
    icon: 'fa-keyboard-o'
    route: "/plugins/#{plg.id.substring 14}"

defConfig =
  select_chars: 'werasdfguiohjklnm'
  timeSpace: 200
  selectionColor: '#0059B2'
  actions:
    dialog:
      confirm: ['#89', '#79', '#90'] # y, o, z
      close: ['#78', '#67', '#27'] # n, c, Esc
    composer:
      send: ['A+#83'] # A-s
      discard: ['A+#68', 'S+#27'] # A-d, S-Esc
      preview: ['A+#80'] # A-p
      previewSend: ['C+#13'] # C-Enter
      writeSend: ['C+S+#13'] # C-S-Enter
      help: ['A+#72'] # A-h
      write: ['A+#87'] # A-w
      bold: ['A+#66'] # A-b
      italic: ['A+#73'] # A-i
      list: ['A+#76'] # A-l
      link: ['A+#85'] # A-u
      closed:
        title: ['A+S+#84'] # A-S-t
        input: ['#73', 'C+#73', 'A+S+#73'] # i, C-i, A-S-i
    taskbar:
      closeAll: ['A+#67', 'A+#88'] # A-c, A-x
      clickFirst: ['A+#86'] # A-v
      clickLast: ['A+S+#86'] # A-S-v
    breadcrumb:
      up: ['A+#38'] # A-Up
    topic:
      reply: ['A+#89', 'A+S+#78', 'A+#13'] # A-y, A-S-n, A-Enter
      threadTools: ['A+#84'] # A-t
    category:
      newTopic: ['A+#89', 'A+S+#78', 'A+#13'] # A-y, A-S-n, A-Enter
    selection:
      follow: ['#13', '#32'] # Enter, Space
      highlight: ['S+#72'] # S-h
      area:
        next: ['A+#74'] # A-j
        prev: ['A+#75'] # A-k
      item:
        next: ['#74', 'A+S+#74'] # j, A-S-j
        prev: ['#75', 'A+S+#75'] # k, A-S-k
    navPills:
      next: ['#76'] # l
      prev: ['#72'] # h
    header:
      home: ['A+#72', 'A+S+#72'] # A-h, A-S-h
      unread: ['A+#85', 'A+S+#85'] # A-u, A-S-u
      recent: ['A+#82', 'A+S+#82'] # A-r, A-S-r
      tags: ['A+#84', 'A+S+#84'] # A-t, A-S-t
      popular: ['A+#80', 'A+S+#80'] # A-p, A-S-p
      users: ['A+#83', 'A+S+#83'] # A-s, A-S-s
      groups: ['A+#71', 'A+S+#71'] # A-g, A-S-g
      notifications: ['A+#78', 'A+S+#78'] # A-n, A-S-n
      chats: ['A+#67', 'A+S+#67'] # A-c, A-S-c
      profile: ['A+#79', 'A+S+#79'] # A-o, A-S-o
      admin: ['A+#65', 'A+S+#65'] # A-a, A-S-a
      search: ['#191'] # /
    body:
      focus: ['S+#221', '#27'] # S-], Esc
      scroll:
        pageDown: ['#68'] # d
        pageUp: ['#85'] # u
        top: ['#84'] # t
        bottom: ['#66'] # b
      reload:
        soft: ['#82'] # r
        hard: ['C+#82', 'S+#82'] # C-r, S-r
      form:
        next: ['A+#191'] # A+/
        prev: ['A+S+#191'] # A+S+/

cfg = new Settings plugin.name, plugin.version, defConfig, null, false, false

descriptions =
  body:
    _title: "Basic actions"
    focus: "Blur focused element"
    scroll_pageDown: "Scroll one page down"
    scroll_pageUp: "Scroll one page up"
    scroll_top: "Scroll to top"
    scroll_bottom: "Scroll to bottom"
    reload_soft: "Reload current page"
    reload_hard: "Reload current page without hash"
    form_next: "Select next form-element or search if no form"
    form_prev: "Select previous form-element or search if no form"
  header:
    _title: "Navigation"
    home: "Go to home-page"
    unread: "Go to unread-page"
    recent: "Go to recent-page"
    tags: "Go to tags-page"
    popular: "Go to popular-page"
    users: "Go to users-page"
    groups: "Go to groups-page"
    notifications: "Go to notifications-page"
    profile: "Go to profile-page"
    chats: "Open chat-popup"
    search: "Enter the search-field"
  navPills:
    _title: "Sub-navigation (nav-pills)"
    next: "Select next pill"
    prev: "Select previous pill"
  breadcrumb:
    _title: "Navigate upwards (breadcrumb)"
    up: "Navigate upwards (topic -> category -> home)"
  selection:
    _title: "Navigate downwards (selection)"
    follow: "Go into the current selected item"
    area_next: "Select next item-cluster"
    area_prev: "Select previous item-cluster"
    item_next: "Select next item within cluster"
    item_prev: "Select previous item within cluster"
    highlight: "Highlight the selected item"
  category:
    _title: "Actions within a Category"
    newTopic: "Create a new Topic"
  topic:
    _title: "Actions within a Topic"
    reply: "Create a new reply"
    threadTools: "Open Thread Tools"
  dialog:
    _title: "Active dialog (bootbox)"
    confirm: "Confirm active dialog"
    close: "Close active dialog"
  taskbar:
    _title: "Using the taskbar"
    closeAll: "Close all tasks"
    clickFirst: "Toggle first task"
    clickLast: "Toggle last task"
  composer:
    _title: "Writing a post"
    send: "Send post"
    discard: "Discard post"
    closed_input: "Focus textarea (opens closed composer)"
    closed_title: "Focus title-field (opens closed composer)"
    preview: "Show preview-tab (deprecated)"
    previewSend: "Show preview-tab or send post if already shown"
    writeSend: "Show write-tab or send post if already shown"
    help: "Show help"
    write: "Show write-tab (deprecated)"
    bold: "Make selected text bold"
    italic: "Make selected text italic"
    list: "Make selected text a list-item"
    link: "Make selected text a link-name"
  _admin:
    header:
      _title: "Navigation"
      admin: "Open the admin-page"