i18n.addResourceBundle("en", "translation",
  name: 'English'
  forms:
    login:
      email: 'Email'
      password: 'Password'
      passwordAgain: 'Password again'
      forgotPassword: 'Forgot password?'
      signup: 'Let\'s go!'
      login: 'Login'
      isLoggingIn: 'Logging in...'
      messages:
        email:
          required: 'Please specify your email'
          email: 'Doesn\'t seem to be valid email'
        password:
          required: 'Please specify your password'
          minlength: 'Password should have at least 4&nbsp;characters'
        passwordAgain:
          required: 'Please repeat your password'
          equalTo: 'The passwords should match'
      passwordForgot:
        link: 'Forgot password'
        alert:
          name: 'Reset password'
          emailPlaceholder: 'Your email'
          reset: 'Reset'
          errors:
            userNotFound: 'Account with that email does not exists.'
      passwordReset:
        alert:
          name: 'Reset password'
          passwordPlaceholder: 'New password'
          reset: 'Reset'
          errors:
            tokenNotFound: 'Request is expired, try again.'
    invite:
      setPassword: 'Set your password to begin using the application:'
    profile:
      header: 'Profile settings'
      email: 'Email address'
      emailPlaceholder: 'Email address'
      name: 'Name and surname'
      namePlaceholder: 'Name and surname'
      password: 'Password'
      passwordPlaceholder: 'Password'
      passwordChange:
        link: 'Change password'
        alert:
          name: 'Change password'
          oldPasswordPlaceholder: 'Old password'
          newPasswordPlaceholder: 'New password'
          change: 'Change'
          errors:
            incorrectPassword: 'Please specify correct old password'
      phone: 'Phone for SMS reminders'
      phonePlaceholder: 'With country code; e.g. +1 260 123 45 67'
      phoneVerifyToReceiveSmsReminders: 'Verify your number to receive SMS reminders.'
      phoneIsVerified: 'This phone number is verified.'
      phoneSendVerificationCode: 'Send verification code'
      youCanResendVerificationCodeInSomeMinutes: 'You may request another verification code in {{minutes}} minutes.'
      phoneVerificationCodePlaceholder: 'Verification code'
      phoneVerification: 'Verification of {{phone}}'
      phoneVerify: 'Verify'
      language: 'Language'
      image: 'Avatar'
      group: 'Group'
      mode: 'Mode'
      wrongVerificationCode: 'Verification code doesn\'t match.'
      messages:
        email:
          required: 'Email is required.'
          email: 'Please enter a valid email address.'
          uniqueEmail: 'Email already exists.'
        name:
          required: 'Name is required.'
        password:
          required: 'Password is required.'
        group:
          required: 'Group is required.'
        inserted: 'User added successfully.'
        saved: 'User updated successfully.'
  serverErrors:
    'User not found': 'User not found'
    'Email already exists': 'Email already exists'
    'Incorrect password': 'Incorrect password'
    'User has no password set': 'Please, follow the link from the invitation email and set a new password'
    'Token expired': 'Invitation link has expired'
  interface:
    create: 'Create'
    insert: 'Add'
    update: 'Edit'
    remove: 'Delete'
    save: 'Save'
    cancel: 'Cancel'
    changesAreSavedAutomatically: 'All changes are saved automatically.'
  votes:
    already: 'Somebody already voted'
    already_plural: '{{count}} people already voted'
    more: '1 vote to go'
    more_plural: '{{count}} votes to go'
    keep: 'join us!'
  objects:
    filter: 'filter'
    filter_plural: 'filters'
    '500px':
      photo: 'photo'
      photo_plural: 'photos'
    'bitly':
      link: 'link'
      link_plural: 'links'
      url: 'URL'
      url_plural: 'URLs'
    'Box':
      file: 'file'
      file_plural: 'files'
      folder: 'folder'
      folder_plural: 'folders'
      tag: 'tag'
      tag_plural: 'tags'
      comment: 'comment'
      comment_plural: 'comments'
      user: 'user'
      user_plural: 'users'
    'Buffer':
      post: 'post'
      post_plural: 'posts'
    'Evernote':
      note: 'note'
      note_plural: 'notes'
    'Trello':
      board: 'board'
      board_plural: 'boards'
      label: 'label'
      label_plural: 'labels'
      member: 'member'
      member_plural: 'members'
      list: 'list'
      list_plural: 'lists'
      card: 'card'
      card_plural: 'cards'
  models:
    Card:
      name: "card"
      name_plural: "cards"
    Checklist:
      name: "checklist"
      name_plural: "checklists"
    CheckItem:
      name: "checklist item"
      name_plural: "checklist items"
  actions:
    '500px':
      'set-license':
        icon: 'gavel'
        name: 'Set license'
        shorthand: 'set license'
        appendix: 'for {{selectionLength}} $t(objects.500px.photo, {"count": {{selectionLength}}})'
      'delete':
        icon: 'trash-o'
        name: 'Delete'
        shorthand: 'delete'
        appendix: '{{selectionLength}} $t(objects.500px.photo, {"count": {{selectionLength}}})'
    'bitly':
      'export':
        icon: 'cloud-download'
        name: 'Export to Excel'
        shorthand: 'export'
        appendix: 'all $t(objects.bitly.link, {"count": {{selectionLength}}})'
      'shorten':
        icon: 'bolt'
        name: 'Shorten'
        shorthand: 'shorten'
        appendix: '{{selectionLength}} $t(objects.bitly.url, {"count": {{selectionLength}}})'
      'update-destination-url':
        icon: 'link'
        name: 'Update destination URL'
        shorthand: 'update destination URL'
        appendix: 'for {{selectionLength}} $t(objects.bitly.link, {"count": {{selectionLength}}})'
    'Box':
      'print':
        icon: 'print'
        name: 'Print'
        shorthand: 'print'
        appendix: '{{selectionLength}} $t(objects.Box.file, {"count": {{selectionLength}}})'
      'move':
        icon: 'arrow-right'
        name: 'Move'
        shorthand: 'move'
        appendix: '{{selectionLength}} $t(objects.Box.file, {"count": {{selectionLength}}})'
      'rename':
        icon: 'pencil'
        name: 'Rename'
        shorthand: 'rename'
        appendix: '{{selectionLength}} $t(objects.Box.file, {"count": {{selectionLength}}})/$t(objects.Box.folder, {"count": {{selectionLength}}})'
      'delete':
        icon: 'trash-o'
        name: 'Delete'
        shorthand: 'delete'
        appendix: '{{selectionLength}} $t(objects.Box.file, {"count": {{selectionLength}}})/$t(objects.Box.folder, {"count": {{selectionLength}}})'
      'lock':
        icon: 'lock'
        name: 'Lock'
        shorthand: 'lock'
        appendix: '{{selectionLength}} $t(objects.Box.file, {"count": {{selectionLength}}})'
      'addCollaborator':
        icon: 'user-plus'
        name: 'Add collaborator'
        shorthand: 'add collaborator'
        appendix: 'to {{selectionLength}} $t(objects.Box.folder, {"count": {{selectionLength}}})'
      'removeCollaborator':
        icon: 'user-times'
        name: 'Remove collaborator'
        shorthand: 'remove collaborator'
        appendix: 'from {{selectionLength}} $t(objects.Box.folder, {"count": {{selectionLength}}})'
      'assignTask':
        icon: 'user'
        name: 'Assign task'
        shorthand: 'assign task'
        appendix: 'on {{selectionLength}} $t(objects.Box.file, {"count": {{selectionLength}}})'
      'completeTask':
        icon: 'check'
        name: 'Complete task'
        shorthand: 'complete task'
        appendix: 'on {{selectionLength}} $t(objects.Box.file, {"count": {{selectionLength}}})'
      'addTag':
        icon: 'tag'
        name: 'Add tag'
        shorthand: 'add tag'
        appendix: 'to {{selectionLength}} $t(objects.Box.file, {"count": {{selectionLength}}})/$t(objects.Box.folder, {"count": {{selectionLength}}})'
      'deleteTags':
        icon: 'trash-o'
        name: 'Delete'
        shorthand: 'delete'
        appendix: '{{selectionLength}} $t(objects.Box.tag, {"count": {{selectionLength}}})'
      'deleteComments':
        icon: 'trash-o'
        name: 'Delete'
        shorthand: 'delete'
        appendix: '{{selectionLength}} $t(objects.Box.comment, {"count": {{selectionLength}}})'
      'changeNotificationSetting':
        icon: 'envelope-o'
        name: 'Change notification setting'
        shorthand: 'change notification setting'
        appendix: 'for {{selectionLength}} $t(objects.Box.user, {"count": {{selectionLength}}})'
    'Buffer':
      'upload':
        icon: 'upload'
        name: 'Upload'
        shorthand: 'upload'
        appendix: '{{selectionLength}} $t(objects.Buffer.post, {"count": {{selectionLength}}})'
      'copy':
        icon: 'copy'
        name: 'Copy'
        shorthand: 'copy'
        appendix: '{{selectionLength}} $t(objects.Buffer.post, {"count": {{selectionLength}}})'
      'edit':
        icon: 'pencil'
        name: 'Edit'
        shorthand: 'edit'
        appendix: '{{selectionLength}} $t(objects.Buffer.post, {"count": {{selectionLength}}})'
      'delete':
        icon: 'trash-o'
        name: 'Delete'
        shorthand: 'delete'
        appendix: '{{selectionLength}} $t(objects.Buffer.post, {"count": {{selectionLength}}})'
      're-buffer':
        icon: 'refresh'
        name: 'Re-Buffer'
        shorthand: 're-buffer'
        appendix: '{{selectionLength}} $t(objects.Buffer.post, {"count": {{selectionLength}}})'
      'add-prefix-suffix':
        icon: 'code'
        name: 'Add prefix/suffix before buffering'
        shorthand: 'add prefix/suffix before buffering'
        appendix: 'to {{selectionLength}} $t(objects.Buffer.post, {"count": {{selectionLength}}})'
      'use-rss-feed':
        icon: 'rss'
        name: 'Use RSS feed'
        shorthand: 'use RSS feed'
        appendix: 'to buffer {{selectionLength}} $t(objects.Buffer.post, {"count": {{selectionLength}}})'
      'upload':
        icon: 'upload'
        name: 'Upload'
        shorthand: 'upload'
        appendix: '{{selectionLength}} $t(objects.Buffer.post, {"count": {{selectionLength}}})'
      'schedule-repeated':
        icon: 'repeat'
        name: 'Schedule'
        shorthand: 'schedule'
        appendix: '{{selectionLength}} repeated $t(objects.Buffer.post, {"count": {{selectionLength}}})'
    'Evernote':
      'add-tag':
        icon: 'tag'
        name: 'Add tag'
        shorthand: 'add tag'
        appendix: 'to {{selectionLength}} $t(objects.Evernote.note, {"count": {{selectionLength}}})'
      'remove-tag':
        icon: 'trash-o'
        name: 'Remove tag'
        shorthand: 'remove tag'
        appendix: 'to {{selectionLength}} $t(objects.Evernote.note, {"count": {{selectionLength}}})'
      'delete':
        icon: 'trash-o'
        name: 'Delete'
        shorthand: 'delete'
        appendix: '{{selectionLength}} $t(objects.Evernote.note, {"count": {{selectionLength}}})'
    'Trello':
      sort:
        name: 'Sort inside list'
        shorthand: 'sort'
        appendix: '{{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      move:
        name: 'Move to another list/board'
        shorthand: 'move'
        appendix: '{{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      copy:
        name: 'Copy to another list/board'
        shorthand: 'copy'
        appendix: '{{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      setDesc:
        name: 'Set description'
        shorthand: 'set description'
        appendix: 'of {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      replaceName:
        name: 'Find and replace in name'
        shorthand: 'find-replace names'
        appendix: 'of {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      replaceDesc:
        name: 'Find and replace in description'
        shorthand: 'find-replace descriptions'
        appendix: 'of {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      addLabel:
        name: 'Add label'
        shorthand: 'add label'
        appendix: 'to {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      removeLabel:
        name: 'Remove label'
        shorthand: 'remove label'
        appendix: 'from {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      addMember:
        name: 'Add member'
        shorthand: 'add member'
        appendix: 'to {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      removeMember:
        name: 'Remove member'
        shorthand: 'remove member'
        appendix: 'from {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      setDue:
        name: 'Set due date'
        shorthand: 'set due date'
        appendix: 'on {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      unsetDue:
        name: 'Remove due date'
        shorthand: 'remove due date'
        appendix: 'from {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      copyChecklist:
        name: 'Copy checklist'
        shorthand: 'copy checklist'
        appendix: 'to {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      removeChecklist:
        name: 'Remove checklist'
        shorthand: 'remove checklist'
        appendix: 'from {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      completeCheckItem:
        name: 'Mark checklist item as complete'
        shorthand: 'mark checklist item as complete'
        appendix: 'on {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      removeAttachment:
        name: 'Remove attachment'
        shorthand: 'remove attachment'
        appendix: 'on {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      mergeDesc:
        name: 'Merge descriptions'
        shorthand: 'merge descriptions'
        appendix: 'of {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      addComment:
        name: 'Add comment'
        shorthand: 'add comment'
        appendix: 'to {{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      link:
        name: 'Link'
        shorthand: 'link'
        appendix: '{{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      archive:
        name: 'Archive'
        shorthand: 'archive'
        appendix: '{{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      delete:
        name: 'Delete'
        shorthand: 'delete'
        appendix: '{{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
      unarchive:
        name: 'Send to board from archive'
        shorthand: 'unarchive'
        appendix: '{{selectionLength}} $t(objects.Trello.card, {"count": {{selectionLength}}})'
  Steps:
    ChooseAvatar:
      icon: "plug"
      default: "Connect {{api}} account"
      complete_with_image: "<img src='{{avatar.imageUrl}}' class='avatar-image'> {{avatar.name}}"
      complete_without_image: "{{avatar.name}}"
      revert: "change"
      change: "change"
      connect: "Connect {{api}} account"
      add: "add another account"
      loading: "Loading {{api}} accounts..."
    ChooseBasicAvatar:
      icon: "plug"
      addIcon: "plug"
      default: "Choose {{api}} account"
      complete_with_image: "<img src='{{avatar.imageUrl}}' class='avatar-image'> {{avatar.name}}"
      complete_without_image: "{{avatar.name}}"
      revert: "switch accounts"
      change: "switch accounts"
      connect: "Connect to {{api}}"
      add: "add another account"
      loading: "Loading {{api}} accounts..."
      addTemplate:
        username:
          label: "Username"
          placeholder: "Your {{api}} username"
        password:
          label: "Password"
          placeholder: "Your {{api}} password"
        submit: "add {{api}} account"
        cancel: "choose existing account"
      addShipStationTemplate:
        key:
          label: "API Key"
          placeholder: "Your {{api}} API Key"
        secret:
          label: "API Secret"
          placeholder: "Your {{api}} API Secret"
        submit: "add {{api}} account"
        cancel: "choose existing account"
      add_3DCartTemplate:
        url:
          label: "Url"
          placeholder: "Your 3DCart Store Url"
        token:
          label: "Token"
          placeholder: "Your 3DCart Token"
        privateKey:
          label: "Private Key"
          placeholder: "Your 3DCart Private Key"
        submit: "add 3DCart account"
        cancel: "choose existing account"
      addFreshdeskTemplate:
        domain:
          label: "Domain"
          placeholder: "Your {{api}} Store Domain"
        username:
          label: "Username"
          placeholder: "Your {{api}} Username"
        password:
          label: "Password"
          placeholder: "Your {{api}} Password"
        submit: "add {{api}} account"
        cancel: "choose existing account"
    AcquireCredential:
      icon: "plug"
      default: "Connect to {{api}}"
      complete: "Connected to {{api}}"
      revert: "disconnect"
      change: "disconnect"
    GoogleDriveLoadSpreadsheets:
      icon: "google"
      default: "Load files from Google Drive"
      active: "Loading {{total}} files from Google Drive"
      complete: "Loaded {{total}} files from Google Drive"
      revert: "clear"
      refresh: "refresh"
    ChooseSpreadsheet:
      icon: "file-excel-o"
      default: "Choose spreadsheet"
      complete: "Chosen <a href='{{alternateLink}}' target='_blank'>{{title}}</a>"
      revert: "reset"
      change: "change"
      placeholder: "Choose target spreadsheet..."
    ChooseAxialModel:
      icon: "bars"
      default: "Choose row model"
      complete: "Chosen one {{_model}} per spreadsheet row"
      revert: "reset"
      change: "change"
      placeholder: "Choose model..."
      submit: "Choose"
      one: "One"
      perRow: "per spreadsheet row"
    ChooseColumns:
      icon: "columns"
      default: "Choose spreadsheet columns"
      complete: "Sync {{count}} column"
      complete_plural: "Sync {{count}} columns"
      revert: "reset"
      change: "change"
      placeholder: "Choose columns..."
      help: "Reorder columns by dragging them with mouse"
      submit: "Choose"
      one: "one"
      perRow: "per spreadsheet row"
    TrelloSyncWithSpreadsheet:
      icon: "exchange"
      default: "Synchronize"
      execute: "Synchronize"
      complete: "Synchronized <a href='{{alternateLink}}' target='_blank'>{{title}}</a>"
      revert: "cancel"
      refresh: "refresh"
    SelectDateRange:
      icon: "calendar"
      default: "Choose batch dates"
      complete: "Batch dates: {{dateFrom}} - {{dateTo}}"
      revert: "reset"
      change: "change"
      placeholderFrom: "Start date"
      placeholderTo: "End date"
      submit: "Choose"
  billing:
    action: 'action'
    action_plural: 'actions'
    time:
      second: '{{count}} second'
      second_plural: '{{count}} seconds'
      minute: '{{count}} minute'
      minute_plural: '{{count}} minutes'
      hour: '{{count}} hour'
      hour_plural: '{{count}} hours'
, true)
