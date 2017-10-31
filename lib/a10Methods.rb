module MyMethods

  def MyMethods.loggingOn(data_hash)
 
    user = data_hash['mgmt-user']
    password = data_hash['mgmt-password']
    ip = data_hash['mgmt-ip']
    auth = data_hash['api-auth']
    url = "https://"+ip+auth
 
    my_hash = {:"credentials" => {:"username" => user, :"password" => password}}
    robot = JSON.generate(my_hash)

    res = MyMethods.http(url, 'POST', robot)
    return sign = res['authresponse']['signature']
  end

  def MyMethods.loggingOff(data_hash, sign)
 
    ip = data_hash['mgmt-ip']
    api_logoff = data_hash['api-logoff']
    url = "https://"+ip+api_logoff

    MyMethods.http(url, 'GET', nil, sign)
  end

  def MyMethods.switch(data_hash, sign, part)
 
    ip = data_hash['mgmt-ip']
    api_part = data_hash['api-part']
    url_part = "https://"+ip+api_part
    url = url_part+'/'+part

    MyMethods.http(url, 'POST', nil, sign)
  end

  def MyMethods.JsonToHash(file)
    data = File.read(file)
    return data_hash = JSON.parse(data)
  end

  def MyMethods.http(url, method = 'GET', json = nil, sign = nil)

    uri = URI.parse(url)

    case method
    when 'GET'
      req = Net::HTTP::Get.new(uri)
    when 'POST'
      req = Net::HTTP::Post.new(uri)
    when 'DELETE'
      req = Net::HTTP::Delete.new(uri)
    end

    req['Content-Type'] = 'application/json'
    unless json.nil? 
      req.body = json
    end	    
    unless sign.nil? 
      req['Authorization'] = 'A10 '+sign
    end	    

    res = Net::HTTP.start(
      uri.host,
      uri.port,
      :use_ssl => uri.scheme == 'https',
      :verify_mode => OpenSSL::SSL::VERIFY_NONE
      ) { |http| http.request(req) }

    #p res.body
    #p res.code
    
    return JSON.parse(res.body)
  end

end
