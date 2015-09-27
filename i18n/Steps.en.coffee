i18n.addResourceBundle("en", "translation",
  Steps:
    defaults:
      run: "manually run now"
      running: "running"
      cancel: "cancel"
      test: "test"
      manualRun: '<a href="#" class="run">Manually run the export</a> to make sure it works as expected ($t(Steps.defaults.runsLeft, {"count": {{runsLeft}}}})).'
      runsLeft: "{{count}} trial run left"
      runsLeft_plural: "{{count}} trial runs left"
, true)
