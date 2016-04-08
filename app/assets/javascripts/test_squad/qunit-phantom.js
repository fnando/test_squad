(function(){
  if (!navigator.userAgent.match(/phantomjs/i)) {
    return;
  }

  var stats = {
    passes: 0,
    fails: 0,
    pending: 0,
    elapsed: 0,
    assertions: 0,
    tests: 0
  };

  var start, assertion;

  QUnit.testStart(function(data){
    assertion = null;
    stats.tests += 1;

    callPhantom({
      name: "test start",
      title: data.name
    });
  });

  QUnit.log(function(data){
    stats.assertions += 1;

    if (!assertion && !data.result) {
      assertion = data;
    }
  });

  QUnit.moduleStart(function(data){
    callPhantom({
      name: "suite start",
      title: data.name
    });
  });

  QUnit.testDone(function(data){
    var error;

    if (data.failed) {
      stats.fails += 1;
      error = assertion.message;

      if (assertion.source) {
        error += "\n" + assertion.source;
      }

      error = error.replace(/(Died on test #\d+)/gmi, "$1\n");
      error = error.replace(/^\s*/gm, "    ");
      error = error.replace(/^\s+at .*?assets\/qunit\/qunit.*?\.js.*?$/mg, "");
      error = error.replace(/\n+$/, "");
    } else if (data.skipped) {
      stats.pending += 1;
    } else {
      stats.passes += 1;
    }

    callPhantom({
      name: "test end",
      title: data.name,
      passed: data.failed === 0 && !data.skipped,
      pending: data.skipped,
      failure: error
    });
  });

  QUnit.begin(function(data){
    start = new Date().getTime();
  });

  QUnit.done(function(data){
    stats.elapsed = new Date().getTime() - start;

    callPhantom({
      name: "end",
      stats: stats
    });
  });
})();
