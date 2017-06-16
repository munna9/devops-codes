from bitbucket.bitbucket import Bitbucket
USERNAME = raw_input('what is ur USERNAME')
PASSWORD = raw_input('what is urPASSWORD')
cred = Bitbucket(USERNAME,PASSWORD)
x = raw_input('What is your reponame?')
success,result=cred.repository.create(x)

