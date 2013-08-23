assert  = require 'assert'
DescendantsTracker  = require '../../support/descendants_tracker'

shared_specs = ->
  describe '#directDescendants', ->
    it 'tracks direct descendants', ->
      assert.deepEqual @Parent.directDescendants, [@Child1, @Child2]
      assert.deepEqual @Child1.directDescendants, [@GrandChild1]
      assert.deepEqual @Child2.directDescendants, [@GrandChild2]

  describe '#descendants', ->
    it 'tracks all descendants', ->
      assert.deepEqual @Parent.descendants, [@Child1, @Child2, @GrandChild1, @GrandChild2]
      assert.deepEqual @Child1.descendants, [@GrandChild1]
      assert.deepEqual @Child2.descendants, [@GrandChild2]


describe 'DescendantsTracker', ->
  context 'in simple case', ->
    before ->
      class @Parent extends require('coffee_classkit').Module
        @extendsWithProto().extend DescendantsTracker
      class @Child1 extends @Parent
        @extendsWithProto()
      class @Child2 extends @Parent
        @extendsWithProto()
      class @GrandChild1 extends @Child1
        @extendsWithProto()
      class @GrandChild2 extends @Child2
        @extendsWithProto()

    shared_specs()

  context 'with custom `inherited` hook', ->
    before ->
      @hooks = hooks = []

      class Base extends require('coffee_classkit').Module
        @extendsWithProto()

        @inherited: (klass) -> hooks.push "base: #{klass.name}"

      class @Parent extends Base
        @extendsWithProto().extend DescendantsTracker

        @inherited: (klass) ->
          hooks.push "parent: #{klass.name}"
          @trackDescendant klass
          super

      class @Child1 extends @Parent
        @extendsWithProto()

        @inherited: (klass) ->
          hooks.push "child: #{klass.name}"
          super

      class @Child2 extends @Parent
        @extendsWithProto()
      class @GrandChild1 extends @Child1
        @extendsWithProto()
      class @GrandChild2 extends @Child2
        @extendsWithProto()

    shared_specs()

    it 'runs all hooks', ->
      assert.deepEqual @hooks, [
        'base: Parent'
        'parent: Child1'
        'base: Child1'
        'parent: Child2'
        'base: Child2'
        'child: GrandChild1'
        'parent: GrandChild1'
        'base: GrandChild1'
        'parent: GrandChild2'
        'base: GrandChild2'
      ]
