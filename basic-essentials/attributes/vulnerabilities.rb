default['vulnerabilities']['pin_version']=true
default['vulnerabilities']['install']['packages'] ={
  'amazon' =>{
    '2017.03' => {
      'kernel'          =>  '4.9.32-15.41.amzn1',
      'kernel-tools'    =>  '4.9.32-15.41.amzn1',
      'glibc'           =>  '2.17-157.170.amzn1',
      'glibc-common'    =>  '2.17-157.170.amzn1',
      'sudo'            =>  '1.8.6p3-28.25.amzn1',
      'nss'             =>  '3.28.4-1.2.79.amzn1',
      'nss-sysinit'     =>  '3.28.4-1.2.79.amzn1',
      'nss-tools'       =>  '3.28.4-1.2.79.amzn1',
      'libtirpc'        =>  '0.2.4-0.8.14.amzn1',
      'rpcbind'         =>  '0.2.0-13.9.amzn1',
      'curl'            =>  '7.51.0-6.74.amzn1',
      'libcurl'         =>  '7.51.0-6.74.amzn1'
    }
  },
  'centos' => {
    '7.3.1611' => {
      'kernel'          =>  '3.10.0-514.10.2.el7',
      'kernel-tools'    =>  '3.10.0-514.10.2.el7',
      'glibc'           =>  '2.17-157.el7_3.4',
      'glibc-common'    =>  '2.17-157.el7_3.4',
      'sudo'            =>  '1.8.6p7-21.el7_3',
      'nss'             =>  '3.28.4-1.2.el7_3',
      'nss-sysinit'     =>  '3.28.4-1.2.el7_3',
      'nss-tools'       =>  '3.28.4-1.2.el7_3',
      'libtirpc'        =>  '0.2.4-0.8.el7_3',
      'rpcbind'         =>  '0.2.0-38.el7_3.1'

    },
  '7.2.1511' => {
      'kernel'          =>  '3.10.0-514.10.2.el7',
      'kernel-tools'    =>  '3.10.0-514.10.2.el7',
      'glibc'           =>  '2.17-157.el7_3.4',
      'glibc-common'    =>  '2.17-157.el7_3.4',
      'sudo'            =>  '1.8.6p7-21.el7_3',
      'nss'             =>  '3.28.4-1.2.el7_3',
      'nss-sysinit'     =>  '3.28.4-1.2.el7_3',
      'nss-tools'       =>  '3.28.4-1.2.el7_3',
      'libtirpc'        =>  '0.2.4-0.8.el7_3',
      'rpcbind'         =>  '0.2.0-38.el7_3.1'

    }
  }
}
