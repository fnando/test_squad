module('Router', {setup: function(){
  App.reset();
}});

test('root route', function() {
  visit('/');

  andThen(function(){
    equal(currentRouteName(), 'index');
  });
});
