function deepExtend(obj) {
    slice = Array.prototype.slice;

  _.each(slice.call(arguments, 1), function(source) {
    for (var prop in source) {
      if (_.isUndefined(obj[prop]) || _.isFunction(obj[prop]) || _.isNull(source[prop]) || _.isDate(source[prop])) {
        obj[prop] = _.clone(source[prop]);
      } else if (_.isArray(obj[prop]) || _.isArray(source[prop])) {
        if (!_.isArray(obj[prop]) || !_.isArray(source[prop])){
          throw new Error('Trying to combine an array with a non-array (' + prop + ')');
        } else {
          obj[prop] = _.reject(_.deepExtend(_.clone(obj[prop]), _.clone(source[prop])), function (item) { return _.isNull(item);});
        }
      } else if (_.isObject(obj[prop]) || _.isObject(source[prop])) {
        if (!_.isObject(obj[prop]) || !_.isObject(source[prop])){
          throw new Error('Trying to combine an object with a non-object (' + prop + ')');
        } else {
          obj[prop] = _.deepExtend(_.clone(obj[prop]), _.clone(source[prop]));
        }
      } else {
        obj[prop] = _.clone(source[prop]);
      }
    }
  });
  return obj;
}

function deepClone(object) {
  var clone = _.clone(object);

  _.each(clone, function(value, key) {
    if (_.isObject(value)) {
      clone[key] = _.deepClone(value);
    }
  });

  return clone;
}

function autovalues(obj) {
  var length = arguments.length;
  if (length < 2 || obj == null) return obj;
  for (var index = 1; index < length; index++) {
    var source = arguments[index];
    for (var property in source) {
      if (obj[property] === void 0) {
        if (_.isFunction(source[property])) {
          obj[property] = source[property](obj, property);
        } else {
          obj[property] = source[property];
        }
      }
    }
  }
  return obj;
}

function prepend(func, predendix) {
  return _.wrap(func, function (parent) {
    var args = Array.prototype.slice(arguments, 1);
    predendix.apply(this, args);
    parent.apply(this, args)
  })
}

_.mixin({
  deepExtend: deepExtend,
  deepClone: deepClone,
  autovalues: autovalues,
  prepend: prepend
});
