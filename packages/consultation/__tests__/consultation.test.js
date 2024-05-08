'use strict';

const consultation = require('..');
const assert = require('assert').strict;

assert.strictEqual(consultation(), 'Hello from consultation');
console.info('consultation tests passed');
