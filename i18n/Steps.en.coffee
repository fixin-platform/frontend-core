i18n.addResourceBundle("en", "translation",
  Steps:
    defaults:
      run: "test now"
      running: "running"
      cancel: "cancel"
      test: "test"
      manualRun: '<a href="#" class="run">Run the export</a> manually to ensure it works as expected ($t(Steps.defaults.runsLeft, {"count": {{runsLeft}}}})).'
      runsLeft: "{{count}} trial run left"
      runsLeft_plural: "{{count}} trial runs left"
, true)
