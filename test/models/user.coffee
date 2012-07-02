require  './model_helper'
assert = require 'assert'
User = require '../../models/user'
mongodb = require 'mongodb'



describe 'User', ->
  
    it "can be searched by id", (done)->
        User.findById "4ed2b809d7446b9a0e000014", (err,obj)->
            if err?
                done err
            else
                assert.ok obj?
            done()

    it "returns null when id not found", (done)->
        User.findById "4ed2b309d7446b9a0e000014", (err,obj)->
            if err?
                done err
            else
                assert.ok not obj?
            done()

    it "returns allows per-filter research", (done)->
        User.find {}, (err,obj)->
            if err?
                done err
            else
                assert.ok 0 < obj.length < 10
            done()

    it "returns no item if your filter has no matchs", (done)->
        User.find { username: "Kevin"}, (err,obj)->
            if err?
                done err
            else
                assert.ok obj.length == 0
            done()

