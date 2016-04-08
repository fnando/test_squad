Mocha.reporters.PhantomJS = function(runner) {
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

  var start;

  runner.on("pass", function(test){
    stats.passes += 1;
  });

  runner.on("fail", function(test, err){
    stats.fails += 1;
  });

  runner.on("pending", function(suite){
    stats.pending += 1;
  });

  runner.on("start", function(test){
    start = new Date().getTime();
  });

  runner.on("end", function(){
    stats.elapsed = new Date().getTime() - start;
    callPhantom({
      name: "end",
      stats: stats
    });
  });

  runner.on("test", function(test){
    stats.tests += 1;

    callPhantom({
      name: "test start",
      title: test.title
    });
  });

  runner.on("test end", function(test){
    if (test.state === "failed") {
      var error = test.err.stack || test.err.toString();

      // FF / Opera do not add the message
      if (!~error.indexOf(test.err.message)) {
        error = test.err.message + "\n" + error;
      }

      // <=IE7 stringifies to [Object Error]. Since it can be overloaded, we
      // check for the result of the stringifying.
      if ("[object Error]" == error) {
        error = test.err.message;
      }

      // Safari doesn"t give you a stack. Let"s at least provide a source line.
      if (!test.err.stack && test.err.sourceURL && test.err.line !== undefined) {
        error += "\n(" + test.err.sourceURL + ":" + test.err.line + ")";
      }

      error = error.replace(/^\s+at .*?assets\/mocha\/.*?\.js.*?$/mg, "");
      error = error.replace(/^\s+at .*?assets\/expect\/.*?\.js.*?$/mg, "");
      error = error.replace(/^\s+at .*?assets\/should\/.*?\.js.*?$/mg, "");
      error = error.replace(/^\s+at .*?assets\/chai\/.*?\.js.*?$/mg, "");
      error = error.replace(/\n+$/, "");
    }

    callPhantom({
      name: "test end",
      title: test.title,
      passed: test.state === "passed",
      pending: test.pending,
      failure: error
    });
  });

  runner.on("suite", function(suite){
    callPhantom({
      name: "suite start",
      title: suite.title
    });
  });

  runner.on("suite end", function(suite){
    callPhantom({
      name: "suite end",
      title: suite.title
    });
  });
};

mocha.TestSquad = function(runner) {
  new Mocha.reporters.HTML(runner);
  new Mocha.reporters.PhantomJS(runner);
};
