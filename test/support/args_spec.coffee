assert  = require 'assert'
Args    = require '../../support/args'

describe 'Arguments', ->
  describe '#findOptions', ->
    opts  = opts: 'opts'
    val1  = 'val1'
    val2  = 'val2'
    val3  = val: 'val'

    subject = Args.findOptions

    it 'returns [{}, []] if nothing is given', ->
      assert.deepEqual subject(), [{}, []]

    it 'returns [{}, []] if empty array is given', ->
      assert.deepEqual subject([]), [{}, []]

    it 'works if input array has one element', ->
      assert.deepEqual subject([opts]), [opts, []]
      assert.deepEqual subject([val1]), [{},   [val1]]

    it 'works if input array has two elements', ->
      assert.deepEqual subject([opts, val1]), [opts, [val1]]
      assert.deepEqual subject([val1, opts]), [opts, [val1]]
      assert.deepEqual subject([val1, val2]), [{},   [val1, val2]]

    it 'works if input array has more elements', ->
      assert.deepEqual subject([opts, val1, val2]), [opts, [val1, val2]]
      assert.deepEqual subject([val1, val2, opts]), [opts, [val1, val2]]
      assert.deepEqual subject([val1, val3, val2]), [{},   [val1, val3, val2]]

    it 'returns last element as options if first is an object too', ->
      assert.deepEqual subject([val3, val1, opts]), [opts, [val3, val1]]

    it 'works with arguments object', ->
      f = => subject arguments
      assert.deepEqual f(), [{}, []]
      assert.deepEqual f(opts), [opts,  []]
      assert.deepEqual f(val1), [{},    [val1]]
      assert.deepEqual f(opts, val1, val2), [opts, [val1, val2]]
      assert.deepEqual f(val1, val2, opts), [opts, [val1, val2]]
