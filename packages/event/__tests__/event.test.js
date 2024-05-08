'use strict';

const event = require('..');
const assert = require('assert').strict;

assert.strictEqual(event(), 'Hello from event');
console.info('event tests passed');
