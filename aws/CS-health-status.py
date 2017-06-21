import requests
import base64
import smtplib
from time import gmtime, strftime

def sendMail(msg):
    ToAddress = '<recipient_address>'
    FromAddress = '<sender_address>'
    with open('/etc/postfix/sasl/sasl_passwd', 'r') as text:
        passwd = text.read().replace('\n', '')
    passwd = passwd.decode('base64')
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.ehlo()
    server.starttls()
    server.ehlo()
    server.login(FromAddress,passwd)
    server.sendmail(FromAddress,ToAddress,msg)

#r = requests.get('https://chef-server01.phenompeople.com/_status', verify=False)
#r = requests.get('https://manage.chef.io/_status', verify=False)

x = r.json()
#print x
if x['status'] == 'fail':
    msg = "Chef server is unhealthy"
    sendMail(msg)
if x['upstreams']['chef_sql'] == 'fail':
    print "Chef_sql is healthy"
    sendMail (msg)
if x['upstreams']['chef_solr'] == 'fail':
    msg = "Chef_solr service is unhealthy"
    sendMail (msg)
if x['upstreams']['oc_chef_authz'] == 'fail':
    print "Chef_authz is unhealthy"
    sendMail(msg)





