(function(){
  jasmineRequire.phantom = function(j$) {
    if (!navigator.userAgent.match(/phantomjs/i)) {
      j$.PhantomReporter = function() { /* noop */ };
    } else {
      j$.PhantomReporter = jasmineRequire.PhantomReporter();
    }
  };

  jasmineRequire.PhantomReporter = function() {
    function PhantomReporter(options) {
      var stats = {
        passes: 0,
        fails: 0,
        pending: 0,
        elapsed: 0,
        assertions: 0,
        tests: 0
      };

      var start;

      this.jasmineStarted = function() {
        start = new Date().getTime();
      };

      this.jasmineDone = function() {
        stats.elapsed = new Date().getTime() - start;

        callPhantom({
          name: "end",
          stats: stats
        });
      };

      this.specStarted = function(result) {
        stats.tests += 1;

        callPhantom({
          name: "test start",
          title: result.description
        });
      };

      this.specDone = function(result) {
        var pending = result.status === "pending";
        var passed = result.status === "passed";
        var failed = result.status === "failed";
        var error, assertion;

        stats.assertions += result.failedExpectations.length;
        stats.assertions += result.passedExpectations.length;
        stats.pending += (pending ? 1 : 0);
        stats.passes += (passed ? 1 : 0);
        stats.fails += (failed ? 1 : 0);

        if (failed) {
          assertion = result.failedExpectations[0];
          error = assertion.stack.replace(/^\s*/gm, "    ");
          error = error.replace(/^\s+at .*?assets\/jasmine\/(jasmine|boot).*?\.js.*?$/mg, "");
          error = error.replace(/\n+$/, "");
        }

        callPhantom({
          name: "test end",
          title: result.description,
          passed: passed,
          pending: pending,
          failure: error
        });
      };

      this.suiteStarted = function(result) {
        callPhantom({
          name: "suite start",
          title: result.description
        });
      };

      return this;
    }

    return PhantomReporter;
  };
})();
