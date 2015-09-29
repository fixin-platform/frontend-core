i18n.addResourceBundle("en", "translation",
  Steps:
    defaults:
      run: "test now"
      running: "running"
      cancel: "cancel"
      test: "test"
      activatedTrial: 'You have activated the recipe in free trial mode ($t(Steps.defaults.runsLeft, {"count": {{runsLeft}}})). If all goes well, please <a href="/pricing">subscribe to a plan</a> to continue running it.<br/>... and if anything breaks, please <a href="mailto:denis.d.gorbachev@gmail.com" target="_blank">tell us</a> — we\'ll fix it pronto!'
      finishedTrial: 'You have reached the limit of free trial runs for this recipe. If you want to continue running the recipe, please <a href="/pricing">subscribe to a plan</a>.'
      manualRunTrial: '<a href="#" class="run">Run the export</a> manually to ensure it works as expected ($t(Steps.defaults.runsLeftTrial, {"count": {{runsLeft}}})).'
      manualRunNoTrial: '<a href="#" class="run">Run the export</a> manually to ensure it works as expected.'
      subscribe: '<a href="/pricing">Subscribe to a plan</a> to run this recipe automatically daily, or manually anytime.'
      runsLeftTrial: "{{count}} trial run left"
      runsLeftTrial_plural: "{{count}} trial runs left"
      runsLeftNoTrial: "{{count}} run left"
      runsLeftNoTrial_plural: "{{count}} runs left"
, true)
