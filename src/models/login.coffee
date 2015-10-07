request = require 'superagent'
config  = require '../config'
User    = require './users'
async   = require 'async'
_       = require 'underscore'
q       = require 'q'

class Login

    mock_identity_broker =
        userTest1:
            intranetId: "1"
            avatar: "https://placeholdit.imgix.net/~text?txtsize=10&txt=default&w=80&h=80"
        userTest2:
            intranetId: "2"
            avatar: "https://placeholdit.imgix.net/~text?txtsize=10&txt=default&w=80&h=80"
        userTest3:
            intranetId: "3"
            avatar: "https://placeholdit.imgix.net/~text?txtsize=10&txt=default&w=80&h=80"

    otpValidate = (reqId, otpHint, cb) ->
        request.post config.auth.endpoint
        .send
            requestType: "OTP_VALIDATE"
            requestId: reqId
            otpInfo:
                otpValue: otpHint
                otpHint: otpHint
        .end (e, response) ->
            body = response.body

            if body.status == "COMPLETED"
                cb(null, body)
            else
                error = new Error "Expected COMPLETE response."
                error.response = response.body
                cb error

    otpGenerate = (reqId, otpMethodId, next) ->
        request.post config.auth.endpoint
        .send
            requestType: "OTP_GENERATE"
            requestId: reqId
            otpInfo:
                otpMethodId: otpMethodId
        .end (e, response) ->
            if response.body.otpHint
                next null, response.body.otpHint
            else
                error = new Error "Expected otpHint."
                error.response = response.body
                next error
                

    perform: (params) ->
        deferred = q.defer()

        { username, password, deviceId } = params

        resolve_p = (e, result) ->
            user_query

            if e
                deferred.reject e
            else
                user_query = User.findOne name: username

                user_query.select "name"

                user_query.exec (e, user) ->
                    if e
                        deferred.reject e

                    if user
                        deferred.resolve _.extend result, user

                    else
                        user = new User _.extend name: username,
                            mock_identity_broker[username]

                        user.save()

                        deferred.resolve _.extend result, user

        async.waterfall [
            (cb) ->
                request.post config.auth.endpoint
                .send
                    requestType: "AUTHENTICATE"
                    deviceId: deviceId
                    clientId: config.auth.client_id
                    authInfo: _.pick params, 'username', 'password', 'clientId'
                .end cb
            (response, cb) ->
                body = response.body
                if body.status == 'ERROR'
                    cb { status: 400, message: body.error }
                else if body.status == 'COMPLETED'
                    cb null, body
                else if body.otpHint
                    otpValidate body.requestId, body.otpHint, cb
                else if body.status == 'OTP_DELIVERY_METHOD_SENT'
                    methodId = body.otpDeliveryMethods[0].methodId
                    otpGenerate body.requestId, methodId, (e, otpHint) ->
                        otpValidate body.requestId, otpHint, cb
                else
                    error = new Error "Unknown response from token service"
                    error.response = body
                    cb error
        ], resolve_p

        deferred.promise


module.exports = new Login