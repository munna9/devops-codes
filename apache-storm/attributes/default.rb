
default['storm']['app']['base_directory'] = '/opt'
default['storm']['app']['home_directory'] = "#{node['storm']['app']['base_directory']}/storm"
default['storm']['log']['home_directory'] = "#{node['storm']['app']['home_directory']}/logs"
default['storm']['conf']['home_directory'] = "#{node['storm']['app']['home_directory']}/conf"
_memory_in_mb=case node['os']
              when 'linux'
                  node['memory']['total'][/\d*/].to_i/1024
              end
default['storm']['worker']['memory_ceiling']=0.70
default['storm']['worker']['processes']=8
_heap_memory=(_memory_in_mb*node['storm']['worker']['memory_ceiling']).to_i/node['storm']['worker']['processes']
default['storm']['worker']['heap.memory.mb']=_heap_memory
default['storm']['worker']['max.heap.size.mb']=_heap_memory
default['storm']['topology']['sleep.spout.wait.stratergy.time.ms']=1000
default['storm']['nimbus']['ui_port'] = 8881
default['storm']['conf']['options'] ={
  'ui.port'                                      =>  node['storm']['nimbus']['ui_port'],
  'worker.heap.memory.mb'                        =>  node['storm']['worker']['heap.memory.mb'],
  'worker.max.heap.size.mb'                      =>  node['storm']['worker']['max.heap.size.mb'],
  'storm.zookeeper.port'                         =>  node['zookeeper']['conf']['clientPort'],
  'storm.local.dir'                              =>  "#{node['storm']['app']['home_directory']}/local",
  'topology.sleep.spout.wait.stratergy.time.ms'  =>  node['storm']['topology']['sleep.spout.wait.stratergy.time.ms'],
  'worker.childopts'                             =>  '"-Dfile.encoding=UTF-8 -XX:+PrintGCDetails -Xloggc:artifacts/gc.log -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=1M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=artifacts/heapdump"'
}

default['storm']['conf']['file'] = "#{node['storm']['conf']['home_directory']}/storm.yaml"
default['storm']['conf']['env_file'] = "#{node['storm']['conf']['home_directory']}/storm_env.ini"

default['storm']['container']['read_timeout']=30
default['storm']['container']['write_timeout']=30
default['storm']['container']['kill_after']=30

default['storm']['kafka-repo']['uri'] = 'git@bitbucket.org:maheimom/storm-kafka-repo.git'
default['storm']['kafka-repo']['checkout_directory'] = 'phenomtracker'
default['storm']['kafka-repo']['branch'] = 'developer'
