var system = require('system');

var COLORS = {
  red: '\033[31m',
  green: '\033[32m',
  yellow: '\033[33m',
  gray: '\033[0;37m',
  clear: '\033[0m'
};

function colored(message, color) {
  var color = COLORS[color] || COLORS.clear;

  return color + message + COLORS.clear;
}

function output(message, color) {
  system.stdout.write(colored(message, color));
}

function textForSelector(page, selector) {
  return page.evaluate(function(selector){
    return document.querySelector(selector).textContent.replace(/\s+/mg, ' ').trim();
  }, selector);
}

module.exports = {
  colored: colored,
  output: output,
  textForSelector: textForSelector
};
