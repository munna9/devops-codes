#<%=@node['leantaas']['banner']%>
upstream <%=@service_name%> {
<% @hosts.each do |host_name| %>
  server <%= host_name %>:<%=@port%>;
<% end %>
  keepalive 10;
}
server {
  listen 80;
  server_name <%=@uri%>;
  return 301 https://$server_name$request_uri;
}
server {
  listen       <%=@service_port%>;
  server_name  <%=@uri%>;
  ssl                  on;
  ssl_certificate      <%=@node['nginx']['ssl']['base_dir']%>/<%=@ssl_certificate%>.crt;
  ssl_certificate_key  <%=@node['nginx']['ssl']['base_dir']%>/<%=@ssl_certificate%>.key;
  ssl_session_timeout  5m;
  ssl_protocols  TLSv1.2 TLSv1.1 TLSv1;
  ssl_ciphers  "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
  ssl_prefer_server_ciphers   on;
  access_log <%=@node['nginx']['conf']['log_dir']%>/<%=@service_name%>-access.log;
  error_log <%=@node['nginx']['conf']['log_dir']%>/<%=@service_name%>-error.log;
  location / {
    root   html;
  index  index.html index.htm;
  ajp_keep_conn on;
  ajp_connect_timeout      <%=@node['nginx']['conf']['ajp_connect_timeout']%>;
    ajp_send_timeout         <%=@node['nginx']['conf']['ajp_send_timeout']%>;
  ajp_read_timeout         <%=@node['nginx']['conf']['ajp_read_timeout']%>;
    send_timeout             <%=@node['nginx']['conf']['send_timeout']%>;
  ajp_pass <%=@service_name%>;
  }
}