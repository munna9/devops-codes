aws_credentials=data_bag_item('credentials','icinga')
http_request 'salt-ticket' do
  url "http://#{node['icinga']['master']}:#{node['icinga']['listner']['port']}/v1/actions/generate-ticket"
  message({:cn => "#{node['fqdn']}"}.to_json)
  headers({'AUTHORIZATION' => "Basic #{ Base64.encode64('root:1369e88bf2a0747d') }",
           'Content-Type' => 'application/data'
          })
  action :post
end