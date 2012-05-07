root = exports ? this

class FBClient 
  APP_ID    = '' # Your FB app ID
  HOST_NAME = '' # Your hostname for the channel file
  constructor: ->
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
    FB.getLoginStatus (response) =>
      console.log 'status: ', response.status
      switch response.status
        when 'connected'
          @uid = response.authResponse.userID
          @accessToken = response.authResponse.accessToken
          console.log 'Welcome back.'
          fbUser = new FBUser() unless fbUser
        when 'not_authorized', 'unknown' then @loginFB()
        else no
        
  loginFB: ->
    FB.login (response) =>
      console.log 'User cancelled login or did not fully authorize.' unless response.authResponse    
      if response.authResponse
        console.log 'Welcome!  Fetching your information.... '
        fbUser = new FBUser() unless fbUser
    , {scope: 'publish_actions'}
    
class FBUser
  constructor: ->
    FB.api '/me', (response) =>
      console.log @
      # self.data = response
      @name = response.name  
      console.log "Welcome #{@name}"       
    
fbUser = null


window.fbAsyncInit = ->
	fbClient = new FBClient()

    
