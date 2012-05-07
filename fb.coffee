class FBClient 
  APP_ID    = '' # Your FB app ID
  HOST_NAME = '' # Your hostname for the channel file
  self      = @  # is it proper way to deal with closure 'this' issue?
  constructor: ->
    self = @ # is it proper way to deal with closure 'this' issue?
    @initFB()
  initFB: ->
  	FB.init
      appId      : APP_ID
      channelUrl : "//#{HOST_NAME}/channel.html"
      status     : true, # check login status
      cookie     : true, # enable cookies to allow the server to access the session
      xfbml      : true  # parse XFBML
    @verifyStatus()
  verifyStatus: ->
    FB.getLoginStatus (response)->
      switch response.status
        when 'connected'
          self.uid = response.authResponse.userID
          self.accessToken = response.authResponse.accessToken
          console.log 'Welcome back.'
          fbUser = new FBUser() unless fbUser
        when 'not_authorized' then self.loginFB()
        else no
        
  loginFB: ->
    FB.login (response)->
      console.log 'User cancelled login or did not fully authorize.' unless response.authResponse    
      if response.authResponse
        console.log 'Welcome!  Fetching your information.... '
        fbUser = new FBUser() unless fbUser
    , {scope: 'email, user_likes'}
    
class FBUser
  self = @
  constructor: ->
    self = @
    FB.api '/me', (response) ->
      # self.data = response
      self.name = response.name  
      console.log "Welcome #{self.name}"    
    
fbUser = null

window.fbAsyncInit = ->
	fbClient = new FBClient()

    
