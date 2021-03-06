/* jshint -W100 */
/* global phantom */
(function () {
  'use strict';

  var system = require('system');
  var webpage = require('webpage');
  var helpers = require('./helpers');
  var output = helpers.output;
  var colored = helpers.colored;
  var textForSelector = helpers.textForSelector;

  var args = system.args;
  var url = args[1];
  var timeout = parseInt(args[2], 10);
  var page = webpage.create();
  var suites = [];
  var suite, test;
  var errorBuffer = [];
  var pendingBuffer = [];
  var resourceErrors = [];

  page.viewportSize = {
    width: 800,
    height: 800
  };

  var testOutput = function(test) {
    if (test.passed) {
      output('•', 'green');
    } else if (test.pending) {
      output('*', 'yellow');
      pendingBuffer.push(testDescription(test, 'yellow'));
    } else {
      output('×', 'red');
      errorBuffer.push(testDescription(test, 'red'));
    }
  };

  var testDescription = function(test, color) {
    var status = test.pending? '[PENDING]' : '[FAILURE]';

    var description = test.suites.map(function(suite) {
      return suite.title;
    }).join(' ') + ' ' + test.title;

    description = status + ' ' + description.replace(/^\s+/gm, '');

    if (test.failure) {
      description += '\n';
      description += test.failure.replace(/^\s*/gm, '    ');
    }

    description = colored(description, color);

    if (test.logging.length) {
      description += '\n';

      for (var i = 0; i < test.logging.length; i++) {
        var lines = test.logging[i].split(/\r?\n/);
        description += '\n';
        description += colored('    => ' + lines.shift(), 'gray');

        if (lines.length > 0) {
          description += '\n';
          description += colored(lines.join('\n').replace(/^/gm, '       '), 'gray');
        }
      }
    }

    return description;
  };

  var pluralize = function(count, singular, plural) {
    if (!plural) {
      plural = singular + 's';
    }

    return count + ' ' + (count === 1 ? singular : plural);
  };

  page.onConsoleMessage = function(message) {
    if (test) {
      test.logging.push(message);
    } else {
      console.log(colored('=> ' + message, 'gray'));
    }
  };

  page.onResourceError = function(error) {
    resourceErrors.push(error);
  };

  page.onCallback = function(message){
    if (message.name === 'suite start') {
      suite = {tests: []};
      suite.title = message.title;

      if (message.title) {
        suites.push(suite);
      }
    } else if (message.name === 'suite end') {
      suites = [];
    } else if (message.name === 'test start') {
      test = {logging: []};
      test.suites = suites;
      suite.tests.push(test);
    } else if (message.name === 'test end') {
      test.title = message.title;
      test.passed = message.passed;
      test.pending = message.pending;
      test.failure = message.failure;
      testOutput(test);
      test = null;
    } else if (message.name === 'end') {
      var stats = message.stats;
      var summary = [];
      var color;
      var hasErrorBuffer = errorBuffer.length > 0;
      var hasPendingBuffer = pendingBuffer.length > 0;

      if (hasErrorBuffer || hasPendingBuffer) {
        console.log('');
      }

      if (hasErrorBuffer) {
        console.log('\n' + errorBuffer.join('\n\n'));
      }

      if (hasPendingBuffer) {
        console.log('\n' + pendingBuffer.join('\n'));
      }

      console.log('');

      if (stats.tests > 0) {
        summary.push(pluralize(stats.tests, 'test'));

        if (stats.assertions) {
          summary.push(pluralize(stats.assertions, 'assertion'));
        }

        if (stats.pending) {
          summary.push(pluralize(stats.pending, 'test') + ' pending');
        }

        if (stats.fails) {
          summary.push(pluralize(stats.fails, 'test') + ' failed');
        }
      } else {
        summary.push('No tests were found.');
      }

      if (stats.fails) {
        color = 'red';
      } else if (stats.pending) {
        color = 'yellow';
      } else {
        console.log('');
        color = 'green';
      }

      summary = colored(summary.join(', '), color);
      summary += colored(' (' + (stats.elapsed / 1000) + 's)', 'gray');

      console.log(summary);
      exit(stats.fails ? 1 : 0);
    }
  };

  page.open(url, function(status){
    if (status === 'fail') {
      console.error('Unable to access network: ' + status);
      exit(1);
    } else {
      if (resourceErrors.length === 1 && resourceErrors[0].url === url) {
        var errorHeader = textForSelector(page, 'header > h1');
        var errorDescription = textForSelector(page, '#container > pre');
        var matches = errorDescription.match(/^(.*?) \(in (.*?)\)$/)

        console.error(colored('ERROR:', 'red'), errorHeader, '-', matches[1]);
        console.error(colored(matches[2], 'gray'));
        exit(1);
      } else {
        setTimeout(function(){
          console.error(colored('ERROR:', 'red'), 'The specified timeout of ' + timeout + ' seconds has expired. Aborting...');
          exit(1);
        }, timeout * 1000);
      }
    }
  });

  function exit(code) {
    if (page) {
      page.close();
    }

    setTimeout(function(){
      phantom.exit(code);
    }, 0);
  }
})();
